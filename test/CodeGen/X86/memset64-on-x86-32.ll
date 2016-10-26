; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-unknown   -mattr=sse4.2 | FileCheck %s --check-prefix=FAST
; RUN: llc < %s -mtriple=i386-unknown-unknown   -mattr=ssse3   | FileCheck %s --check-prefix=SLOW_32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=ssse3   | FileCheck %s --check-prefix=SLOW_64

define void @bork() nounwind {
; FAST-LABEL: bork:
; FAST:       # BB#0:
; FAST-NEXT:    xorps %xmm0, %xmm0
; FAST-NEXT:    movups %xmm0, 64
; FAST-NEXT:    movups %xmm0, 48
; FAST-NEXT:    movups %xmm0, 32
; FAST-NEXT:    movups %xmm0, 16
; FAST-NEXT:    movups %xmm0, 0
; FAST-NEXT:    retl
;
; SLOW_32-LABEL: bork:
; SLOW_32:       # BB#0:
; SLOW_32-NEXT:    movl $0, 4
; SLOW_32-NEXT:    movl $0, 0
; SLOW_32-NEXT:    movl $0, 12
; SLOW_32-NEXT:    movl $0, 8
; SLOW_32-NEXT:    movl $0, 20
; SLOW_32-NEXT:    movl $0, 16
; SLOW_32-NEXT:    movl $0, 28
; SLOW_32-NEXT:    movl $0, 24
; SLOW_32-NEXT:    movl $0, 36
; SLOW_32-NEXT:    movl $0, 32
; SLOW_32-NEXT:    movl $0, 44
; SLOW_32-NEXT:    movl $0, 40
; SLOW_32-NEXT:    movl $0, 52
; SLOW_32-NEXT:    movl $0, 48
; SLOW_32-NEXT:    movl $0, 60
; SLOW_32-NEXT:    movl $0, 56
; SLOW_32-NEXT:    movl $0, 68
; SLOW_32-NEXT:    movl $0, 64
; SLOW_32-NEXT:    movl $0, 76
; SLOW_32-NEXT:    movl $0, 72
; SLOW_32-NEXT:    retl
;
; SLOW_64-LABEL: bork:
; SLOW_64:       # BB#0:
; SLOW_64-NEXT:    movq $0, 72
; SLOW_64-NEXT:    movq $0, 64
; SLOW_64-NEXT:    movq $0, 56
; SLOW_64-NEXT:    movq $0, 48
; SLOW_64-NEXT:    movq $0, 40
; SLOW_64-NEXT:    movq $0, 32
; SLOW_64-NEXT:    movq $0, 24
; SLOW_64-NEXT:    movq $0, 16
; SLOW_64-NEXT:    movq $0, 8
; SLOW_64-NEXT:    movq $0, 0
; SLOW_64-NEXT:    retq
;
  call void @llvm.memset.p0i8.i64(i8* null, i8 0, i64 80, i32 4, i1 false)
  ret void
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) nounwind

