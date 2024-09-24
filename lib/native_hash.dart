import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'native_hash_bindings_generated.dart';

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
/// A longer lived native function, which occupies the thread calling it.
///
/// Do not call these kind of native functions in the main isolate. They will
/// block Dart execution. This will cause dropped frames in Flutter applications.
/// Instead, call these native functions on a separate isolate.
///
/// Modify this to suit your own use case. Example use cases:
///
/// 1. Reuse a single isolate for various different kinds of requests.
/// 2. Use multiple helper isolates for parallel execution.
const String _libName = 'native_hash';

/// The dynamic library in which the symbols for [NativeHashBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final NativeHashBindings _bindings = NativeHashBindings(_dylib);

class NativeHashCore {
  static Uint8List sha256(Uint8List data) {
    final ctx = malloc<SHA256_CTX>(sizeOf<SHA256_CTX>());
    _bindings.sha256_init(ctx);
    _sha256Update(ctx, data);
    Uint8List hash = Uint8List(32);

    _sha256Final(ctx, hash);
    return hash;
  }

  static Uint8List md5(Uint8List data) {
    final ctx = malloc<MD5_CTX>(sizeOf<MD5_CTX>());

    _bindings.md5_init(ctx);

    _md5Update(ctx, data);

    Uint8List hash = Uint8List(16);

    _md5Final(ctx, hash);

    malloc.free(ctx);

    return hash;
  }

  static void _md5Update(Pointer<MD5_CTX> ctx, Uint8List data) {
    final Pointer<UnsignedChar> dataPtr =
        malloc.allocate<UnsignedChar>(data.length);

    for (int i = 0; i < data.length; i++) {
      dataPtr[i] = data[i];
    }

    _bindings.md5_update(ctx, dataPtr, data.length);

    malloc.free(dataPtr);
  }

  static void _md5Final(Pointer<MD5_CTX> ctx, Uint8List hash) {
    final Pointer<UnsignedChar> hashPtr = malloc.allocate<UnsignedChar>(16);

    _bindings.md5_final(ctx, hashPtr);

    for (int i = 0; i < 16; i++) {
      hash[i] = hashPtr[i];
    }

    malloc.free(hashPtr);
  }

  static void _sha256Update(Pointer<SHA256_CTX> ctx, Uint8List data) {
    final Pointer<UnsignedChar> dataPtr =
        malloc.allocate<UnsignedChar>(data.length);
    for (int i = 0; i < data.length; i++) {
      dataPtr[i] = data[i];
    }
    _bindings.sha256_update(ctx, dataPtr, data.length);
    malloc.free(dataPtr);
  }

  static void _sha256Final(Pointer<SHA256_CTX> ctx, Uint8List hash) {
    final Pointer<UnsignedChar> hashPtr = malloc.allocate<UnsignedChar>(32);
    _bindings.sha256_final(ctx, hashPtr);
    for (int i = 0; i < 32; i++) {
      hash[i] = hashPtr[i];
    }

    malloc.free(hashPtr);
  }

  static Uint8List md2(Uint8List data) {
    final ctx = malloc<MD2_CTX>(sizeOf<MD2_CTX>());
    try {
      _bindings.md2_init(ctx);
      _md2Update(ctx, data);

      final hash = malloc<Uint8>(MD2_BLOCK_SIZE);
      try {
        _bindings.md2_final(ctx, hash.cast<BYTE1>());

        return Uint8List.fromList(hash.asTypedList(MD2_BLOCK_SIZE));
      } finally {
        malloc.free(hash);
      }
    } finally {
      malloc.free(ctx);
    }
  }

  static void _md2Update(Pointer<MD2_CTX> ctx, Uint8List data) {
    final dataPtr = malloc<Uint8>(data.length);
    try {
      dataPtr.asTypedList(data.length).setAll(0, data);
      _bindings.md2_update(ctx, dataPtr.cast<BYTE1>(), data.length);
    } finally {
      malloc.free(dataPtr);
    }
  }

  static Uint8List sha1(Uint8List data) {
    final ctx = malloc<SHA1_CTX>(sizeOf<SHA1_CTX>());
    try {
      _bindings.sha1_init(ctx);
      _sha1Update(ctx, data);

      final hash = malloc<Uint8>(SHA1_BLOCK_SIZE);
      try {
        _bindings.sha1_final(ctx, hash.cast<BYTE3>());

        return Uint8List.fromList(hash.asTypedList(SHA1_BLOCK_SIZE));
      } finally {
        malloc.free(hash);
      }
    } finally {
      malloc.free(ctx);
    }
  }

  static void _sha1Update(Pointer<SHA1_CTX> ctx, Uint8List data) {
    final dataPtr = malloc<BYTE3>(data.length);
    try {
      for (int i = 0; i < 32; i++) {
        dataPtr[i] = data[i];
      }
      _bindings.sha1_update(ctx, dataPtr, data.length);
    } finally {
      malloc.free(dataPtr);
    }
  }

  static String rot13(String input) {
    final strPtr = input.toNativeUtf8();
    try {
      _bindings.rot13(strPtr.cast());
      return strPtr.toDartString();
    } finally {
      malloc.free(strPtr);
    }
  }
}
