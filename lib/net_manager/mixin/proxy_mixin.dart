part of net_manager;

mixin ProxyMixin on _NetManager {
  late HttpClient client;

  @override
  init() {
    super.init();
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      this.client = client;
      return null;
    };
  }

  /// 设置代理地址
  setProxy({required String ip, required String port}) {
    // config the http client
    client.findProxy = (uri) {
      //proxy all request to ip:port
      return "$ip:$port";
    };
  }

  /// 设置证书验证
  // ignore: non_constant_identifier_names
  setCertificateVerification(String PEM) {
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      if (cert.pem == PEM) {
        // Verify the certificate
        return true;
      }
      return false;
    };
  }
}
