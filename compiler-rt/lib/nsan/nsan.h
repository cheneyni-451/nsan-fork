//===-- nsan.h -------------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of NumericalStabilitySanitizer.
//
// Private NSan header.
//===----------------------------------------------------------------------===//

#ifndef NSAN_H
#define NSAN_H

#include "sanitizer_common/sanitizer_internal_defs.h"

using __sanitizer::sptr;
using __sanitizer::u16;
using __sanitizer::uptr;

#include "nsan_platform.h"

#include <assert.h>
#include <float.h>
#include <limits.h>
#include <math.h>
#include <stdio.h>

// Private nsan interface. Used e.g. by interceptors.
extern "C" {

// This marks the shadow type of the given block of application memory as
// unknown.
// printf-free (see comment in nsan_interceptors.cc).
void __nsan_set_value_unknown(const char *addr, uptr size);

// Copies annotations in the shadow memory for a block of application memory to
// a new address. This function is used together with memory-copying functions
// in application memory, e.g. the instrumentation inserts
// `__nsan_copy_values(dest, src, size)` after builtin calls to
// `memcpy(dest, src, size)`. Intercepted memcpy calls also call this function.
// printf-free (see comment in nsan_interceptors.cc).
void __nsan_copy_values(const char *daddr, const char *saddr, uptr size);

SANITIZER_INTERFACE_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE const char *
__nsan_default_options();
}

