/*********************************************************************
* Filename:   md2.h
* Author:     Brad Conte (brad AT bradconte.com)
* Copyright:
* Disclaimer: This code is presented "as is" without any guarantees.
* Details:    Defines the API for the corresponding MD2 implementation.
*********************************************************************/

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif


#ifndef MD2_H
#define MD2_H

/*************************** HEADER FILES ***************************/
#include <stddef.h>

/****************************** MACROS ******************************/
#define MD2_BLOCK_SIZE 16

/**************************** DATA TYPES ****************************/
typedef unsigned char BYTE;             // 8-bit byte

typedef struct {
   BYTE data[16];
   BYTE state[48];
   BYTE checksum[16];
   int len;
} MD2_CTX;

/*********************** FUNCTION DECLARATIONS **********************/
FFI_PLUGIN_EXPORT void md2_init(MD2_CTX *ctx);
FFI_PLUGIN_EXPORT void md2_update(MD2_CTX *ctx, const BYTE data[], size_t len);
FFI_PLUGIN_EXPORT void md2_final(MD2_CTX *ctx, BYTE hash[]);   // size of hash must be MD2_BLOCK_SIZE

#endif   // MD2_H
