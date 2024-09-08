import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
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
  // Dart wrapper for the SHA-256 operations
  static void sha256Init(Pointer<SHA256_CTX> ctx) => _bindings.sha256_init(ctx);

  static void sha256Update(Pointer<SHA256_CTX> ctx, Uint8List data) {
    final Pointer<UnsignedChar> dataPtr =
        malloc.allocate<UnsignedChar>(data.length);
    for (int i = 0; i < data.length; i++) {
      dataPtr[i] = data[i];
    }
    _bindings.sha256_update(ctx, dataPtr, data.length);
    malloc.free(dataPtr);
  }

  static void sha256Final(Pointer<SHA256_CTX> ctx, Uint8List hash) {
    final Pointer<UnsignedChar> hashPtr =
        malloc.allocate<UnsignedChar>(32); // 256-bit hash
    _bindings.sha256_final(ctx, hashPtr);
    for (int i = 0; i < 32; i++) {
      hash[i] = hashPtr[i];
    }

    malloc.free(hashPtr);
  }
}
