import 'dart:io';

import 'package:native_hash/native_hash.dart';

void main() {
  final bytes = File(
          'C:/Users/User/AndroidStudioProjects/native_hash/example/RustRover-2024.1.8.exe')
      .readAsBytesSync();

  final start = DateTime.now();
  final res = NativeHashCore.sha256(bytes);
  final end = DateTime.now();

  print('Millis');
}
