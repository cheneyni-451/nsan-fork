; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -nsan -nsan-shadow-type-mapping=dqq -nsan-truncate-fcmp-eq=false -S | FileCheck %s --check-prefixes=CHECK,DQQ
; RUN: opt < %s -nsan -nsan-shadow-type-mapping=dlq -nsan-truncate-fcmp-eq=false -S | FileCheck %s --check-prefixes=CHECK,DLQ
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"

; Scalar float comparison: `a > b`.
define i1 @scalar_fcmp(double %a) sanitize_numericalstability {
; DQQ-LABEL: @scalar_fcmp(
; DQQ-NEXT:  entry:
; DQQ-NEXT:    [[TMP0:%.*]] = load i64, i64* @__nsan_shadow_args_tag, align 8
; DQQ-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], ptrtoint (i1 (double)* @scalar_fcmp to i64)
; DQQ-NEXT:    [[TMP2:%.*]] = load fp128, fp128* bitcast ([16384 x i8]* @__nsan_shadow_args_ptr to fp128*), align 1
; DQQ-NEXT:    [[TMP3:%.*]] = fpext double [[A:%.*]] to fp128
; DQQ-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], fp128 [[TMP2]], fp128 [[TMP3]]
; DQQ-NEXT:    store i64 0, i64* @__nsan_shadow_args_tag, align 8
; DQQ-NEXT:    [[R:%.*]] = fcmp oeq double [[A]], 1.000000e+00
; DQQ-NEXT:    [[TMP5:%.*]] = fcmp oeq fp128 [[TMP4]], 0xL00000000000000003FFF000000000000
; DQQ-NEXT:    [[TMP6:%.*]] = icmp eq i1 [[R]], [[TMP5]]
; DQQ-NEXT:    br i1 [[TMP6]], label [[TMP8:%.*]], label [[TMP7:%.*]]
; DQQ:       7:
; DQQ-NEXT:    call void @__nsan_fcmp_fail_double_q(double [[A]], double 1.000000e+00, fp128 [[TMP4]], fp128 0xL00000000000000003FFF000000000000, i32 1, i1 [[R]], i1 [[TMP5]])
; DQQ-NEXT:    br label [[TMP8]]
; DQQ:       8:
; DQQ-NEXT:    ret i1 [[R]]
;
; DLQ-LABEL: @scalar_fcmp(
; DLQ-NEXT:  entry:
; DLQ-NEXT:    [[TMP0:%.*]] = load i64, i64* @__nsan_shadow_args_tag, align 8
; DLQ-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], ptrtoint (i1 (double)* @scalar_fcmp to i64)
; DLQ-NEXT:    [[TMP2:%.*]] = load x86_fp80, x86_fp80* bitcast ([16384 x i8]* @__nsan_shadow_args_ptr to x86_fp80*), align 1
; DLQ-NEXT:    [[TMP3:%.*]] = fpext double [[A:%.*]] to x86_fp80
; DLQ-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], x86_fp80 [[TMP2]], x86_fp80 [[TMP3]]
; DLQ-NEXT:    store i64 0, i64* @__nsan_shadow_args_tag, align 8
; DLQ-NEXT:    [[R:%.*]] = fcmp oeq double [[A]], 1.000000e+00
; DLQ-NEXT:    [[TMP5:%.*]] = fcmp oeq x86_fp80 [[TMP4]], 0xK3FFF8000000000000000
; DLQ-NEXT:    [[TMP6:%.*]] = icmp eq i1 [[R]], [[TMP5]]
; DLQ-NEXT:    br i1 [[TMP6]], label [[TMP8:%.*]], label [[TMP7:%.*]]
; DLQ:       7:
; DLQ-NEXT:    call void @__nsan_fcmp_fail_double_l(double [[A]], double 1.000000e+00, x86_fp80 [[TMP4]], x86_fp80 0xK3FFF8000000000000000, i32 1, i1 [[R]], i1 [[TMP5]])
; DLQ-NEXT:    br label [[TMP8]]
; DLQ:       8:
; DLQ-NEXT:    ret i1 [[R]]
;
entry:
  %r = fcmp oeq double %a, 1.0
  ret i1 %r
}

