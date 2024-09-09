# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(native_hash_library VERSION 0.0.1 LANGUAGES C)

add_library(native_hash SHARED
        "sha256.c"
        "aes.c"
        "arcfour.c"
        "base64.c"
        "blowfish.c"
        "des.c"
        "md2.c"
        "md5.c"
        "rot-13.c"
        "sha1.c"
)

set_target_properties(native_hash PROPERTIES
        PUBLIC_HEADER sha256.h
        OUTPUT_NAME "native_hash"
)

target_compile_definitions(native_hash PUBLIC DART_SHARED_LIB)
