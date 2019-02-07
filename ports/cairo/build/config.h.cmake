/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define if building universal (internal helper macro) */
#cmakedefine AC_APPLE_UNIVERSAL_BUILD

/* whether memory barriers are needed around atomic operations */
#cmakedefine ATOMIC_OP_NEEDS_MEMORY_BARRIER

/* Define to 1 if the PDF backend can be tested (need poppler and other
   dependencies for pdf2png) */
#cmakedefine CAIRO_CAN_TEST_PDF_SURFACE

/* Define to 1 if the PS backend can be tested (needs ghostscript) */
#cmakedefine CAIRO_CAN_TEST_PS_SURFACE

/* Define to 1 if the SVG backend can be tested */
#cmakedefine CAIRO_CAN_TEST_SVG_SURFACE

/* Define to 1 if the Win32 Printing backend can be tested (needs ghostscript)
   */
#cmakedefine CAIRO_CAN_TEST_WIN32_PRINTING_SURFACE

/* Define to 1 if dlsym is available */
#cmakedefine CAIRO_HAS_DLSYM

/* Define to 1 to enable cairo's cairo-script-interpreter feature */
#cmakedefine CAIRO_HAS_INTERPRETER

/* Define to 1 to enable cairo's pthread feature */
#cmakedefine CAIRO_HAS_PTHREAD @CAIRO_HAS_PTHREAD@

/* Define to 1 if we have full pthread support */
#cmakedefine CAIRO_HAS_REAL_PTHREAD @CAIRO_HAS_REAL_PTHREAD@

/* Define to 1 if libspectre is available */
#cmakedefine CAIRO_HAS_SPECTRE

/* Define to 1 to enable cairo's symbol-lookup feature */
#cmakedefine CAIRO_HAS_SYMBOL_LOOKUP

/* Define to 1 to enable cairo's test surfaces feature */
#cmakedefine CAIRO_HAS_TEST_SURFACES

/* Define to 1 to enable cairo's cairo-trace feature */
#cmakedefine CAIRO_HAS_TRACE

/* Define to 1 to disable certain code paths that rely heavily on double
   precision floating-point calculation */
#cmakedefine DISABLE_SOME_FLOATING_POINT

/* Define to 1 if your system stores words within floats with the most
   significant word first */
#cmakedefine FLOAT_WORDS_BIGENDIAN

/* Define to (0) if freetype2 does not support color fonts */
#cmakedefine FT_HAS_COLOR

/* Enable pixman glyph cache */
#cmakedefine HAS_PIXMAN_GLYPHS

/* Define to 1 if you have the `alarm' function. */
#cmakedefine HAVE_ALARM @HAVE_ALARM@

/* Define to 1 if you have the binutils development files installed */
#cmakedefine HAVE_BFD

/* Define to 1 if your compiler supports the __builtin_return_address()
   intrinsic. */
#cmakedefine HAVE_BUILTIN_RETURN_ADDRESS

/* Define to 1 if you have the <byteswap.h> header file. */
#cmakedefine HAVE_BYTESWAP_H @HAVE_BYTESWAP_H@

/* Define to 1 if you have the `clock_gettime' function. */
#cmakedefine HAVE_CLOCK_GETTIME @HAVE_CLOCK_GETTIME@

/* Define to 1 if you have the `ctime_r' function. */
#cmakedefine HAVE_CTIME_R @HAVE_CTIME_R@

/* Enable if your compiler supports the GCC __atomic_* atomic primitives */
#cmakedefine HAVE_CXX11_ATOMIC_PRIMITIVES

/* Define to 1 if you have the <dlfcn.h> header file. */
#cmakedefine HAVE_DLFCN_H @HAVE_DLFCN_H@

/* Define to 1 if you have the `drand48' function. */
#cmakedefine HAVE_DRAND48 @HAVE_DRAND48@

/* Define to 1 if you have the `FcFini' function. */
#cmakedefine HAVE_FCFINI @HAVE_FCFINI@

/* Define to 1 if you have the `FcInit' function. */
#cmakedefine HAVE_FCINIT @HAVE_FCINIT@

