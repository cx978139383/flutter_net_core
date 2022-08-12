part of net_manager;


/// 数据转换器
///
/// 完成数据解析和脱壳
/// 可以根据业务需求继承此类完成具体实现
abstract class ResponseTransformer<T> {
  T transformError(DioError error);
  T transformResponse(Response response);
}


/// 本框架默认的转换器
///
/// 默认数据格式:
/// - [code]: http 状态码
/// - [state]：success or fail
/// - [message]：状态描述信息
/// - [data]：响应体
/// - [extra]：其他额外信息
class DefaultErrorTransformer extends ResponseTransformer<Map> {

  @override
  Map transformError(DioError error) {
    return {
      'code': error.response?.statusCode,
      'state': 'fail',
      'message': error.error,
      'data': null,
      'extra': error.response?.extra
    };
  }

  @override
  Map transformResponse(Response response) {
    return {
      'code': response.statusCode,
      'state': 'success',
      'message': response.statusMessage,
      'data': response.data,
      'extra': response.extra
    };
  }
}