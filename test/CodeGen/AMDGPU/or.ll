; RUN: llc -march=amdgcn -mcpu=tonga -verify-machineinstrs < %s | FileCheck -check-prefix=SI -check-prefix=FUNC %s
; RUN: llc -march=amdgcn -mcpu=verde -verify-machineinstrs < %s | FileCheck -check-prefix=SI -check-prefix=FUNC %s
; RUN: llc -march=r600 -mcpu=redwood < %s | FileCheck -check-prefix=EG -check-prefix=FUNC %s


; FUNC-LABEL: {{^}}or_v2i32:
; EG: OR_INT {{\*? *}}T{{[0-9]+\.[XYZW], T[0-9]+\.[XYZW], T[0-9]+\.[XYZW]}}
; EG: OR_INT {{\*? *}}T{{[0-9]+\.[XYZW], T[0-9]+\.[XYZW], T[0-9]+\.[XYZW]}}

; SI: v_or_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; SI: v_or_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
define void @or_v2i32(<2 x i32> addrspace(1)* %out, <2 x i32> addrspace(1)* %in) {
  %b_ptr = getelementptr <2 x i32>, <2 x i32> addrspace(1)* %in, i32 1
  %a = load <2 x i32>, <2 x i32> addrspace(1) * %in
  %b = load <2 x i32>, <2 x i32> addrspace(1) * %b_ptr
  %result = or <2 x i32> %a, %b
  store <2 x i32> %result, <2 x i32> addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}or_v4i32:
; EG: OR_INT {{\*? *}}T{{[0-9]+\.[XYZW], T[0-9]+\.[XYZW], T[0-9]+\.[XYZW]}}
; EG: OR_INT {{\*? *}}T{{[0-9]+\.[XYZW], T[0-9]+\.[XYZW], T[0-9]+\.[XYZW]}}
; EG: OR_INT {{\*? *}}T{{[0-9]+\.[XYZW], T[0-9]+\.[XYZW], T[0-9]+\.[XYZW]}}
; EG: OR_INT {{\*? *}}T{{[0-9]+\.[XYZW], T[0-9]+\.[XYZW], T[0-9]+\.[XYZW]}}

; SI: v_or_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; SI: v_or_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; SI: v_or_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
; SI: v_or_b32_e32 v{{[0-9]+, v[0-9]+, v[0-9]+}}
define void @or_v4i32(<4 x i32> addrspace(1)* %out, <4 x i32> addrspace(1)* %in) {
  %b_ptr = getelementptr <4 x i32>, <4 x i32> addrspace(1)* %in, i32 1
  %a = load <4 x i32>, <4 x i32> addrspace(1) * %in
  %b = load <4 x i32>, <4 x i32> addrspace(1) * %b_ptr
  %result = or <4 x i32> %a, %b
  store <4 x i32> %result, <4 x i32> addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}scalar_or_i32:
; SI: s_or_b32
define void @scalar_or_i32(i32 addrspace(1)* %out, i32 %a, i32 %b) {
  %or = or i32 %a, %b
  store i32 %or, i32 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}vector_or_i32:
; SI: v_or_b32_e32 v{{[0-9]}}
define void @vector_or_i32(i32 addrspace(1)* %out, i32 addrspace(1)* %a, i32 %b) {
  %loada = load i32, i32 addrspace(1)* %a
  %or = or i32 %loada, %b
  store i32 %or, i32 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}scalar_or_literal_i32:
; SI: s_or_b32 s{{[0-9]+}}, s{{[0-9]+}}, 0x1869f
define void @scalar_or_literal_i32(i32 addrspace(1)* %out, i32 %a) {
  %or = or i32 %a, 99999
  store i32 %or, i32 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: {{^}}vector_or_literal_i32:
; SI: v_or_b32_e32 v{{[0-9]+}}, 0xffff, v{{[0-9]+}}
define void @vector_or_literal_i32(i32 addrspace(1)* %out, i32 addrspace(1)* %a, i32 addrspace(1)* %b) {
  %loada = load i32, i32 addrspace(1)* %a, align 4
  %or = or i32 %loada, 65535
  store i32 %or, i32 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: {{^}}vector_or_inline_immediate_i32:
; SI: v_or_b32_e32 v{{[0-9]+}}, 4, v{{[0-9]+}}
define void @vector_or_inline_immediate_i32(i32 addrspace(1)* %out, i32 addrspace(1)* %a, i32 addrspace(1)* %b) {
  %loada = load i32, i32 addrspace(1)* %a, align 4
  %or = or i32 %loada, 4
  store i32 %or, i32 addrspace(1)* %out, align 4
  ret void
}

; FUNC-LABEL: {{^}}scalar_or_i64:
; EG-DAG: OR_INT * T{{[0-9]\.[XYZW]}}, KC0[2].W, KC0[3].Y
; EG-DAG: OR_INT * T{{[0-9]\.[XYZW]}}, KC0[3].X, KC0[3].Z

; SI: s_or_b64
define void @scalar_or_i64(i64 addrspace(1)* %out, i64 %a, i64 %b) {
  %or = or i64 %a, %b
  store i64 %or, i64 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}vector_or_i64:
; SI: v_or_b32_e32 v{{[0-9]}}
; SI: v_or_b32_e32 v{{[0-9]}}
define void @vector_or_i64(i64 addrspace(1)* %out, i64 addrspace(1)* %a, i64 addrspace(1)* %b) {
  %loada = load i64, i64 addrspace(1)* %a, align 8
  %loadb = load i64, i64 addrspace(1)* %a, align 8
  %or = or i64 %loada, %loadb
  store i64 %or, i64 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}scalar_vector_or_i64:
; SI: v_or_b32_e32 v{{[0-9]}}
; SI: v_or_b32_e32 v{{[0-9]}}
define void @scalar_vector_or_i64(i64 addrspace(1)* %out, i64 addrspace(1)* %a, i64 %b) {
  %loada = load i64, i64 addrspace(1)* %a
  %or = or i64 %loada, %b
  store i64 %or, i64 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}vector_or_i64_loadimm:
; SI-DAG: s_mov_b32 [[LO_S_IMM:s[0-9]+]], 0xdf77987f
; SI-DAG: s_movk_i32 [[HI_S_IMM:s[0-9]+]], 0x146f
; SI-DAG: buffer_load_dwordx2 v{{\[}}[[LO_VREG:[0-9]+]]:[[HI_VREG:[0-9]+]]{{\]}},
; SI-DAG: v_or_b32_e32 {{v[0-9]+}}, [[LO_S_IMM]], v[[LO_VREG]]
; SI-DAG: v_or_b32_e32 {{v[0-9]+}}, [[HI_S_IMM]], v[[HI_VREG]]
; SI: s_endpgm
define void @vector_or_i64_loadimm(i64 addrspace(1)* %out, i64 addrspace(1)* %a, i64 addrspace(1)* %b) {
  %loada = load i64, i64 addrspace(1)* %a, align 8
  %or = or i64 %loada, 22470723082367
  store i64 %or, i64 addrspace(1)* %out
  ret void
}

; FIXME: The or 0 should really be removed.
; FUNC-LABEL: {{^}}vector_or_i64_imm:
; SI: buffer_load_dwordx2 v{{\[}}[[LO_VREG:[0-9]+]]:[[HI_VREG:[0-9]+]]{{\]}},
; SI: v_or_b32_e32 {{v[0-9]+}}, 8, v[[LO_VREG]]
; SI: v_or_b32_e32 {{v[0-9]+}}, 0, {{.*}}
; SI: s_endpgm
define void @vector_or_i64_imm(i64 addrspace(1)* %out, i64 addrspace(1)* %a, i64 addrspace(1)* %b) {
  %loada = load i64, i64 addrspace(1)* %a, align 8
  %or = or i64 %loada, 8
  store i64 %or, i64 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}trunc_i64_or_to_i32:
; SI: s_load_dword s[[SREG0:[0-9]+]]
; SI: s_load_dword s[[SREG1:[0-9]+]]
; SI: s_or_b32 s[[SRESULT:[0-9]+]], s[[SREG1]], s[[SREG0]]
; SI: v_mov_b32_e32 [[VRESULT:v[0-9]+]], s[[SRESULT]]
; SI: buffer_store_dword [[VRESULT]],
define void @trunc_i64_or_to_i32(i32 addrspace(1)* %out, i64 %a, i64 %b) {
  %add = or i64 %b, %a
  %trunc = trunc i64 %add to i32
  store i32 %trunc, i32 addrspace(1)* %out, align 8
  ret void
}

; FUNC-LABEL: {{^}}or_i1:
; EG: OR_INT {{\** *}}T{{[0-9]+\.[XYZW], PV\.[XYZW], PS}}

; SI: s_or_b64 s[{{[0-9]+:[0-9]+}}], vcc, s[{{[0-9]+:[0-9]+}}]
define void @or_i1(i32 addrspace(1)* %out, float addrspace(1)* %in0, float addrspace(1)* %in1) {
  %a = load float, float addrspace(1)* %in0
  %b = load float, float addrspace(1)* %in1
  %acmp = fcmp oge float %a, 0.000000e+00
  %bcmp = fcmp oge float %b, 0.000000e+00
  %or = or i1 %acmp, %bcmp
  %result = zext i1 %or to i32
  store i32 %result, i32 addrspace(1)* %out
  ret void
}

; FUNC-LABEL: {{^}}s_or_i1:
; SI: s_or_b64 s[{{[0-9]+:[0-9]+}}], vcc, s[{{[0-9]+:[0-9]+}}]
define void @s_or_i1(i1 addrspace(1)* %out, i32 %a, i32 %b, i32 %c, i32 %d) {
  %cmp0 = icmp eq i32 %a, %b
  %cmp1 = icmp eq i32 %c, %d
  %or = or i1 %cmp0, %cmp1
  store i1 %or, i1 addrspace(1)* %out
  ret void
}