/* Define to 1 if you have the <fcntl.h> header file. */
#cmakedefine HAVE_FCNTL_H @HAVE_FCNTL_H@

/* Define to 1 if you have the `feclearexcept' function. */
#cmakedefine HAVE_FECLEAREXCEPT

/* Define to 1 if you have the `fedisableexcept' function. */
#cmakedefine HAVE_FEDISABLEEXCEPT

/* Define to 1 if you have the `feenableexcept' function. */
#cmakedefine HAVE_FEENABLEEXCEPT

/* Define to 1 if you have the <fenv.h> header file. */
#cmakedefine HAVE_FENV_H @HAVE_FENV_H@

/* Define to 1 if you have the `flockfile' function. */
#cmakedefine HAVE_FLOCKFILE @HAVE_FLOCKFILE@

/* Define to 1 if you have the `fork' function. */
#cmakedefine HAVE_FORK @HAVE_FORK@

/* Define to 1 if you have the `FT_Done_MM_Var' function. */
#cmakedefine HAVE_FT_DONE_MM_VAR @HAVE_FT_DONE_MM_VAR@

/* Define to 1 if you have the `FT_Get_Var_Design_Coordinates' function. */
#cmakedefine HAVE_FT_GET_VAR_DESIGN_COORDINATES @HAVE_FT_GET_VAR_DESIGN_COORDINATES@

/* Define to 1 if you have the `FT_Get_X11_Font_Format' function. */
#cmakedefine HAVE_FT_GET_X11_FONT_FORMAT @HAVE_FT_GET_X11_FONT_FORMAT@

/* Define to 1 if you have the `FT_GlyphSlot_Embolden' function. */
#cmakedefine HAVE_FT_GLYPHSLOT_EMBOLDEN @HAVE_FT_GLYPHSLOT_EMBOLDEN@

/* Define to 1 if you have the `FT_GlyphSlot_Oblique' function. */
#cmakedefine HAVE_FT_GLYPHSLOT_OBLIQUE @HAVE_FT_GLYPHSLOT_OBLIQUE@

/* Define to 1 if you have the `FT_Library_SetLcdFilter' function. */
#cmakedefine HAVE_FT_LIBRARY_SETLCDFILTER @HAVE_FT_LIBRARY_SETLCDFILTER@

/* Define to 1 if you have the `FT_Load_Sfnt_Table' function. */
#cmakedefine HAVE_FT_LOAD_SFNT_TABLE @HAVE_FT_LOAD_SFNT_TABLE@

/* Define to 1 if you have the `funlockfile' function. */
#cmakedefine HAVE_FUNLOCKFILE @HAVE_FUNLOCKFILE@

/* Enable if your compiler supports the legacy GCC __sync_* atomic primitives
   */
#cmakedefine HAVE_GCC_LEGACY_ATOMICS

/* Whether you have gcov */
#cmakedefine HAVE_GCOV @HAVE_GCOV@

/* Define to 1 if you have the `getline' function. */
#cmakedefine HAVE_GETLINE @HAVE_GETLINE@

/* Enable if your compiler supports the Intel __sync_* atomic primitives */
#cmakedefine HAVE_INTEL_ATOMIC_PRIMITIVES @HAVE_INTEL_ATOMIC_PRIMITIVES@

/* Define to 1 if you have the <inttypes.h> header file. */
#cmakedefine HAVE_INTTYPES_H @HAVE_INTTYPES_H@

/* Define to 1 if you have the <io.h> header file. */
#cmakedefine HAVE_IO_H @HAVE_IO_H@

/* Define to 1 if you have the <libgen.h> header file. */
#cmakedefine HAVE_LIBGEN_H @HAVE_LIBGEN_H@

/* Define to 1 if you have the `rt' library (-lrt). */
#cmakedefine HAVE_LIBRT

/* Enable if you have libatomic-ops-dev installed */
#cmakedefine HAVE_LIB_ATOMIC_OPS

/* Define to 1 if you have the `link' function. */
#cmakedefine HAVE_LINK @HAVE_LINK@

/* Define to 1 if you have the `localtime_r' function. */
#cmakedefine HAVE_LOCALTIME_R

