import 'dart:ffi';
import 'dart:io';
import 'dart:math';
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
                  final bytes =
                      Uint8List.fromList('HellooooHelloooo'.codeUnits);
                  // _testNativeAes(bytes);

                  _testNativeSha256(bytes);
                  _testNativeMD5(bytes);
                  // _testDart(bytes);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _testNativeSha256(Uint8List bytes) {
    final res = NativeHashCore.sha256(bytes);

    print('sha256 : ${bytesToHex(res)}');
  }

  _testNativeMD5(Uint8List bytes) {
    final res = NativeHashCore.md5(bytes);

    print('md5 : ${bytesToHex(res)}');
  }
}
