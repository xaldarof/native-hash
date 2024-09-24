import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:native_hash/native_hash.dart';

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
                          '/data/data/com.example.native_hash_example/app_flutter/RustRover-2024.1.8.exe')
                      .readAsBytesSync();
                  // _testNativeAes(bytes);

                  // _testNativeSha256(bytes);
                  // _testSha256(bytes);
                  _testNativeMD5(bytes);
                  _testMD5(bytes);
                  // _testDart(bytes);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  _testSh1(Uint8List bytes) {
    NativeHashCore.sha1(bytes);
  }

  _testMd2(Uint8List bytes) {
    NativeHashCore.md2(bytes);
  }

  _testRot13() {
    NativeHashCore.rot13("message");
  }

  _testNativeSha256(Uint8List bytes) {
    final start = DateTime.now().millisecondsSinceEpoch;
    final res = NativeHashCore.sha256(bytes);
    final end = DateTime.now().millisecondsSinceEpoch;
    print('time ${end - start}ms');
    print('sha256 : ${bytesToHex(res)}');
  }

  _testSha256(Uint8List bytes) {
    final start = DateTime.now().millisecondsSinceEpoch;
    final res = sha256.convert(bytes);
    final end = DateTime.now().millisecondsSinceEpoch;
    print('time ${end - start}ms');
    print('sha256 dart : ${bytesToHex(Uint8List.fromList(res.bytes))}');
  }

  _testMD5(Uint8List bytes) {
    final start = DateTime.now().millisecondsSinceEpoch;
    final res = md5.convert(bytes);
    final end = DateTime.now().millisecondsSinceEpoch;
    print('time ${end - start}ms');
    print('md5 dart : ${bytesToHex(Uint8List.fromList(res.bytes))}');
  }

  _testNativeMD5(Uint8List bytes) {
    final start = DateTime.now().millisecondsSinceEpoch;
    final res = NativeHashCore.md5(bytes);
    final end = DateTime.now().millisecondsSinceEpoch;
    print('time ${end - start}ms');

    print('md5 : ${bytesToHex(res)}');
  }
}
