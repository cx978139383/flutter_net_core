part of net_manager;

/// 请求日志打印拦截器
///
/// #### 打印请求相关信息：
/// - 请求地址
/// - 请求头
/// - 请求方法
/// - 请求参数
///
/// #### 打印响应相关信息：
/// - 被响应的请求地址
/// - 响应头
/// - 返参
class LogTraceInterceptor extends InterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['log'] == true) {
      debugPrint('➡️➡️➡️');
      debugPrint("请求url：${options.uri.toString()}");
      debugPrint('➡️➡️➡️');
      debugPrint("请求类型：${options.method}");
      debugPrint('➡️➡️➡️');
      debugPrint('请求头: ' + options.headers.toString());
      debugPrint('➡️➡️➡️');
      if (options.data != null) {
        debugPrint('data: ' + options.data.toString());
      } else {
        debugPrint('queryParameters： ' + options.queryParameters.toString());
      }
      debugPrint('➡️➡️➡️');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.extra['log'] == true) {
      debugPrint("被响应url：${response.requestOptions.uri.toString()}");
      debugPrint('➡️➡️➡️');
      debugPrint("响应头：\n${response.headers.toString()}");
      debugPrint('➡️➡️➡️');
      debugPrint('返回值: \n${response.toString()}');
      debugPrint('➡️➡️➡️');
    }
    super.onResponse(response, handler);
  }

}
