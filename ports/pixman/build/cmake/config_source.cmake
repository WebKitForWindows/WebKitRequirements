/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define if building universal (internal helper macro) */
#cmakedefine AC_APPLE_UNIVERSAL_BUILD

/* Whether we have alarm() */
#cmakedefine HAVE_ALARM @HAVE_ALARM@

/* Whether the compiler supports __builtin_clz */
#cmakedefine HAVE_BUILTIN_CLZ @HAVE_BUILTIN_CLZ@

/* Define to 1 if you have the <dlfcn.h> header file. */
#cmakedefine HAVE_DLFCN_H @HAVE_DLFCN_H@

/* Whether we have feenableexcept() */
#cmakedefine HAVE_FEENABLEEXCEPT @HAVE_FEENABLEEXCEPT@

/* Define to 1 if we have <fenv.h> */
#cmakedefine HAVE_FENV_H @HAVE_FENV_H@

/* Whether the tool chain supports __float128 */
#cmakedefine HAVE_FLOAT128 @HAVE_FLOAT128@

/* Define to 1 if you have the `getisax' function. */
#cmakedefine HAVE_GETISAX @HAVE_GETISAX@

/* Whether we have getpagesize() */
#cmakedefine HAVE_GETPAGESIZE @HAVE_GETPAGESIZE@

/* Whether we have gettimeofday() */
#cmakedefine HAVE_GETTIMEOFDAY @HAVE_GETTIMEOFDAY@

/* Define to 1 if you have the <inttypes.h> header file. */
#cmakedefine HAVE_INTTYPES_H @HAVE_INTTYPES_H@

/* Define to 1 if you have the `pixman-1' library (-lpixman-1). */
#cmakedefine HAVE_LIBPIXMAN_1

/* Whether we have libpng */
#cmakedefine HAVE_LIBPNG @HAVE_LIBPNG@

/* Define to 1 if you have the <memory.h> header file. */
#cmakedefine HAVE_MEMORY_H @HAVE_MEMORY_H@

/* Whether we have mmap() */
#cmakedefine HAVE_MMAP @HAVE_MMAP@

/* Whether we have mprotect() */
#cmakedefine HAVE_MPROTECT @HAVE_MPROTECT@

/* Whether we have posix_memalign() */
#cmakedefine HAVE_POSIX_MEMALIGN @HAVE_POSIX_MEMALIGN@

/* Whether pthreads is supported */
#cmakedefine HAVE_PTHREADS @HAVE_PTHREADS@

/* Whether we have sigaction() */
#cmakedefine HAVE_SIGACTION @HAVE_SIGACTION@

/* Define to 1 if you have the <stdint.h> header file. */
#cmakedefine HAVE_STDINT_H @HAVE_STDINT_H@

/* Define to 1 if you have the <stdlib.h> header file. */
#cmakedefine HAVE_STDLIB_H @HAVE_STDLIB_H@

/* Define to 1 if you have the <strings.h> header file. */
#cmakedefine HAVE_STRINGS_H @HAVE_STRINGS_H@

/* Define to 1 if you have the <string.h> header file. */
#cmakedefine HAVE_STRING_H @HAVE_STRING_H@

/* Define to 1 if we have <sys/mman.h> */
#cmakedefine HAVE_SYS_MMAN_H @HAVE_SYS_MMAN_H@

/* Define to 1 if you have the <sys/stat.h> header file. */
#cmakedefine HAVE_SYS_STAT_H @HAVE_SYS_STAT_H@

/* Define to 1 if you have the <sys/types.h> header file. */
#cmakedefine HAVE_SYS_TYPES_H @HAVE_SYS_TYPES_H@

/* Define to 1 if you have the <unistd.h> header file. */
#cmakedefine HAVE_UNISTD_H @HAVE_UNISTD_H@

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#cmakedefine LT_OBJDIR

/* Name of package */
#cmakedefine PACKAGE @PACKAGE@

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

/* enable TIMER_BEGIN/TIMER_END macros */
#cmakedefine PIXMAN_TIMERS

/* The size of `long', as computed by sizeof. */
#cmakedefine SIZEOF_LONG @SIZEOF_LONG@

/* Define to 1 if you have the ANSI C header files. */
#cmakedefine STDC_HEADERS 1

/* The compiler supported TLS storage class */
#cmakedefine TLS

/* Whether the tool chain supports __attribute__((constructor)) */
#cmakedefine TOOLCHAIN_SUPPORTS_ATTRIBUTE_CONSTRUCTOR

/* use ARM IWMMXT compiler intrinsics */
#cmakedefine USE_ARM_IWMMXT @USE_ARM_IWMMXT@

/* use ARM NEON assembly optimizations */
#cmakedefine USE_ARM_NEON @USE_ARM_NEON@

/* use ARM SIMD assembly optimizations */
#cmakedefine USE_ARM_SIMD @USE_ARM_SIMD@

/* use GNU-style inline assembler */
#cmakedefine USE_GCC_INLINE_ASM

/* use Loongson Multimedia Instructions */
#cmakedefine USE_LOONGSON_MMI @USE_LOONGSON_MMI@

/* use MIPS DSPr2 assembly optimizations */
#cmakedefine USE_MIPS_DSPR2 @USE_MIPS_DSPR2@

/* use OpenMP in the test suite */
#cmakedefine USE_OPENMP @OPENMP_FOUND@

/* use SSE2 compiler intrinsics */
#cmakedefine USE_SSE2 @USE_SSE2@

/* use SSSE3 compiler intrinsics */
#cmakedefine USE_SSSE3 @USE_SSSE3@

/* use VMX compiler intrinsics */
#cmakedefine USE_VMX @USE_VMX@

/* use x86 MMX compiler intrinsics */
#cmakedefine USE_X86_MMX @USE_X86_MMX@

/* use GCC Vector Extensions */
#cmakedefine HAVE_GCC_VECTOR_EXTENSIONS @HAVE_GCC_VECTOR_EXTENSIONS@

/* use OpenMP
#cmakedefine USE_OPENMP @USE_OPENMP@

/* Version number of package */
#cmakedefine VERSION @PIXMAN_VERSION@

/* Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
   significant byte first (like Motorola and SPARC, unlike Intel). */
#if defined AC_APPLE_UNIVERSAL_BUILD
# if defined __BIG_ENDIAN__
#  define WORDS_BIGENDIAN 1
# endif
#else
# ifndef WORDS_BIGENDIAN
#  undef WORDS_BIGENDIAN
# endif
#endif

/* Define to `__inline__' or `__inline' if that's what the C compiler
   calls it, or to nothing if 'inline' is not supported under any name.  */
#ifndef __cplusplus
#undef inline
#endif