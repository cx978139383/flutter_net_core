part of net_manager;

mixin RestfulMixin on _NetManager {

  /// get请求
  Future get(
    String path, {
    params,
    CancelToken? cancelToken,
    Options? options,
    bool log = false,
  }) async {
    return request(path,
        method: Method.GET,
        queryParameters: params,
        cancelToken: cancelToken,
        options: options,
        log: log);
  }

  /// post请求
  Future post(
      String path, {
        data,
        params,
        CancelToken? cancelToken,
        Options? options,
        bool log = false,
      }) async {
    return request(path,
        method: Method.POST,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken,
        options: options,
        log: log);
  }

  /// put请求
  Future put(
      String path, {
        data,
        params,
        CancelToken? cancelToken,
        Options? options,
        bool log = false,
      }) async {
    return request(path,
        method: Method.PUT,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken,
        options: options,
        log: log);
  }

  /// put请求
  Future delete(
      String path, {
        data,
        params,
        CancelToken? cancelToken,
        Options? options,
        bool log = false,
      }) async {
    return request(path,
        method: Method.DELETE,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken,
        options: options,
        log: log);
  }

  /// post form请求
  Future postForm(
      String path, {
        params,
        CancelToken? cancelToken,
        Options? options,
        bool log = false,
      }) async {
    return request(path,
        method: Method.POST,
        data: FormData.fromMap(params),
        cancelToken: cancelToken,
        options: options,
        log: log);
  }
}
