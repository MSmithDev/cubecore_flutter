class CubeCore {
  String? listenIp = "127.0.0.1";
  int? listenPort = 12345;
  String wledIp;
  int wledPort;

  CubeCore(this.wledIp, this.wledPort, {this.listenIp, this.listenPort}) {
    print("CubeCore Init\nWled: ${wledIp}:${wledPort}");
  }
}
