import 'dart:io';

import 'package:flutter/material.dart';
import 'package:udp/udp.dart';

class CubeCore {
  String listenIp = "127.0.0.1";
  int listenPort = 12345;
  String wledIp = "192.168.0.187";
  int wledPort = 21324;
  var connection;
  bool isReady = false;

  static Future<CubeCore> getInstance() async {
    var con = await UDP.bind(Endpoint.any(port: const Port(12346)));
    print("Starting CubeCore");
    return CubeCore(con, true);
  }

  CubeCore(this.connection, this.isReady);

  Future<void> sendRange(RangeValues range) async {
    if (isReady) {
      int rangeStart = range.start.round();
      int rangeEnd = range.end.round();
      int rangeLen = rangeEnd - rangeStart;

      int ledIndexHigh = rangeStart ~/ 255;
      int ledIndexLow = rangeStart % 255;

      int padEnd = 900 - rangeEnd;

      //List<int> ledCmd = [4, 255, ledIndexHigh, ledIndexLow];
      List<int> ledCmd = [];
      for (var j = 0; j < rangeStart; j++) {
        ledCmd.addAll([0, 0, 0]);
      }
      for (var i = 0; i < rangeLen; i++) {
        ledCmd.addAll([255, 255, 255]);
      }
      for (var x = 0; x < padEnd; x++) {
        ledCmd.addAll([0, 0, 0]);
      }

      for (var k = 0; k < 4; k++) {
        int indexStart = k * 250;
        List<int> cmd = [4, 255, indexStart ~/ 255, indexStart % 255];
        print("K: " +
            k.toString() +
            "Index Start: " +
            indexStart.toString() +
            " CMD Base: " +
            cmd.toString() +
            "ledcmd Len: " +
            ledCmd.length.toString());
        cmd.addAll(ledCmd.sublist(indexStart, indexStart + 600));
        print(cmd);
        var dataLength = await connection.send(
            cmd,
            Endpoint.unicast(InternetAddress("192.168.0.187"),
                port: Port(21324)));
        await Future.delayed(const Duration(milliseconds: 10));
        print("Data Len: " + dataLength.toString());
      }
    }
  }
}




/*
import 'dart:convert';
import 'dart:io';

import 'package:udp/udp.dart';

main(List<String> arguments) async {
  print('Starting UDP test');

  // creates a UDP instance and binds it to the first available network
  // interface on port 65000.
  var connection = await UDP.bind(Endpoint.any(port: Port(65000)));

  // send a simple string to a InternetAddress endpoint.
  for (var i = 0; i < 1000; i++) {
    var dataLength = await connection.send('Hello World!'.codeUnits,
        Endpoint.unicast(InternetAddress("127.0.0.1"), port: Port(53477)));
  }

  // receiving\listening
  connection.asStream(timeout: Duration(seconds: 20)).listen((datagram) {
    var str = String.fromCharCodes(datagram!.data);
    stdout.write(str);
  });
  print("end of prog");
}
*/