; Vector float comparison.
define <4 x i1> @vector_fcmp(<4 x double> %a, <4 x double> %b) sanitize_numericalstability {
; DQQ-LABEL: @vector_fcmp(
; DQQ-NEXT:  entry:
; DQQ-NEXT:    [[TMP0:%.*]] = load i64, i64* @__nsan_shadow_args_tag, align 8
; DQQ-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], ptrtoint (<4 x i1> (<4 x double>, <4 x double>)* @vector_fcmp to i64)
; DQQ-NEXT:    [[TMP2:%.*]] = load <4 x fp128>, <4 x fp128>* bitcast ([16384 x i8]* @__nsan_shadow_args_ptr to <4 x fp128>*), align 1
; DQQ-NEXT:    [[TMP3:%.*]] = fpext <4 x double> [[A:%.*]] to <4 x fp128>
; DQQ-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], <4 x fp128> [[TMP2]], <4 x fp128> [[TMP3]]
; DQQ-NEXT:    [[TMP5:%.*]] = load <4 x fp128>, <4 x fp128>* bitcast (i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__nsan_shadow_args_ptr, i64 0, i64 64) to <4 x fp128>*), align 1
; DQQ-NEXT:    [[TMP6:%.*]] = fpext <4 x double> [[B:%.*]] to <4 x fp128>
; DQQ-NEXT:    [[TMP7:%.*]] = select i1 [[TMP1]], <4 x fp128> [[TMP5]], <4 x fp128> [[TMP6]]
; DQQ-NEXT:    store i64 0, i64* @__nsan_shadow_args_tag, align 8
; DQQ-NEXT:    [[R:%.*]] = fcmp oeq <4 x double> [[A]], [[B]]
; DQQ-NEXT:    [[TMP8:%.*]] = fcmp oeq <4 x fp128> [[TMP4]], [[TMP7]]
; DQQ-NEXT:    [[TMP9:%.*]] = icmp eq <4 x i1> [[R]], [[TMP8]]
; DQQ-NEXT:    [[TMP10:%.*]] = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> [[TMP9]])
; DQQ-NEXT:    br i1 [[TMP10]], label [[TMP36:%.*]], label [[TMP11:%.*]]
; DQQ:       11:
; DQQ-NEXT:    [[TMP12:%.*]] = extractelement <4 x double> [[A]], i64 0
; DQQ-NEXT:    [[TMP13:%.*]] = extractelement <4 x double> [[B]], i64 0
; DQQ-NEXT:    [[TMP14:%.*]] = extractelement <4 x fp128> [[TMP4]], i64 0
; DQQ-NEXT:    [[TMP15:%.*]] = extractelement <4 x fp128> [[TMP7]], i64 0
; DQQ-NEXT:    [[TMP16:%.*]] = extractelement <4 x i1> [[R]], i64 0
; DQQ-NEXT:    [[TMP17:%.*]] = extractelement <4 x i1> [[TMP8]], i64 0
; DQQ-NEXT:    call void @__nsan_fcmp_fail_double_q(double [[TMP12]], double [[TMP13]], fp128 [[TMP14]], fp128 [[TMP15]], i32 1, i1 [[TMP16]], i1 [[TMP17]])
; DQQ-NEXT:    [[TMP18:%.*]] = extractelement <4 x double> [[A]], i64 1
; DQQ-NEXT:    [[TMP19:%.*]] = extractelement <4 x double> [[B]], i64 1
; DQQ-NEXT:    [[TMP20:%.*]] = extractelement <4 x fp128> [[TMP4]], i64 1
; DQQ-NEXT:    [[TMP21:%.*]] = extractelement <4 x fp128> [[TMP7]], i64 1
; DQQ-NEXT:    [[TMP22:%.*]] = extractelement <4 x i1> [[R]], i64 1
; DQQ-NEXT:    [[TMP23:%.*]] = extractelement <4 x i1> [[TMP8]], i64 1
; DQQ-NEXT:    call void @__nsan_fcmp_fail_double_q(double [[TMP18]], double [[TMP19]], fp128 [[TMP20]], fp128 [[TMP21]], i32 1, i1 [[TMP22]], i1 [[TMP23]])
; DQQ-NEXT:    [[TMP24:%.*]] = extractelement <4 x double> [[A]], i64 2
; DQQ-NEXT:    [[TMP25:%.*]] = extractelement <4 x double> [[B]], i64 2
; DQQ-NEXT:    [[TMP26:%.*]] = extractelement <4 x fp128> [[TMP4]], i64 2
; DQQ-NEXT:    [[TMP27:%.*]] = extractelement <4 x fp128> [[TMP7]], i64 2
; DQQ-NEXT:    [[TMP28:%.*]] = extractelement <4 x i1> [[R]], i64 2
; DQQ-NEXT:    [[TMP29:%.*]] = extractelement <4 x i1> [[TMP8]], i64 2
; DQQ-NEXT:    call void @__nsan_fcmp_fail_double_q(double [[TMP24]], double [[TMP25]], fp128 [[TMP26]], fp128 [[TMP27]], i32 1, i1 [[TMP28]], i1 [[TMP29]])
; DQQ-NEXT:    [[TMP30:%.*]] = extractelement <4 x double> [[A]], i64 3
; DQQ-NEXT:    [[TMP31:%.*]] = extractelement <4 x double> [[B]], i64 3
; DQQ-NEXT:    [[TMP32:%.*]] = extractelement <4 x fp128> [[TMP4]], i64 3
; DQQ-NEXT:    [[TMP33:%.*]] = extractelement <4 x fp128> [[TMP7]], i64 3
; DQQ-NEXT:    [[TMP34:%.*]] = extractelement <4 x i1> [[R]], i64 3
; DQQ-NEXT:    [[TMP35:%.*]] = extractelement <4 x i1> [[TMP8]], i64 3
; DQQ-NEXT:    call void @__nsan_fcmp_fail_double_q(double [[TMP30]], double [[TMP31]], fp128 [[TMP32]], fp128 [[TMP33]], i32 1, i1 [[TMP34]], i1 [[TMP35]])
; DQQ-NEXT:    br label [[TMP36]]
; DQQ:       36:
; DQQ-NEXT:    ret <4 x i1> [[R]]
;
; DLQ-LABEL: @vector_fcmp(
; DLQ-NEXT:  entry:
; DLQ-NEXT:    [[TMP0:%.*]] = load i64, i64* @__nsan_shadow_args_tag, align 8
; DLQ-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], ptrtoint (<4 x i1> (<4 x double>, <4 x double>)* @vector_fcmp to i64)
; DLQ-NEXT:    [[TMP2:%.*]] = load <4 x x86_fp80>, <4 x x86_fp80>* bitcast ([16384 x i8]* @__nsan_shadow_args_ptr to <4 x x86_fp80>*), align 1
; DLQ-NEXT:    [[TMP3:%.*]] = fpext <4 x double> [[A:%.*]] to <4 x x86_fp80>
; DLQ-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], <4 x x86_fp80> [[TMP2]], <4 x x86_fp80> [[TMP3]]
; DLQ-NEXT:    [[TMP5:%.*]] = load <4 x x86_fp80>, <4 x x86_fp80>* bitcast (i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__nsan_shadow_args_ptr, i64 0, i64 40) to <4 x x86_fp80>*), align 1
; DLQ-NEXT:    [[TMP6:%.*]] = fpext <4 x double> [[B:%.*]] to <4 x x86_fp80>
; DLQ-NEXT:    [[TMP7:%.*]] = select i1 [[TMP1]], <4 x x86_fp80> [[TMP5]], <4 x x86_fp80> [[TMP6]]
; DLQ-NEXT:    store i64 0, i64* @__nsan_shadow_args_tag, align 8
; DLQ-NEXT:    [[R:%.*]] = fcmp oeq <4 x double> [[A]], [[B]]
; DLQ-NEXT:    [[TMP8:%.*]] = fcmp oeq <4 x x86_fp80> [[TMP4]], [[TMP7]]
; DLQ-NEXT:    [[TMP9:%.*]] = icmp eq <4 x i1> [[R]], [[TMP8]]
; DLQ-NEXT:    [[TMP10:%.*]] = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> [[TMP9]])
; DLQ-NEXT:    br i1 [[TMP10]], label [[TMP36:%.*]], label [[TMP11:%.*]]
; DLQ:       11:
; DLQ-NEXT:    [[TMP12:%.*]] = extractelement <4 x double> [[A]], i64 0
; DLQ-NEXT:    [[TMP13:%.*]] = extractelement <4 x double> [[B]], i64 0
; DLQ-NEXT:    [[TMP14:%.*]] = extractelement <4 x x86_fp80> [[TMP4]], i64 0
; DLQ-NEXT:    [[TMP15:%.*]] = extractelement <4 x x86_fp80> [[TMP7]], i64 0
; DLQ-NEXT:    [[TMP16:%.*]] = extractelement <4 x i1> [[R]], i64 0
; DLQ-NEXT:    [[TMP17:%.*]] = extractelement <4 x i1> [[TMP8]], i64 0
; DLQ-NEXT:    call void @__nsan_fcmp_fail_double_l(double [[TMP12]], double [[TMP13]], x86_fp80 [[TMP14]], x86_fp80 [[TMP15]], i32 1, i1 [[TMP16]], i1 [[TMP17]])
; DLQ-NEXT:    [[TMP18:%.*]] = extractelement <4 x double> [[A]], i64 1
; DLQ-NEXT:    [[TMP19:%.*]] = extractelement <4 x double> [[B]], i64 1
; DLQ-NEXT:    [[TMP20:%.*]] = extractelement <4 x x86_fp80> [[TMP4]], i64 1
; DLQ-NEXT:    [[TMP21:%.*]] = extractelement <4 x x86_fp80> [[TMP7]], i64 1
; DLQ-NEXT:    [[TMP22:%.*]] = extractelement <4 x i1> [[R]], i64 1
; DLQ-NEXT:    [[TMP23:%.*]] = extractelement <4 x i1> [[TMP8]], i64 1
; DLQ-NEXT:    call void @__nsan_fcmp_fail_double_l(double [[TMP18]], double [[TMP19]], x86_fp80 [[TMP20]], x86_fp80 [[TMP21]], i32 1, i1 [[TMP22]], i1 [[TMP23]])
; DLQ-NEXT:    [[TMP24:%.*]] = extractelement <4 x double> [[A]], i64 2
; DLQ-NEXT:    [[TMP25:%.*]] = extractelement <4 x double> [[B]], i64 2
; DLQ-NEXT:    [[TMP26:%.*]] = extractelement <4 x x86_fp80> [[TMP4]], i64 2
; DLQ-NEXT:    [[TMP27:%.*]] = extractelement <4 x x86_fp80> [[TMP7]], i64 2
; DLQ-NEXT:    [[TMP28:%.*]] = extractelement <4 x i1> [[R]], i64 2
; DLQ-NEXT:    [[TMP29:%.*]] = extractelement <4 x i1> [[TMP8]], i64 2
; DLQ-NEXT:    call void @__nsan_fcmp_fail_double_l(double [[TMP24]], double [[TMP25]], x86_fp80 [[TMP26]], x86_fp80 [[TMP27]], i32 1, i1 [[TMP28]], i1 [[TMP29]])
; DLQ-NEXT:    [[TMP30:%.*]] = extractelement <4 x double> [[A]], i64 3
; DLQ-NEXT:    [[TMP31:%.*]] = extractelement <4 x double> [[B]], i64 3
; DLQ-NEXT:    [[TMP32:%.*]] = extractelement <4 x x86_fp80> [[TMP4]], i64 3
; DLQ-NEXT:    [[TMP33:%.*]] = extractelement <4 x x86_fp80> [[TMP7]], i64 3
; DLQ-NEXT:    [[TMP34:%.*]] = extractelement <4 x i1> [[R]], i64 3
; DLQ-NEXT:    [[TMP35:%.*]] = extractelement <4 x i1> [[TMP8]], i64 3
; DLQ-NEXT:    call void @__nsan_fcmp_fail_double_l(double [[TMP30]], double [[TMP31]], x86_fp80 [[TMP32]], x86_fp80 [[TMP33]], i32 1, i1 [[TMP34]], i1 [[TMP35]])
; DLQ-NEXT:    br label [[TMP36]]
; DLQ:       36:
; DLQ-NEXT:    ret <4 x i1> [[R]]
;
entry:
  %r = fcmp oeq <4 x double> %a, %b
  ret <4 x i1> %r
}

