import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'package:native_hash/native_hash.dart';
import 'package:native_hash/native_hash_bindings_generated.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  String bytesToHex(Uint8List bytes) {
    final buffer = StringBuffer();
    for (var byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                FloatingActionButton(onPressed: () {
                  final bytes = File(
                          '/data/data/com.example.native_hash_example/app_flutter/flutter_assets/kernel_blob.bin')
                      .readAsBytesSync();
                  _testNativeC(bytes);
                  _testDart(bytes);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _testDart(Uint8List bytes) {
    final start = DateTime.now();
    final hash = sha256.convert(bytes);
    final end = DateTime.now();
    print((end.millisecondsSinceEpoch - start.millisecondsSinceEpoch));
    print('Dart');
    print(bytesToHex(Uint8List.fromList(hash.bytes)));
  }

  _testNativeC(Uint8List bytes) {
    final start = DateTime.now();
    final ctx = ffi.malloc<SHA256_CTX>(sizeOf<SHA256_CTX>());

    NativeHashCore.sha256Init(ctx);

    NativeHashCore.sha256Update(ctx, bytes);

    // Finalize and get the hash
    Uint8List hash = Uint8List(32); // 256-bit hash
    NativeHashCore.sha256Final(ctx, hash);

    final end = DateTime.now();
    // Print the hash
    print((end.millisecondsSinceEpoch - start.millisecondsSinceEpoch));
    print('C');
    print(bytesToHex(hash));
  }
}
