/*********************************************************************
* Filename:   blowfish.h
* Author:     Brad Conte (brad AT bradconte.com)
* Copyright:
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Defines the API for the corresponding Blowfish implementation.
*********************************************************************/
#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif
#ifndef BLOWFISH_H
#define BLOWFISH_H

/*************************** HEADER FILES ***************************/
#include <stddef.h>

/****************************** MACROS ******************************/
#define BLOWFISH_BLOCK_SIZE 8           // Blowfish operates on 8 bytes at a time

/**************************** DATA TYPES ****************************/
typedef unsigned char BYTE;             // 8-bit byte
typedef unsigned int  WORD;             // 32-bit word, change to "long" for 16-bit machines

typedef struct {
   WORD p[18];
   WORD s[4][256];
} BLOWFISH_KEY;

/*********************** FUNCTION DECLARATIONS **********************/
FFI_PLUGIN_EXPORT void blowfish_key_setup(const BYTE user_key[], BLOWFISH_KEY *keystruct, size_t len);
FFI_PLUGIN_EXPORT void blowfish_encrypt(const BYTE in[], BYTE out[], const BLOWFISH_KEY *keystruct);
FFI_PLUGIN_EXPORT void blowfish_decrypt(const BYTE in[], BYTE out[], const BLOWFISH_KEY *keystruct);

#endif   // BLOWFISH_H
