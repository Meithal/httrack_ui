#!/bin/bash


/opt/homebrew/bin/gcc-16 \
-objc-verion=objc1 \
-include stubs_gcc.h \
-DRETRO_CHECK \
-DHTS_DO_NOT_REDEFINE_in_addr_t=1 \
-DHAVE_STRNLEN=1 \
-I../../httrack/src \
-I../../httrack/src/coucal \
-I../../httrack/portable/include \
*.m
