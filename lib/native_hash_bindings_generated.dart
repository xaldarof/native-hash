// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

/// Bindings for `src/native_hash.h`.
///
/// Regenerate bindings with `dart run ffigen --config ffigen.yaml`.
///
class NativeHashBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeHashBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeHashBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// FUNCTION DECLARATIONS
  void sha256_init(
    ffi.Pointer<SHA256_CTX> ctx,
  ) {
    return _sha256_init(
      ctx,
    );
  }

  late final _sha256_initPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<SHA256_CTX>)>>(
          'sha256_init');
  late final _sha256_init =
      _sha256_initPtr.asFunction<void Function(ffi.Pointer<SHA256_CTX>)>();

  void sha256_update(
    ffi.Pointer<SHA256_CTX> ctx,
    ffi.Pointer<BYTE> data,
    int len,
  ) {
    return _sha256_update(
      ctx,
      data,
      len,
    );
  }

  late final _sha256_updatePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<SHA256_CTX>, ffi.Pointer<BYTE>,
              ffi.Size)>>('sha256_update');
  late final _sha256_update = _sha256_updatePtr.asFunction<
      void Function(ffi.Pointer<SHA256_CTX>, ffi.Pointer<BYTE>, int)>();

  void sha256_final(
    ffi.Pointer<SHA256_CTX> ctx,
    ffi.Pointer<BYTE> hash,
  ) {
    return _sha256_final(
      ctx,
      hash,
    );
  }

  late final _sha256_finalPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Pointer<SHA256_CTX>, ffi.Pointer<BYTE>)>>('sha256_final');
  late final _sha256_final = _sha256_finalPtr
      .asFunction<void Function(ffi.Pointer<SHA256_CTX>, ffi.Pointer<BYTE>)>();
}

final class SHA256_CTX extends ffi.Struct {
  @ffi.Array.multi([64])
  external ffi.Array<BYTE> data;

  @WORD()
  external int datalen;

  @ffi.UnsignedLongLong()
  external int bitlen;

  @ffi.Array.multi([8])
  external ffi.Array<WORD> state;
}

/// DATA TYPES
typedef BYTE = ffi.UnsignedChar;
typedef DartBYTE = int;
typedef WORD = ffi.UnsignedInt;
typedef DartWORD = int;

const int SHA256_BLOCK_SIZE = 32;
