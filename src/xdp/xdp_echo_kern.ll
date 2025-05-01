; ModuleID = 'xdp_echo_kern.c'
source_filename = "xdp_echo_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@llvm.compiler.used = appending global [2 x ptr] [ptr @_license, ptr @xdp_udp_echo], section "llvm.metadata"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none)
define dso_local noundef i32 @xdp_udp_echo(ptr nocapture noundef readonly %0) #0 section "xdp" !dbg !60 {
  %2 = alloca [6 x i8], align 1, !DIAssignID !138
  call void @llvm.dbg.assign(metadata i1 undef, metadata !134, metadata !DIExpression(), metadata !138, metadata ptr %2, metadata !DIExpression()), !dbg !139
  tail call void @llvm.dbg.value(metadata ptr %0, metadata !76, metadata !DIExpression()), !dbg !139
  %3 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !140
  %4 = load i32, ptr %3, align 4, !dbg !140, !tbaa !141
  %5 = zext i32 %4 to i64, !dbg !146
  %6 = inttoptr i64 %5 to ptr, !dbg !147
  tail call void @llvm.dbg.value(metadata ptr %6, metadata !77, metadata !DIExpression()), !dbg !139
  %7 = load i32, ptr %0, align 4, !dbg !148, !tbaa !149
  %8 = zext i32 %7 to i64, !dbg !150
  %9 = inttoptr i64 %8 to ptr, !dbg !151
  tail call void @llvm.dbg.value(metadata ptr %9, metadata !78, metadata !DIExpression()), !dbg !139
  %10 = getelementptr inbounds i8, ptr %9, i64 34, !dbg !152
  %11 = getelementptr inbounds i8, ptr %9, i64 42, !dbg !154
  %12 = icmp ugt ptr %11, %6, !dbg !155
  br i1 %12, label %28, label %13, !dbg !156

13:                                               ; preds = %1
  tail call void @llvm.dbg.value(metadata ptr %9, metadata !79, metadata !DIExpression()), !dbg !139
  tail call void @llvm.dbg.value(metadata ptr %9, metadata !95, metadata !DIExpression(DW_OP_plus_uconst, 14, DW_OP_stack_value)), !dbg !139
  tail call void @llvm.dbg.value(metadata ptr %10, metadata !125, metadata !DIExpression()), !dbg !139
  %14 = getelementptr inbounds i8, ptr %9, i64 23, !dbg !157
  %15 = load i8, ptr %14, align 1, !dbg !157, !tbaa !159
  %16 = icmp eq i8 %15, 17, !dbg !162
  br i1 %16, label %17, label %28, !dbg !163

17:                                               ; preds = %13
  call void @llvm.lifetime.start.p0(i64 6, ptr nonnull %2), !dbg !164
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %2, ptr noundef nonnull align 1 dereferenceable(6) %9, i64 6, i1 false), !dbg !165, !DIAssignID !166
  call void @llvm.dbg.assign(metadata i1 undef, metadata !134, metadata !DIExpression(), metadata !166, metadata ptr %2, metadata !DIExpression()), !dbg !139
  %18 = getelementptr inbounds %struct.ethhdr, ptr %9, i64 0, i32 1, !dbg !167
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %9, ptr noundef nonnull align 1 dereferenceable(6) %18, i64 6, i1 false), !dbg !168
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(6) %18, ptr noundef nonnull align 1 dereferenceable(6) %2, i64 6, i1 false), !dbg !169
  %19 = getelementptr inbounds i8, ptr %9, i64 26, !dbg !170
  %20 = load i32, ptr %19, align 4, !dbg !170, !tbaa !171
  tail call void @llvm.dbg.value(metadata i32 %20, metadata !136, metadata !DIExpression()), !dbg !139
  %21 = getelementptr inbounds i8, ptr %9, i64 30, !dbg !172
  %22 = load i32, ptr %21, align 4, !dbg !172, !tbaa !171
  store i32 %22, ptr %19, align 4, !dbg !173, !tbaa !171
  store i32 %20, ptr %21, align 4, !dbg !174, !tbaa !171
  %23 = getelementptr inbounds i8, ptr %9, i64 24, !dbg !175
  store i16 0, ptr %23, align 2, !dbg !176, !tbaa !177
  %24 = load i16, ptr %10, align 2, !dbg !178, !tbaa !179
  tail call void @llvm.dbg.value(metadata i16 %24, metadata !137, metadata !DIExpression()), !dbg !139
  %25 = getelementptr inbounds i8, ptr %9, i64 36, !dbg !181
  %26 = load i16, ptr %25, align 2, !dbg !181, !tbaa !182
  store i16 %26, ptr %10, align 2, !dbg !183, !tbaa !179
  store i16 %24, ptr %25, align 2, !dbg !184, !tbaa !182
  %27 = getelementptr inbounds i8, ptr %9, i64 40, !dbg !185
  store i16 0, ptr %27, align 2, !dbg !186, !tbaa !187
  call void @llvm.lifetime.end.p0(i64 6, ptr nonnull %2), !dbg !188
  br label %28

