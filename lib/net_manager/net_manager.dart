// ignore_for_file: constant_identifier_names, implementation_imports
library net_manager;

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/src/adapters/io_adapter.dart';

part '../transformer/transformer.dart';
part '../interceptors/error_interceptor.dart';
part '../interceptors/log_interceptor.dart';
part '../interceptors/retry_interceptor.dart';
part 'mixin/interceptors_mixin.dart';
part 'mixin/transformer_mixin.dart';
part 'mixin/rest_mixin.dart';
part 'mixin/proxy_mixin.dart';

enum Method { GET, POST, PUT, DELETE, HEAD, PATH, DOWNLOAD }

/// 网络请求管理器
///
/// 初始化Dio
///
/// 配置基础URL、注册错误拦截、证书校验等功能、设置APP自由的错误码
class NetManager
    with _NetManager, InterceptorsMixin, TransformerMixin, RestfulMixin {
  static final NetManager _instance = NetManager._();

  /// 单例模式
  factory NetManager() => _instance;

  NetManager._() {
    init();
  }

  @override
  init() {
    BaseOptions options = BaseOptions();

    _dio = Dio(options);

    _dio.interceptors.add(BaseErrorInterceptor());

    enableDefaultInterceptors();
  }

  /// 设置常用的全局option配置
  /// 包括：
  /// - 统一url
  /// - 连接超时时间
  /// - 发送超时时间
  /// - 响应超时时间
  ///
  /// BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数，所以具体请求的配置不同的时候，应该去具体请求中设置RequestOptions
  setGlobalOptions(Function(BaseOptions options) param) {
    BaseOptions options = _dio.options.copyWith();
    param(options);
    _dio.options = options;
  }

  /// 网络请求的核心部分
  /// - [path] 请求地址
  /// - [method] 请求方式 [Method]中定义的请求方式
  /// - [data] json格式的请求参数
  /// - [queryParameters] url形式的请求参数
  /// - [cancelToken] 用于取消当前请求
  /// - [options] 其他详细配置
  /// - [onSendProgress] [onReceiveProgress] 进度回调
  /// - [log] 当前请求是否开启日志输出，默认为false
  @override
  Future request(String path,
      {Method method = Method.GET,
      data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool log = false}) async {

    options ??= Options();

    /// 设置是否打印日志
    options.extra ??= {'log': log};
    options.method = method.name;

    Response response;
    try {
      response = await _dio.request(path,
          data: data,
          options: options,
          queryParameters: queryParameters,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress);
      return _transformer.transformResponse(response);
    } on DioError catch (e) {
      return _transformer.transformError(e);
    }
  }
}

abstract class _NetManager {

  late Dio _dio;

  @mustCallSuper
  init();

  Future request(String path,
      {Method method = Method.GET,
        data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        bool log = false});
}
