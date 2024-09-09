/*********************************************************************
* Filename:   md5.h
* Author:     Brad Conte (brad AT bradconte.com)
* Copyright:
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Defines the API for the corresponding MD5 implementation.
*********************************************************************/


#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif


#ifndef MD5_H
#define MD5_H

/*************************** HEADER FILES ***************************/
#include <stddef.h>

/****************************** MACROS ******************************/
#define MD5_BLOCK_SIZE 16               // MD5 outputs a 16 byte digest

/**************************** DATA TYPES ****************************/
typedef unsigned char BYTE;             // 8-bit byte
typedef unsigned int  WORD;             // 32-bit word, change to "long" for 16-bit machines

typedef struct {
   BYTE data[64];
   WORD datalen;
   unsigned long long bitlen;
   WORD state[4];
} MD5_CTX;

/*********************** FUNCTION DECLARATIONS **********************/
FFI_PLUGIN_EXPORT void md5_init(MD5_CTX *ctx);
FFI_PLUGIN_EXPORT void md5_update(MD5_CTX *ctx, const BYTE data[], size_t len);
FFI_PLUGIN_EXPORT void md5_final(MD5_CTX *ctx, BYTE hash[]);

#endif   // MD5_H
