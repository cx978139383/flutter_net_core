part of net_manager;

class RetryOnConnectionChangeInterceptor extends InterceptorsWrapper {
  late _ConnectChangeRetryer _changeRetryer;

  RetryOnConnectionChangeInterceptor() {
    _changeRetryer = _ConnectChangeRetryer();
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (_canRetry(err)) {
      try {
        _changeRetryer.dio = _getRetryDio();
        _changeRetryer.scheduleRequestRetry(err.requestOptions).then((value) {
          handler.resolve(value);
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    //super.onError(err, handler);
  }

  /// 网络变化到导致的异常
  _canRetry(DioError error) {
    return error.type == DioErrorType.other &&
        error.error != null &&
        error.error is SocketException;
  }

  _getRetryDio() {
    Dio dio = Dio();
    dio.options = NetManager()._dio.options.copyWith();
    dio.interceptors.addAll(NetManager()._dio.interceptors);
    dio.interceptors.removeWhere(
        (element) => element is RetryOnConnectionChangeInterceptor);

    return dio;
  }
}

class _ConnectChangeRetryer {

  late Dio dio;
  StreamSubscription? subscription;

  Future scheduleRequestRetry(RequestOptions requestOptions) async {
    final completer = Completer<Response>();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      /// 有新的网络连接上来
      if (connectivityResult != ConnectivityResult.none) {
        subscription?.cancel();
        completer.complete(retry(requestOptions));
      }
    });
    return completer.future;
  }

  Future<Response> retry(RequestOptions requestOptions) async {
    Response response = await dio.request(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        onReceiveProgress: requestOptions.onReceiveProgress,
        onSendProgress: requestOptions.onSendProgress,
        options: Options(
          method: requestOptions.method,
          sendTimeout: requestOptions.sendTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
          extra: requestOptions.extra,
          headers: requestOptions.headers,
          responseType: requestOptions.responseType,
          contentType: requestOptions.contentType,
          validateStatus: requestOptions.validateStatus,
          receiveDataWhenStatusError:
          requestOptions.receiveDataWhenStatusError,
          followRedirects: requestOptions.followRedirects,
          maxRedirects: requestOptions.maxRedirects,
          requestEncoder: requestOptions.requestEncoder,
          responseDecoder: requestOptions.responseDecoder,
          listFormat: requestOptions.listFormat,
        ));
    dio.close();
    return response;
  }
}