declare float @fabsf(float)

; Basic scalar float comparison of absolute difference with 0: `fabs(a-b) > 0`.
define float @sub_cmp_fabs(float %a, float %b) sanitize_numericalstability {
; CHECK-LABEL: @sub_cmp_fabs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, i64* @__nsan_shadow_args_tag, align 8
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], ptrtoint (float (float, float)* @sub_cmp_fabs to i64)
; CHECK-NEXT:    [[TMP2:%.*]] = load double, double* bitcast ([16384 x i8]* @__nsan_shadow_args_ptr to double*), align 1
; CHECK-NEXT:    [[TMP3:%.*]] = fpext float [[A:%.*]] to double
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP1]], double [[TMP2]], double [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = load double, double* bitcast (i8* getelementptr inbounds ([16384 x i8], [16384 x i8]* @__nsan_shadow_args_ptr, i64 0, i64 8) to double*), align 1
; CHECK-NEXT:    [[TMP6:%.*]] = fpext float [[B:%.*]] to double
; CHECK-NEXT:    [[TMP7:%.*]] = select i1 [[TMP1]], double [[TMP5]], double [[TMP6]]
; CHECK-NEXT:    store i64 0, i64* @__nsan_shadow_args_tag, align 8
; CHECK-NEXT:    [[S:%.*]] = fsub float [[A]], [[B]]
; CHECK-NEXT:    [[TMP8:%.*]] = fsub double [[TMP4]], [[TMP7]]
; CHECK-NEXT:    [[R:%.*]] = call float @fabsf(float [[S]]) [[ATTR4:#.*]]
; CHECK-NEXT:    [[TMP9:%.*]] = call double @llvm.fabs.f64(double [[TMP8]])
; CHECK-NEXT:    [[C:%.*]] = fcmp oeq float [[R]], 2.500000e-01
; CHECK-NEXT:    [[TMP10:%.*]] = fcmp oeq double [[TMP9]], 2.500000e-01
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i1 [[C]], [[TMP10]]
; CHECK-NEXT:    br i1 [[TMP11]], label [[TMP13:%.*]], label [[TMP12:%.*]]
; CHECK:       12:
; CHECK-NEXT:    call void @__nsan_fcmp_fail_float_d(float [[R]], float 2.500000e-01, double [[TMP9]], double 2.500000e-01, i32 1, i1 [[C]], i1 [[TMP10]])
; CHECK-NEXT:    br label [[TMP13]]
; CHECK:       13:
; CHECK-NEXT:    [[TMP14:%.*]] = call i32 @__nsan_internal_check_float_d(float [[R]], double [[TMP9]], i32 1, i64 0)
; CHECK-NEXT:    [[TMP15:%.*]] = icmp eq i32 [[TMP14]], 1
; CHECK-NEXT:    [[TMP16:%.*]] = fpext float [[R]] to double
; CHECK-NEXT:    [[TMP17:%.*]] = select i1 [[TMP15]], double [[TMP16]], double [[TMP9]]
; CHECK-NEXT:    store i64 ptrtoint (float (float, float)* @sub_cmp_fabs to i64), i64* @__nsan_shadow_ret_tag, align 8
; CHECK-NEXT:    store double [[TMP17]], double* bitcast ([128 x i8]* @__nsan_shadow_ret_ptr to double*), align 8
; CHECK-NEXT:    ret float [[R]]
;
entry:
  %s = fsub float %a, %b
  %r = call float @fabsf(float %s)
  %c = fcmp oeq float %r, 0.25
  ret float %r
}
