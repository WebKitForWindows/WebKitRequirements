# Copyright (c) 2018, NikitaFeodonit. All rights reserved.
#
## ICU build file for CMake build tools

### Common executables libraries

# PRIVATE
# LIBS = $(LIBICUTOOLUTIL) $(LIBICUI18N) $(LIBICUUC) $(DEFAULT_LIBS) $(LIB_M)
target_link_libraries(${exe_NAME} PRIVATE ${ICULIBS_TOOLUTIL} ${LIB_M})
