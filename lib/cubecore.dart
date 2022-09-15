class CubeCore {
  String? listenIp = "127.0.0.1";
  int? listenPort = 12345;
  String wledIp;
  int wledPort;

  CubeCore(this.wledIp, this.wledPort, {this.listenIp, this.listenPort}) {
    print("CubeCore Init\nWled: ${wledIp}:${wledPort}");
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