/* Define to 1 if you have the Valgrind lockdep tool */
#cmakedefine HAVE_LOCKDEP

/* Define to 1 if you have lzo available */
#cmakedefine HAVE_LZO

/* Define to 1 if you have the Valgrind memfault tool */
#cmakedefine HAVE_MEMFAULT

/* Define to 1 if you have the <memory.h> header file. */
#cmakedefine HAVE_MEMORY_H @HAVE_MEMORY_H@

/* Define to non-zero if your system has mkdir, and to 2 if your version of
   mkdir requires a mode parameter */
#cmakedefine HAVE_MKDIR @HAVE_MKDIR@

/* Define to 1 if you have the `mmap' function. */
#cmakedefine HAVE_MMAP @HAVE_MMAP@

/* Define to 1 if you have the `newlocale' function. */
#cmakedefine HAVE_NEWLOCALE

/* Enable if you have MacOS X atomic operations */
#cmakedefine HAVE_OS_ATOMIC_OPS

/* Define to 1 if you have the `poppler_page_render' function. */
#cmakedefine HAVE_POPPLER_PAGE_RENDER @HAVE_POPPLER_PAGE_RENDER@

/* Define to 1 if you have the `raise' function. */
#cmakedefine HAVE_RAISE @HAVE_RAISE@

/* Define to 1 if you have the `rsvg_pixbuf_from_file' function. */
#cmakedefine HAVE_RSVG_PIXBUF_FROM_FILE @HAVE_RSVG_PIXBUF_FROM_FILE@

/* Define to 1 if you have the `sched_getaffinity' function. */
#cmakedefine HAVE_SCHED_GETAFFINITY @HAVE_SCHED_GETAFFINITY@

/* Define to 1 if you have the <sched.h> header file. */
#cmakedefine HAVE_SCHED_H @HAVE_SCHED_H@

/* Define to 1 if you have the <setjmp.h> header file. */
#cmakedefine HAVE_SETJMP_H @HAVE_SETJMP_H@

/* Define to 1 if you have the <signal.h> header file. */
#cmakedefine HAVE_SIGNAL_H @HAVE_SIGNAL_H@

/* Define to 1 if you have the <stdint.h> header file. */
#cmakedefine HAVE_STDINT_H @HAVE_STDINT_H@

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H @HAVE_STDLIB_H@

/* Define to 1 if you have the <strings.h> header file. */
#cmakedefine HAVE_STRINGS_H @HAVE_STRINGS_H@

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H @HAVE_STRING_H@

/* Define to 1 if you have the `strndup' function. */
#cmakedefine HAVE_STRNDUP @HAVE_STRNDUP@

/* Define to 1 if you have the `strtod_l' function. */
#cmakedefine HAVE_STRTOD_L

/* Define to 1 if you have the <sys/int_types.h> header file. */
#cmakedefine HAVE_SYS_INT_TYPES_H @HAVE_SYS_INT_TYPES_H@

/* Define to 1 if you have the <sys/ioctl.h> header file. */
#cmakedefine HAVE_SYS_IOCTL_H @HAVE_SYS_IOCTL_H@

/* Define to 1 if you have the <sys/mman.h> header file. */
#cmakedefine HAVE_SYS_MMAN_H @HAVE_SYS_MMAN_H@

/* Define to 1 if you have the <sys/poll.h> header file. */
#cmakedefine HAVE_SYS_POLL_H @HAVE_SYS_POLL_H@

/* Define to 1 if you have the <sys/socket.h> header file. */
#cmakedefine HAVE_SYS_SOCKET_H @HAVE_SYS_SOCKET_H@

/* Define to 1 if you have the <sys/stat.h> header file. */
#cmakedefine HAVE_SYS_STAT_H @HAVE_SYS_STAT_H@

/* Define to 1 if you have the <sys/types.h> header file. */
#cmakedefine HAVE_SYS_TYPES_H @HAVE_SYS_TYPES_H@

/* Define to 1 if you have the <sys/un.h> header file. */
#cmakedefine HAVE_SYS_UN_H @HAVE_SYS_UN_H@

/* Define to 1 if you have the <sys/wait.h> header file. */
#cmakedefine HAVE_SYS_WAIT_H @HAVE_SYS_WAIT_H@

