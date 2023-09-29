import 'dart:io';

String jsonData(String fileName) =>
    File('test/src/fixtures/$fileName').readAsStringSync();
