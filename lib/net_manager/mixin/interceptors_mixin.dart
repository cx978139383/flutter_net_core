part of net_manager;

/// 处理Dio的所有Interceptor相关动作
///
/// 使用[addInterceptor] or [addInterceptors] 添加APP自定义的拦截器如：
/// - token 验证
/// - token 失效后的动作
/// - app 自定义的错误码处理
///
/// 可用于移除部分拦截器[removeInterceptor] or [removeInterceptorByType]
///
/// 可用于启用和关闭框架默认的拦截器
/// [enableDefaultInterceptors] or [disableDefaultInterceptors]
///
///
mixin InterceptorsMixin on _NetManager {

  /// 默认的拦截器
  final List<InterceptorsWrapper> _defaultInterceptors = [
    LogTraceInterceptor()
  ];

  /// 添加拦截器
  addInterceptor(InterceptorsWrapper interceptor) {
    _dio.interceptors.add(interceptor);
  }

  /// 批量添加拦截器
  addInterceptors(List<InterceptorsWrapper> interceptors) {
    for (var element in interceptors) {
      if (!_dio.interceptors.contains(element)) {
        _dio.interceptors.addAll(interceptors);
      }
    }
  }

  /// 移除一类拦截器
  removeInterceptorByType<T>() {
    _dio.interceptors.removeWhere((element) => element is T);
  }

  /// 移除指定的拦截器
  removeInterceptor(InterceptorsWrapper interceptor) {
    try {
      _dio.interceptors.remove(interceptor);
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  /// 失效默认的拦截器
  disableDefaultInterceptors() {
    for (var element in _defaultInterceptors) {
      try {
        _dio.interceptors.remove(element);
      } catch (e) {
        debugPrint('');
      }
    }
  }

  /// 启用默认的拦截器
  enableDefaultInterceptors() {
    for (var element in _defaultInterceptors) {
      if (!_dio.interceptors.contains(element)) {
        _dio.interceptors.add(element);
      }
    }
  }

}