/* Define to 1 if you have the <time.h> header file. */
#cmakedefine HAVE_TIME_H @HAVE_TIME_H@

/* Define to 1 if typeof works with your compiler. */
#cmakedefine HAVE_TYPEOF

/* Define to 1 if the system has the type `uint128_t'. */
#cmakedefine HAVE_UINT128_T @HAVE_UINT128_T@

/* Define to 1 if the system has the type `uint64_t'. */
#cmakedefine HAVE_UINT64_T @HAVE_UINT64_T@

/* Define to 1 if you have the <unistd.h> header file. */
#cmakedefine HAVE_UNISTD_H @HAVE_UNISTD_H@

/* Define to 1 if you have Valgrind */
#cmakedefine HAVE_VALGRIND @HAVE_VALGRIND@

/* Define to 1 if you have the `waitpid' function. */
#cmakedefine HAVE_WAITPID @HAVE_WAITPID@

/* Define to 1 if you have the <X11/extensions/shmproto.h> header file. */
#cmakedefine HAVE_X11_EXTENSIONS_SHMPROTO_H

/* Define to 1 if you have the <X11/extensions/shmstr.h> header file. */
#cmakedefine HAVE_X11_EXTENSIONS_SHMSTR_H

/* Define to 1 if you have the <X11/extensions/XShm.h> header file. */
#cmakedefine HAVE_X11_EXTENSIONS_XSHM_H

/* Define to 1 if you have the <xlocale.h> header file. */
#cmakedefine HAVE_XLOCALE_H

/* Define to 1 if you have the `XRenderCreateConicalGradient' function. */
#cmakedefine HAVE_XRENDERCREATECONICALGRADIENT

/* Define to 1 if you have the `XRenderCreateLinearGradient' function. */
#cmakedefine HAVE_XRENDERCREATELINEARGRADIENT

/* Define to 1 if you have the `XRenderCreateRadialGradient' function. */
#cmakedefine HAVE_XRENDERCREATERADIALGRADIENT

/* Define to 1 if you have the `XRenderCreateSolidFill' function. */
#cmakedefine HAVE_XRENDERCREATESOLIDFILL

/* Define to 1 if you have zlib available */
#cmakedefine HAVE_ZLIB @HAVE_ZLIB@

/* Define to 1 if the system has the type `__uint128_t'. */
#cmakedefine HAVE___UINT128_T @HAVE___UINT128_T@

/* Define to 1 if shared memory segments are released deferred. */
#cmakedefine IPC_RMID_DEFERRED_RELEASE

/* Define to the sub-directory in which libtool stores uninstalled libraries. */
#cmakedefine LT_OBJDIR

/* Define to the address where bug reports for this package should be sent. */
#cmakedefine PACKAGE_BUGREPORT

/* Define to the full name of this package. */
#cmakedefine PACKAGE_NAME

/* Define to the full name and version of this package. */
#cmakedefine PACKAGE_STRING

/* Define to the one symbol short name of this package. */
#cmakedefine PACKAGE_TARNAME

/* Define to the home page for this package. */
#cmakedefine PACKAGE_URL

/* Define to the version of this package. */
#cmakedefine PACKAGE_VERSION

/* Shared library file extension */
#cmakedefine SHARED_LIB_EXT @SHARED_LIB_EXT@

/* The size of `int', as computed by sizeof. */
#cmakedefine SIZEOF_INT @SIZEOF_INT@

/* The size of `long', as computed by sizeof. */
#cmakedefine SIZEOF_LONG @SIZEOF_LONG@

/* The size of `long long', as computed by sizeof. */
#cmakedefine SIZEOF_LONG_LONG @SIZEOF_LONG_LONG@

/* The size of `size_t', as computed by sizeof. */
#cmakedefine SIZEOF_SIZE_T @SIZEOF_SIZE_T@

/* The size of `void *', as computed by sizeof. */
#cmakedefine SIZEOF_VOID_P @SIZEOF_VOID_P@

/* Define to 1 if you have the ANSI C header files. */
#cmakedefine STDC_HEADERS @HAVE_STDLIB_H@
