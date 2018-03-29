set(ICU_COMMON_SOURCES
  appendable.cpp
  bmpset.cpp
  brkeng.cpp
  brkiter.cpp
  bytesinkutil.cpp
  bytestream.cpp
  bytestrie.cpp
  bytestriebuilder.cpp
  bytestrieiterator.cpp
  caniter.cpp
  chariter.cpp
  charstr.cpp
  cmemory.cpp
  cstr.cpp
  cstring.cpp
  cwchar.cpp
  dictbe.cpp
  dictionarydata.cpp
  dtintrv.cpp
  edits.cpp
  errorcode.cpp
  filteredbrk.cpp
  filterednormalizer2.cpp
  icudataver.cpp
  icuplug.cpp
  listformatter.cpp
  loadednormalizer2impl.cpp
  locavailable.cpp
  locbased.cpp
  locdispnames.cpp
  locdspnm.cpp
  locid.cpp
  loclikely.cpp
  locmap.cpp
  locresdata.cpp
  locutil.cpp
  messagepattern.cpp
  normalizer2.cpp
  normalizer2impl.cpp
  normlzr.cpp
  parsepos.cpp
  patternprops.cpp
  pluralmap.cpp
  propname.cpp
  propsvec.cpp
  punycode.cpp
  putil.cpp
  rbbi.cpp
  rbbi_cache.cpp
  rbbidata.cpp
  rbbinode.cpp
  rbbirb.cpp
  rbbiscan.cpp
  rbbisetb.cpp
  rbbistbl.cpp
  rbbitblb.cpp
  resbund.cpp
  resbund_cnv.cpp
  resource.cpp
  ruleiter.cpp
  schriter.cpp
  serv.cpp
  servlk.cpp
  servlkf.cpp
  servls.cpp
  servnotf.cpp
  servrbf.cpp
  servslkf.cpp
  sharedobject.cpp
  simpleformatter.cpp
  stringpiece.cpp
  stringtriebuilder.cpp
  uarrsort.cpp
  ubidi.cpp
  ubidi_props.cpp
  ubidiln.cpp
  ubiditransform.cpp
  ubidiwrt.cpp
  ubrk.cpp
  ucase.cpp
  ucasemap.cpp
  ucasemap_titlecase_brkiter.cpp
  ucat.cpp
  uchar.cpp
  ucharstrie.cpp
  ucharstriebuilder.cpp
  ucharstrieiterator.cpp
  uchriter.cpp
  ucln_cmn.cpp
  ucmndata.cpp
  ucnv.cpp
  ucnv2022.cpp
  ucnv_bld.cpp
  ucnv_cb.cpp
  ucnv_cnv.cpp
  ucnv_ct.cpp
  ucnv_err.cpp
  ucnv_ext.cpp
  ucnv_io.cpp
  ucnv_lmb.cpp
  ucnv_set.cpp
  ucnv_u16.cpp
  ucnv_u32.cpp
  ucnv_u7.cpp
  ucnv_u8.cpp
  ucnvbocu.cpp
  ucnvdisp.cpp
  ucnvhz.cpp
  ucnvisci.cpp
  ucnvlat1.cpp
  ucnvmbcs.cpp
  ucnvscsu.cpp
  ucnvsel.cpp
  ucol_swp.cpp
  ucurr.cpp
  udata.cpp
  udatamem.cpp
  udataswp.cpp
  uenum.cpp
  uhash.cpp
  uhash_us.cpp
  uidna.cpp
  uinit.cpp
  uinvchar.cpp
  uiter.cpp
  ulist.cpp
  ulistformatter.cpp
  uloc.cpp
  uloc_keytype.cpp
  uloc_tag.cpp
  umapfile.cpp
  umath.cpp
  umutex.cpp
  unames.cpp
  unifiedcache.cpp
  unifilt.cpp
  unifunct.cpp
  uniset.cpp
  uniset_closure.cpp
  uniset_props.cpp
  unisetspan.cpp
  unistr.cpp
  unistr_case.cpp
  unistr_case_locale.cpp
  unistr_cnv.cpp
  unistr_props.cpp
  unistr_titlecase_brkiter.cpp
  unorm.cpp
  unormcmp.cpp
  uobject.cpp
  uprops.cpp
  ures_cnv.cpp
  uresbund.cpp
  uresdata.cpp
  usc_impl.cpp
  uscript.cpp
  uscript_props.cpp
  uset.cpp
  uset_props.cpp
  usetiter.cpp
  ushape.cpp
  usprep.cpp
  ustack.cpp
  ustr_cnv.cpp
  ustr_titlecase_brkiter.cpp
  ustr_wcs.cpp
  ustrcase.cpp
  ustrcase_locale.cpp
  ustrenum.cpp
  ustrfmt.cpp
  ustring.cpp
  ustrtrns.cpp
  utext.cpp
  utf_impl.cpp
  util.cpp
  util_props.cpp
  utrace.cpp
  utrie.cpp
  utrie2.cpp
  utrie2_builder.cpp
  uts46.cpp
  utypes.cpp
  uvector.cpp
  uvectr32.cpp
  uvectr64.cpp
  wintz.cpp
)

add_library(icuuc ${ICU_COMMON_SOURCES})
target_include_directories(icuuc PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
)
target_compile_definitions(icuuc PRIVATE 
  U_COMMON_IMPLEMENTATION
  ${ICU_DEFINITIONS}
)
set_target_properties(icuuc PROPERTIES
  RUNTIME_OUTPUT_NAME icuuc${ICU_MAJOR_VERSION}
  COMPILE_FLAGS ${RTTI_FLAG}
)

if (BUILD_SHARED_LIBS AND WIN32)
  add_dependencies(icuuc icudt)

  target_link_libraries(icuuc ${CMAKE_BINARY_DIR}/data/icudt.lib)
endif ()

file(GLOB ICU_COMMON_PUBLIC_HEADERS unicode/*.h)

install(
  FILES ${ICU_COMMON_PUBLIC_HEADERS}
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/unicode
)

install(
  TARGETS icuuc
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
