part of net_manager;

/// 常规错误处理
class BaseErrorInterceptor extends InterceptorsWrapper {

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _handleSpecialError(err);
    /// 使用当前error结束当前请求，进入异常状态
    return super.onError(err, handler);
  }

  /// 处理超时等错误，这一类错误没有[error.response], statusCode统一设置为 -1 statusMessage设置为error.error
  _handleSpecialError(DioError error) {
    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.sendTimeout ||
        error.type == DioErrorType.cancel) {
      error.response = Response(
          requestOptions: error.requestOptions,
          statusCode: -1,
          statusMessage: error.error);
    }
  }
}
