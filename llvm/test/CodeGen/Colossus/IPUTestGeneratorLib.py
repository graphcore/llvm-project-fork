import sys
import os
import re
from itertools import izip, izip_longest

class TypeInfo:
    """
    Instance representing a type supported by LLVM. Holds the following info:
    - brty: name of the type in LLVM bytecode representation, or EVT type
      (eg. f16);
    - irty: name of the type in LLVM IR textual representation (eg. half);
    - elem_brty: name of type of elements composing this type in LLVM bytecode
      representation;
    - elem_irty: name of type of elements composing this type in LLVM IR
      textual representation;
    - arity: number of element for this type, None for scalar;
    - bitsize: size in bits of the type;
    - elem_bitsize: bitsize of elements composing this type;
    - reg_prefix: prefix to use to access registers holding values of that
    type.
    """

    # Napping from bytecode representation to textual representation for float
    # types.
    _float_br_to_ir = {"f16": "half", "f32": "float", "f64": "double"}

    def __init__(self, brty):
        """Constructor from bytecode type: sets up other info from brty."""

        if re.match(r"(v\d+)?(i|f)\d+", brty) is None:
            raise ValueError("Unrecognized type '{}'".format(brty))

        self.brty = brty
        if brty[0] == "v":
            self.arity = scale = int(brty[1])
            self.elem_brty = brty[2:]
        else:
            scale = 1
            self.arity = None
            self.elem_brty = brty
        self.elem_bitsize = int(self.elem_brty[1:])
        self.bitsize = scale * self.elem_bitsize
        self.elem_irty = (
            self.elem_brty
            if self.elem_brty[0] == "i"
            else TypeInfo._float_br_to_ir[self.elem_brty]
        )
        self.irty = (
            self.elem_irty
            if self.arity is None
            else "<{} x {}>".format(self.arity, self.elem_irty)
        )
        self.reg_prefix = "$a" if self.elem_brty[0] == "f" else "$m"

    def is_float(self):
        return self.reg_prefix == "$a"

    def is_integer(self):
        return not self.is_float()

    def is_scalar(self):
        return self.arity is None

    def is_vector(self):
        return not self.is_scalar()

_known_br = [
    "i8",
    "i16",
    "i32",
    "i64",
    "f16",
    "f32",
    "f64",
    "v2i8",
    "v2i16",
    "v2i32",
    "v2f16",
    "v2f32",
    "v4i16",
    "v4f16",
]
known_type_info_list = [TypeInfo(br) for br in _known_br]

def two_complement(val, bitsize):
    """
    Return val's bitpattern when interpreted as a bitsize-bit value in
    two's complement
    """
    if val < (1 << (bitsize - 1)):
        return val
    else:
        return val - (1 << bitsize)

def or_imm_check_str(immz12):
    """
    Return FileCheck pattern to check for OR immediate. Always print the operand
    value as an unsigned value as immz12 is described in the specification as an
    unsigned immediate. This avoids possible ambiguities with the actual signed
    immediate present in some instructions.
    """

    # Does not fit in setzi immediate alone
    assert immz12 & 0xFFF00000
    assert not immz12 & 0xFFFFF

    return str(immz12)

def get_range_re_from_list(l):
    """Return the smallest range regex suitable to match the digits in l."""

    assert l
    l.sort()
    range_re = '['
    start = end = -2
    for e in l:
        val = int(e)
        if val == end + 1:
            end = val
        else:
            if start == end:
                range_re += str(val)
            else:
                range_re += '-{}{}'.format(end, val)
            start = end = val
    if start != end:
        range_re += '-{}'.format(end)
    range_re += ']'
    return range_re

arf_caller_saved = range(6)
mrf_caller_saved = range(7)

def gen_const_load_check(constants, to_regs, Ti, clobs, prefix):
    """
    Return the FileCheck directives to check for constants to be loaded into
    registers to_regs with scratch registers clobs available. The type of the
    value corresponding to those constants is held in Ti while to_regs and
    clobs are given as list of register number. FileCheck directives are to be
    prefixed by prefix.
    """

    nb_regs = len(to_regs)
    assert nb_regs in (1, 2)
    if (
        nb_regs == 2
        and Ti.is_float()
        and constants[0] == 0xFFFFFFFF
        and constants[1] == 0xFFFFFFFF
    ):
        regpair = "{}{}:{}".format(Ti.reg_prefix, to_regs[0], to_regs[1])
        return "; CHECK-NEXT: {}not64 {}, $a14:15\n".format(prefix, regpair)

    ret = ""
    prev_const = None
    prev_reg = None
    for regno, const in izip_longest(to_regs, constants):
        if regno is None or const is None:
            continue
        reg = '{}{}'.format(Ti.reg_prefix, regno)
        low20 = const & 0xFFFFF
        hi12 = const & 0xFFF00000
        if const == 0xFFFFFFFF and Ti.is_float():
            ret += "; CHECK-NEXT: {}not {}, $a15\n".format(prefix, reg)
        elif const == 0:
            ret += "; CHECK-NEXT: {}mov {}, {}15\n".format(prefix, reg, Ti.reg_prefix)
        elif prev_const == const:
            ret += "; CHECK-NEXT: {}mov {}, {}\n".format(prefix, reg, prev_reg)
        elif (const & 0xFFFF8000) == 0xFFFF8000 and not Ti.is_float():
            two_comp = two_complement(const, 32)
            ret += "; CHECK-NEXT: {}add {}, $m15, {}\n".format(prefix, reg, two_comp)
        else:
            if low20:
                if hi12:
                    # setzi + or, with [[SETREG]] holding the intermediate
                    # register
                    clobs_regex = '\\' + Ti.reg_prefix + get_range_re_from_list(clobs)
                    set_dst = "[[SETREG:{}]]".format(clobs_regex) if hi12 else reg
                    or_src1 = "[[SETREG]]"
                else:
                    set_dst = reg
                ret += "; CHECK-NEXT: {}setzi {}, {}\n".format(prefix, set_dst, low20)
            else:
                # Only 12 most significant bits are set, use OR with $a15
                or_src1 = "$a15" if Ti.is_float() else "$m15"
            if hi12:
                ret += "; CHECK-NEXT: {}or {}, {}, {}\n".format(
                    prefix, reg, or_src1, or_imm_check_str(hi12)
                )
        prev_const = const
        prev_reg = reg
    return ret