namespace __nsan {

extern bool NsanInitialized;
extern bool NsanInitIsRunning;

void initializeInterceptors();

// See notes in nsan_platform.
// printf-free (see comment in nsan_interceptors.cc).
inline char *getShadowAddrFor(char *Ptr) {
  uptr AppOffset = ((uptr)Ptr) & ShadowMask();
  return (char *)(AppOffset * kShadowScale + ShadowAddr());
}

// printf-free (see comment in nsan_interceptors.cc).
inline const char *getShadowAddrFor(const char *Ptr) {
  return getShadowAddrFor(const_cast<char *>(Ptr));
}

// printf-free (see comment in nsan_interceptors.cc).
inline unsigned char *getShadowTypeAddrFor(char *Ptr) {
  uptr AppOffset = ((uptr)Ptr) & ShadowMask();
  return (unsigned char *)(AppOffset + TypesAddr());
}

// printf-free (see comment in nsan_interceptors.cc).
inline const unsigned char *getShadowTypeAddrFor(const char *Ptr) {
  return getShadowTypeAddrFor(const_cast<char *>(Ptr));
}

// Information about value types and their shadow counterparts.
template <typename FT> struct FTInfo {};
template <> struct FTInfo<float> {
  using orig_type = float;
  using orig_bits_type = __sanitizer::u32;
  using mantissa_bits_type = __sanitizer::u32;
  using shadow_type = double;
  static const char* kCppTypeName;
  static constexpr unsigned kMantissaBits = 23;
  static constexpr const int kExponentBits = 8;
  static constexpr const int kExponentBias = 127;
  static constexpr const int kValueType = kFloatValueType;
  static constexpr const char kTypePattern[sizeof(float)] = {
      static_cast<unsigned char>(kValueType | (0 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (1 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (2 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (3 << kValueSizeSizeBits)),
  };
  static constexpr const float kEpsilon = FLT_EPSILON;
};
template <> struct FTInfo<double> {
  using orig_type = double;
  using orig_bits_type = __sanitizer::u64;
  using mantissa_bits_type = __sanitizer::u64;
  using shadow_type = __float128;
  static const char *kCppTypeName;
  static constexpr unsigned kMantissaBits = 52;
  static constexpr const int kExponentBits = 11;
  static constexpr const int kExponentBias = 1023;
  static constexpr const int kValueType = kDoubleValueType;
  static constexpr char kTypePattern[sizeof(double)] = {
      static_cast<unsigned char>(kValueType | (0 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (1 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (2 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (3 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (4 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (5 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (6 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (7 << kValueSizeSizeBits)),
  };
  static constexpr const float kEpsilon = DBL_EPSILON;
};
template <> struct FTInfo<long double> {
  using orig_type = long double;
  using mantissa_bits_type = __sanitizer::u64;
  using shadow_type = __float128;
  static const char* kCppTypeName;
  static constexpr unsigned kMantissaBits = 63;
  static constexpr const int kExponentBits = 15;
  static constexpr const int kExponentBias = (1 << (kExponentBits - 1)) - 1;
  static constexpr const int kValueType = kFp80ValueType;
  static constexpr char kTypePattern[sizeof(long double)] = {
      static_cast<unsigned char>(kValueType | (0 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (1 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (2 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (3 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (4 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (5 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (6 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (7 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (8 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (9 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (10 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (11 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (12 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (13 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (14 << kValueSizeSizeBits)),
      static_cast<unsigned char>(kValueType | (15 << kValueSizeSizeBits)),
  };
  static constexpr const float kEpsilon = LDBL_EPSILON;
};

template <> struct FTInfo<__float128> {
  using orig_type = __float128;
  using orig_bits_type = __uint128_t;
  using mantissa_bits_type = __uint128_t;
  static const char* kCppTypeName;
  static constexpr unsigned kMantissaBits = 112;
  static constexpr const int kExponentBits = 15;
  static constexpr const int kExponentBias = (1 << (kExponentBits - 1)) - 1;
};

constexpr double kMaxULPDiff = INFINITY;

// Helper for getULPDiff that works on bit representations.
template <typename BT> double getULPDiffBits(BT V1Bits, BT V2Bits) {
  // If the integer representations of two same-sign floats are subtracted then
  // the absolute value of the result is equal to one plus the number of
  // representable floats between them.
  return V1Bits >= V2Bits ? V1Bits - V2Bits : V2Bits - V1Bits;
}

// Returns the the number of floating point values between V1 and V2, capped to
// u64max. Return 0 for (-0.0,0.0).
template <typename FT> double getULPDiff(FT V1, FT V2) {
  if (V1 == V2) {
    return 0; // Typically, -0.0 and 0.0
  }
  using BT = typename FTInfo<FT>::orig_bits_type;
  static_assert(sizeof(FT) == sizeof(BT), "not implemented");
  static_assert(sizeof(BT) <= 64, "not implemented");
  BT V1Bits;
  __builtin_memcpy(&V1Bits, &V1, sizeof(BT));
  BT V2Bits;
  __builtin_memcpy(&V2Bits, &V2, sizeof(BT));
  // Check whether the signs differ. IEEE-754 float types always store the sign
  // in the most significant bit. NaNs and infinities are handled by the calling
  // code.
  constexpr const BT kSignMask = BT{1} << (CHAR_BIT * sizeof(BT) - 1);
  if ((V1Bits ^ V2Bits) & kSignMask) {
    // Signs differ. We can get the ULPs as `getULPDiff(negative_number, -0.0)
    // + getULPDiff(0.0, positive_number)`.
    if (V1Bits & kSignMask) {
      return getULPDiffBits<BT>(V1Bits, kSignMask) +
             getULPDiffBits<BT>(0, V2Bits);
    } else {
      return getULPDiffBits<BT>(V2Bits, kSignMask) +
             getULPDiffBits<BT>(0, V1Bits);
    }
  }
  return getULPDiffBits(V1Bits, V2Bits);
}

// FIXME: This needs mor work: Because there is no 80-bit integer type, we have
// to go through __uint128_t. Therefore the assumptions about the sign bit do
// not hold.
template <> inline double getULPDiff(long double V1, long double V2) {
  using BT = __uint128_t;
  BT V1Bits = 0;
  __builtin_memcpy(&V1Bits, &V1, sizeof(long double));
  BT V2Bits = 0;
  __builtin_memcpy(&V2Bits, &V2, sizeof(long double));
  if ((V1Bits ^ V2Bits) & (BT{1} << (CHAR_BIT * sizeof(BT) - 1)))
    return (V1 == V2) ? __sanitizer::u64{0} : kMaxULPDiff; // Signs differ.
  // If the integer representations of two same-sign floats are subtracted then
  // the absolute value of the result is equal to one plus the number of
  // representable floats between them.
  BT Diff = V1Bits >= V2Bits ? V1Bits - V2Bits : V2Bits - V1Bits;
  return Diff >= kMaxULPDiff ? kMaxULPDiff : Diff;
}

} // end namespace __nsan

#endif // NSAN_H