28:                                               ; preds = %17, %13, %1
  %29 = phi i32 [ 0, %1 ], [ 3, %17 ], [ 2, %13 ], !dbg !139
  ret i32 %29, !dbg !188
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.assign(metadata, metadata, metadata, metadata, metadata, metadata) #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(readwrite, inaccessiblemem: none) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!54, !55, !56, !57, !58}
!llvm.ident = !{!59}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 50, type: !50, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Ubuntu clang version 18.1.3 (1ubuntu1)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !46, globals: !49, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_echo_kern.c", directory: "/home/vboxuser/Kernel-Bypass-Networking/src/xdp", checksumkind: CSK_MD5, checksum: "96ce6125086d0ddbcf53157188c3f297")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 6334, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "f69deee4d2e0dcde26fe2e962ebe4a8c")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 29, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "", checksumkind: CSK_MD5, checksum: "fcee415bb19db8acb968eeda6f02fa29")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!38 = !DIEnumerator(name: "IPPROTO_L2TP", value: 115)
!39 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!40 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!41 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!42 = !DIEnumerator(name: "IPPROTO_ETHERNET", value: 143)
!43 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!44 = !DIEnumerator(name: "IPPROTO_MPTCP", value: 262)
!45 = !DIEnumerator(name: "IPPROTO_MAX", value: 263)
!46 = !{!47, !48}
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!48 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!49 = !{!0}
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !51, size: 32, elements: !52)
!51 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!52 = !{!53}
!53 = !DISubrange(count: 4)
!54 = !{i32 7, !"Dwarf Version", i32 5}
!55 = !{i32 2, !"Debug Info Version", i32 3}
!56 = !{i32 1, !"wchar_size", i32 4}
!57 = !{i32 7, !"frame-pointer", i32 2}
!58 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!59 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!60 = distinct !DISubprogram(name: "xdp_udp_echo", scope: !3, file: !3, line: 10, type: !61, scopeLine: 11, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !75)
!61 = !DISubroutineType(types: !62)
!62 = !{!63, !64}
!63 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6345, size: 192, elements: !66)
!66 = !{!67, !70, !71, !72, !73, !74}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !65, file: !6, line: 6346, baseType: !68, size: 32)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !69, line: 27, baseType: !7)
!69 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!70 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !65, file: !6, line: 6347, baseType: !68, size: 32, offset: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !65, file: !6, line: 6348, baseType: !68, size: 32, offset: 64)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !65, file: !6, line: 6350, baseType: !68, size: 32, offset: 96)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !65, file: !6, line: 6351, baseType: !68, size: 32, offset: 128)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !65, file: !6, line: 6353, baseType: !68, size: 32, offset: 160)
!75 = !{!76, !77, !78, !79, !95, !125, !134, !136, !137}
!76 = !DILocalVariable(name: "ctx", arg: 1, scope: !60, file: !3, line: 10, type: !64)
!77 = !DILocalVariable(name: "data_end", scope: !60, file: !3, line: 12, type: !47)
!78 = !DILocalVariable(name: "data", scope: !60, file: !3, line: 13, type: !47)
!79 = !DILocalVariable(name: "eth", scope: !60, file: !3, line: 21, type: !80)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !82, line: 173, size: 112, elements: !83)
!82 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!83 = !{!84, !89, !90}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !81, file: !82, line: 174, baseType: !85, size: 48)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !86, size: 48, elements: !87)
!86 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!87 = !{!88}
!88 = !DISubrange(count: 6)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !81, file: !82, line: 175, baseType: !85, size: 48, offset: 48)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !81, file: !82, line: 176, baseType: !91, size: 16, offset: 96)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !92, line: 32, baseType: !93)
!92 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "bf9fbc0e8f60927fef9d8917535375a6")
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !69, line: 24, baseType: !94)
!94 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!95 = !DILocalVariable(name: "ip", scope: !60, file: !3, line: 22, type: !96)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !98, line: 87, size: 160, elements: !99)
!98 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "", checksumkind: CSK_MD5, checksum: "149778ace30a1ff208adc8783fd04b29")
!99 = !{!100, !102, !103, !104, !105, !106, !107, !108, !109, !111}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !97, file: !98, line: 89, baseType: !101, size: 4, flags: DIFlagBitField, extraData: i64 0)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !69, line: 21, baseType: !86)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !97, file: !98, line: 90, baseType: !101, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !97, file: !98, line: 97, baseType: !101, size: 8, offset: 8)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !97, file: !98, line: 98, baseType: !91, size: 16, offset: 16)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !97, file: !98, line: 99, baseType: !91, size: 16, offset: 32)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !97, file: !98, line: 100, baseType: !91, size: 16, offset: 48)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !97, file: !98, line: 101, baseType: !101, size: 8, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !97, file: !98, line: 102, baseType: !101, size: 8, offset: 72)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !97, file: !98, line: 103, baseType: !110, size: 16, offset: 80)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !92, line: 38, baseType: !93)
!111 = !DIDerivedType(tag: DW_TAG_member, scope: !97, file: !98, line: 104, baseType: !112, size: 64, offset: 96)
!112 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !97, file: !98, line: 104, size: 64, elements: !113)
!113 = !{!114, !120}
!114 = !DIDerivedType(tag: DW_TAG_member, scope: !112, file: !98, line: 104, baseType: !115, size: 64)
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !112, file: !98, line: 104, size: 64, elements: !116)
!116 = !{!117, !119}
!117 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !115, file: !98, line: 104, baseType: !118, size: 32)
!118 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !92, line: 34, baseType: !68)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !115, file: !98, line: 104, baseType: !118, size: 32, offset: 32)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "addrs", scope: !112, file: !98, line: 104, baseType: !121, size: 64)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !112, file: !98, line: 104, size: 64, elements: !122)
!122 = !{!123, !124}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !121, file: !98, line: 104, baseType: !118, size: 32)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !121, file: !98, line: 104, baseType: !118, size: 32, offset: 32)
!125 = !DILocalVariable(name: "udp", scope: !60, file: !3, line: 23, type: !126)
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!127 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !128, line: 23, size: 64, elements: !129)
!128 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "", checksumkind: CSK_MD5, checksum: "53c0d42e1bf6d93b39151764be2d20fb")
!129 = !{!130, !131, !132, !133}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !127, file: !128, line: 24, baseType: !91, size: 16)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !127, file: !128, line: 25, baseType: !91, size: 16, offset: 16)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !127, file: !128, line: 26, baseType: !91, size: 16, offset: 32)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !127, file: !128, line: 27, baseType: !110, size: 16, offset: 48)
!134 = !DILocalVariable(name: "tmp", scope: !60, file: !3, line: 30, type: !135)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !101, size: 48, elements: !87)
!136 = !DILocalVariable(name: "sip", scope: !60, file: !3, line: 36, type: !118)
!137 = !DILocalVariable(name: "sp", scope: !60, file: !3, line: 42, type: !91)
!138 = distinct !DIAssignID()
!139 = !DILocation(line: 0, scope: !60)
!140 = !DILocation(line: 12, column: 41, scope: !60)
!141 = !{!142, !143, i64 4}
!142 = !{!"xdp_md", !143, i64 0, !143, i64 4, !143, i64 8, !143, i64 12, !143, i64 16, !143, i64 20}
!143 = !{!"int", !144, i64 0}
!144 = !{!"omnipotent char", !145, i64 0}
!145 = !{!"Simple C/C++ TBAA"}
!146 = !DILocation(line: 12, column: 30, scope: !60)
!147 = !DILocation(line: 12, column: 22, scope: !60)
!148 = !DILocation(line: 13, column: 41, scope: !60)
!149 = !{!142, !143, i64 0}
!150 = !DILocation(line: 13, column: 30, scope: !60)
!151 = !DILocation(line: 13, column: 22, scope: !60)
!152 = !DILocation(line: 16, column: 38, scope: !153)
!153 = distinct !DILexicalBlock(scope: !60, file: !3, line: 16, column: 9)
!154 = !DILocation(line: 17, column: 30, scope: !153)
!155 = !DILocation(line: 18, column: 31, scope: !153)
!156 = !DILocation(line: 16, column: 9, scope: !60)
!157 = !DILocation(line: 26, column: 13, scope: !158)
!158 = distinct !DILexicalBlock(scope: !60, file: !3, line: 26, column: 9)
!159 = !{!160, !144, i64 9}
!160 = !{!"iphdr", !144, i64 0, !144, i64 0, !144, i64 1, !161, i64 2, !161, i64 4, !161, i64 6, !144, i64 8, !144, i64 9, !161, i64 10, !144, i64 12}
!161 = !{!"short", !144, i64 0}
!162 = !DILocation(line: 26, column: 22, scope: !158)
!163 = !DILocation(line: 26, column: 9, scope: !60)
!164 = !DILocation(line: 30, column: 5, scope: !60)
!165 = !DILocation(line: 31, column: 5, scope: !60)
!166 = distinct !DIAssignID()
!167 = !DILocation(line: 32, column: 39, scope: !60)
!168 = !DILocation(line: 32, column: 5, scope: !60)
!169 = !DILocation(line: 33, column: 5, scope: !60)
!170 = !DILocation(line: 36, column: 22, scope: !60)
!171 = !{!144, !144, i64 0}
!172 = !DILocation(line: 37, column: 23, scope: !60)
!173 = !DILocation(line: 37, column: 17, scope: !60)
!174 = !DILocation(line: 38, column: 17, scope: !60)
!175 = !DILocation(line: 39, column: 9, scope: !60)
!176 = !DILocation(line: 39, column: 17, scope: !60)
!177 = !{!160, !161, i64 10}
!178 = !DILocation(line: 42, column: 22, scope: !60)
!179 = !{!180, !161, i64 0}
!180 = !{!"udphdr", !161, i64 0, !161, i64 2, !161, i64 4, !161, i64 6}
!181 = !DILocation(line: 43, column: 24, scope: !60)
!182 = !{!180, !161, i64 2}
!183 = !DILocation(line: 43, column: 17, scope: !60)
!184 = !DILocation(line: 44, column: 17, scope: !60)
!185 = !DILocation(line: 45, column: 10, scope: !60)
!186 = !DILocation(line: 45, column: 17, scope: !60)
!187 = !{!180, !161, i64 6}
!188 = !DILocation(line: 48, column: 1, scope: !60)
