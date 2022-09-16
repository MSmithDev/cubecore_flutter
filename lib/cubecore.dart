import 'dart:io';

import 'package:flutter/material.dart';
import 'package:udp/udp.dart';

class CubeCore {
  String listenIp = "127.0.0.1";
  int listenPort = 12345;
  String wledIp = "192.168.0.187";
  int wledPort = 21324;
  int ledBytesPerPacket = 50 * 3;
  int NumLeds;
  var connection;
  bool isReady = false;

  static Future<CubeCore> getInstance(int leds) async {
    var con = await UDP.bind(Endpoint.any(port: const Port(12349)));
    print("Starting CubeCore");
    return CubeCore(leds, connection: con, isReady: true);
  }

  CubeCore(this.NumLeds, {this.connection, required this.isReady});

  Future<void> sendCmdPackets(List<int> command) async {
    if (isReady) {
      print("Sending Packets");
      List<int> mode = [4, 255];
      int numPackets = command.length ~/ ledBytesPerPacket;

      for (var i = 0; i <= numPackets - 1; i++) {
        int index = ledBytesPerPacket * i;
        int indexHigh = index ~/ 255;
        int indexLow = index % 255;

        print("Index: $index IndexHigh: $indexHigh Index Low: $indexLow");

        List<int> packet = []; //Empty Packet
        packet.addAll(mode); //Add Mode bytes
        packet.add(indexHigh); //Add Index High byte
        packet.add(indexLow); //Add Index Low byte
        packet.addAll(command.sublist(
            index, index + ledBytesPerPacket)); //Add partial led data

        var dataLength = await connection.send(packet,
            Endpoint.unicast(InternetAddress("127.0.0.1"), port: Port(57624)));
        await Future.delayed(const Duration(milliseconds: 10));

        print("Packet #: " + i.toString());
        print(packet);
      }
    } else {
      print("Connection not ready. (sendCmdPackets)");
    }
  }

  Future<void> sendRange(RangeValues range) async {
    if (isReady) {
      int rangeStart = range.start.round();
      int rangeEnd = range.end.round();
      //Fill All Black
      List<int> ledCmd = List<int>.filled(NumLeds * 3, 0);
      //Fill Selected
      ledCmd.fillRange(rangeStart * 3, rangeEnd * 3, 255);
      sendCmdPackets(ledCmd);
    }
  }
}
