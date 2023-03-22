
// CSR defines.",
//
// Automatically generated file. Do not edit!
//

#ifndef CSR_DEFINES
#define CSR_DEFINES

namespace llvm {

namespace Colossus {

// {CSR name, available in supervisor mode, available in worker mode, architecture to regnum map}
#define CSR_REGISTERS {\
  {"$PC", true, true, {{"ipu1", 0}, {"ipu2", 0}, {"ipu21", 0}}},\
  {"$FP_STS", false, true, {{"ipu1", 0}, {"ipu2", 0}, {"ipu21", 0}}},\
  {"$CWEI_0_0", true, false, {{"ipu1", 0}, {"ipu2", 0}, {"ipu21", 0}}},\
  {"$WSR", false, true, {{"ipu1", 1}, {"ipu2", 1}, {"ipu21", 1}}},\
  {"$FP_CLR", false, true, {{"ipu1", 1}, {"ipu2", 1}, {"ipu21", 1}}},\
  {"$CWEI_0_1", true, false, {{"ipu1", 1}, {"ipu2", 1}, {"ipu21", 1}}},\
  {"$VERTEX_BASE", false, true, {{"ipu1", 2}, {"ipu2", 2}, {"ipu21", 2}}},\
  {"$FP_CTL", false, true, {{"ipu1", 2}, {"ipu2", 2}, {"ipu21", 2}}},\
  {"$CWEI_0_2", true, false, {{"ipu1", 2}, {"ipu2", 2}, {"ipu21", 2}}},\
  {"$WORKER_BASE", false, true, {{"ipu1", 3}, {"ipu2", 3}, {"ipu21", 3}}},\
  {"$PRNG_0_0", false, true, {{"ipu1", 3}, {"ipu2", 3}, {"ipu21", 3}}},\
  {"$CWEI_0_3", true, false, {{"ipu1", 3}, {"ipu2", 3}, {"ipu21", 3}}},\
  {"$REPEAT_COUNT", false, true, {{"ipu1", 4}, {"ipu2", 4}, {"ipu21", 4}}},\
  {"$PRNG_0_1", false, true, {{"ipu1", 4}, {"ipu2", 4}, {"ipu21", 4}}},\
  {"$CWEI_1_0", true, false, {{"ipu1", 4}, {"ipu2", 4}, {"ipu21", 4}}},\
  {"$REPEAT_FIRST", false, true, {{"ipu1", 5}, {"ipu2", 5}, {"ipu21", 5}}},\
  {"$PRNG_1_0", false, true, {{"ipu1", 5}, {"ipu2", 5}, {"ipu21", 5}}},\
  {"$CWEI_1_1", true, false, {{"ipu1", 5}, {"ipu2", 5}, {"ipu21", 5}}},\
  {"$REPEAT_END", false, true, {{"ipu1", 6}, {"ipu2", 6}, {"ipu21", 6}}},\
  {"$PRNG_1_1", false, true, {{"ipu1", 6}, {"ipu2", 6}, {"ipu21", 6}}},\
  {"$CWEI_1_2", true, false, {{"ipu1", 6}, {"ipu2", 6}, {"ipu21", 6}}},\
  {"$PRNG_SEED", false, true, {{"ipu1", 7}, {"ipu2", 7}, {"ipu21", 7}}},\
  {"$CWEI_1_3", true, false, {{"ipu1", 7}, {"ipu2", 7}, {"ipu21", 7}}},\
  {"$TAS", false, true, {{"ipu1", 8}, {"ipu2", 8}, {"ipu21", 8}}},\
  {"$CWEI_2_0", true, false, {{"ipu1", 8}, {"ipu2", 8}, {"ipu21", 8}}},\
  {"$CWEI_2_1", true, false, {{"ipu1", 9}, {"ipu2", 9}, {"ipu21", 9}}},\
  {"$CWEI_2_2", true, false, {{"ipu1", 10}, {"ipu2", 10}, {"ipu21", 10}}},\
  {"$CWEI_2_3", true, false, {{"ipu1", 11}, {"ipu2", 11}, {"ipu21", 11}}},\
  {"$CWEI_3_0", true, false, {{"ipu1", 12}, {"ipu2", 12}, {"ipu21", 12}}},\
  {"$CWEI_3_1", true, false, {{"ipu1", 13}, {"ipu2", 13}, {"ipu21", 13}}},\
  {"$CWEI_3_2", true, false, {{"ipu1", 14}, {"ipu2", 14}, {"ipu21", 14}}},\
  {"$CWEI_3_3", true, false, {{"ipu1", 15}, {"ipu2", 15}, {"ipu21", 15}}},\
  {"$CWEI_4_0", true, false, {{"ipu1", 16}, {"ipu2", 16}, {"ipu21", 16}}},\
  {"$CWEI_4_1", true, false, {{"ipu1", 17}, {"ipu2", 17}, {"ipu21", 17}}},\
  {"$CWEI_4_2", true, false, {{"ipu1", 18}, {"ipu2", 18}, {"ipu21", 18}}},\
  {"$CWEI_4_3", true, false, {{"ipu1", 19}, {"ipu2", 19}, {"ipu21", 19}}},\
  {"$CWEI_5_0", true, false, {{"ipu1", 20}, {"ipu2", 20}, {"ipu21", 20}}},\
  {"$CWEI_5_1", true, false, {{"ipu1", 21}, {"ipu2", 21}, {"ipu21", 21}}},\
  {"$CWEI_5_2", true, false, {{"ipu1", 22}, {"ipu2", 22}, {"ipu21", 22}}},\
  {"$CWEI_5_3", true, false, {{"ipu1", 23}, {"ipu2", 23}, {"ipu21", 23}}},\
  {"$CWEI_6_0", true, false, {{"ipu1", 24}, {"ipu2", 24}, {"ipu21", 24}}},\
  {"$CWEI_6_1", true, false, {{"ipu1", 25}, {"ipu2", 25}, {"ipu21", 25}}},\
  {"$CWEI_6_2", true, false, {{"ipu1", 26}, {"ipu2", 26}, {"ipu21", 26}}},\
  {"$CWEI_6_3", true, false, {{"ipu1", 27}, {"ipu2", 27}, {"ipu21", 27}}},\
  {"$CWEI_7_0", true, false, {{"ipu1", 28}, {"ipu2", 28}, {"ipu21", 28}}},\
  {"$CWEI_7_1", true, false, {{"ipu1", 29}, {"ipu2", 29}, {"ipu21", 29}}},\
  {"$CWEI_7_2", true, false, {{"ipu1", 30}, {"ipu2", 30}, {"ipu21", 30}}},\
  {"$CWEI_7_3", true, false, {{"ipu1", 31}, {"ipu2", 31}, {"ipu21", 31}}},\
  {"$FP_ICTL", true, false, {{"ipu1", 32}, {"ipu2", 32}, {"ipu21", 32}}},\
  {"$CCCSLOAD", true, false, {{"ipu1", 80}, {"ipu2", 80}, {"ipu21", 80}}},\
  {"$COUNT_L", false, true, {{"ipu1", 96}, {"ipu2", 96}, {"ipu21", 96}}},\
  {"$COUNT_U", false, true, {{"ipu1", 97}, {"ipu2", 97}, {"ipu21", 97}}},\
  {"$DBG_DATA", true, true, {{"ipu1", 112}, {"ipu2", 112}, {"ipu21", 112}}},\
  {"$DBG_BRK_ID", true, true, {{"ipu1", 113}, {"ipu2", 113}, {"ipu21", 113}}},\
  {"$CTXT_STS", true, false, {{"ipu1", 114}, {"ipu2", 114}, {"ipu21", 114}}},\
  {"$CWEI_8_0", true, false, {{"ipu1", {}}, {"ipu2", 32}, {"ipu21", 32}}},\
  {"$CWEI_8_1", true, false, {{"ipu1", {}}, {"ipu2", 33}, {"ipu21", 33}}},\
  {"$CWEI_8_2", true, false, {{"ipu1", {}}, {"ipu2", 34}, {"ipu21", 34}}},\
  {"$CWEI_8_3", true, false, {{"ipu1", {}}, {"ipu2", 35}, {"ipu21", 35}}},\
  {"$CWEI_9_0", true, false, {{"ipu1", {}}, {"ipu2", 36}, {"ipu21", 36}}},\
  {"$CWEI_9_1", true, false, {{"ipu1", {}}, {"ipu2", 37}, {"ipu21", 37}}},\
  {"$CWEI_9_2", true, false, {{"ipu1", {}}, {"ipu2", 38}, {"ipu21", 38}}},\
  {"$CWEI_9_3", true, false, {{"ipu1", {}}, {"ipu2", 39}, {"ipu21", 39}}},\
  {"$CWEI_10_0", true, false, {{"ipu1", {}}, {"ipu2", 40}, {"ipu21", 40}}},\
  {"$CWEI_10_1", true, false, {{"ipu1", {}}, {"ipu2", 41}, {"ipu21", 41}}},\
  {"$CWEI_10_2", true, false, {{"ipu1", {}}, {"ipu2", 42}, {"ipu21", 42}}},\
  {"$CWEI_10_3", true, false, {{"ipu1", {}}, {"ipu2", 43}, {"ipu21", 43}}},\
  {"$CWEI_11_0", true, false, {{"ipu1", {}}, {"ipu2", 44}, {"ipu21", 44}}},\
  {"$CWEI_11_1", true, false, {{"ipu1", {}}, {"ipu2", 45}, {"ipu21", 45}}},\
  {"$CWEI_11_2", true, false, {{"ipu1", {}}, {"ipu2", 46}, {"ipu21", 46}}},\
  {"$CWEI_11_3", true, false, {{"ipu1", {}}, {"ipu2", 47}, {"ipu21", 47}}},\
  {"$CWEI_12_0", true, false, {{"ipu1", {}}, {"ipu2", 48}, {"ipu21", 48}}},\
  {"$CWEI_12_1", true, false, {{"ipu1", {}}, {"ipu2", 49}, {"ipu21", 49}}},\
  {"$CWEI_12_2", true, false, {{"ipu1", {}}, {"ipu2", 50}, {"ipu21", 50}}},\
  {"$CWEI_12_3", true, false, {{"ipu1", {}}, {"ipu2", 51}, {"ipu21", 51}}},\
  {"$CWEI_13_0", true, false, {{"ipu1", {}}, {"ipu2", 52}, {"ipu21", 52}}},\
  {"$CWEI_13_1", true, false, {{"ipu1", {}}, {"ipu2", 53}, {"ipu21", 53}}},\
  {"$CWEI_13_2", true, false, {{"ipu1", {}}, {"ipu2", 54}, {"ipu21", 54}}},\
  {"$CWEI_13_3", true, false, {{"ipu1", {}}, {"ipu2", 55}, {"ipu21", 55}}},\
  {"$CWEI_14_0", true, false, {{"ipu1", {}}, {"ipu2", 56}, {"ipu21", 56}}},\
  {"$CWEI_14_1", true, false, {{"ipu1", {}}, {"ipu2", 57}, {"ipu21", 57}}},\
  {"$CWEI_14_2", true, false, {{"ipu1", {}}, {"ipu2", 58}, {"ipu21", 58}}},\
  {"$CWEI_14_3", true, false, {{"ipu1", {}}, {"ipu2", 59}, {"ipu21", 59}}},\
  {"$CWEI_15_0", true, false, {{"ipu1", {}}, {"ipu2", 60}, {"ipu21", 60}}},\
  {"$CWEI_15_1", true, false, {{"ipu1", {}}, {"ipu2", 61}, {"ipu21", 61}}},\
  {"$CWEI_15_2", true, false, {{"ipu1", {}}, {"ipu2", 62}, {"ipu21", 62}}},\
  {"$CWEI_15_3", true, false, {{"ipu1", {}}, {"ipu2", 63}, {"ipu21", 63}}},\
  {"$FP_NFMT", false, true, {{"ipu1", {}}, {"ipu2", {}}, {"ipu21", 9}}},\
  {"$FP_SCL", false, true, {{"ipu1", {}}, {"ipu2", {}}, {"ipu21", 10}}},\
  {"$FP_INFMT", true, false, {{"ipu1", {}}, {"ipu2", {}}, {"ipu21", 49}}},\
  {"$FP_ISCL", true, false, {{"ipu1", {}}, {"ipu2", {}}, {"ipu21", 51}}},\
}

} // End Colossus namespace
} // End llvm namespace

#endif // CSR_DEFINES
