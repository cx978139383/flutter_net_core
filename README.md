## 使用方式
1. APP启动时初始化[NetManager]
```dart
void main() {
  
  //初始化网络框架 && 全局配置
  NetManager()
    ..setGlobalOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com/',
        sendTimeout: 5 * 1000,
        receiveTimeout: 5 * 1000,
        connectTimeout: 5 * 1000)
    ..setResponseTransformer(CustomTransformer())
    ..addInterceptor(CustomInterceptor());
  
  runApp(const MyApp());
}
```
2. 根据业务逻辑定义自己的拦截器和数据解析器
```dart
///可以写自己APP自己的业务 如 token失效去登录等
class CustomInterceptor extends InterceptorsWrapper {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    debugPrint('自定义拦截器生效');

    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

}
```
3. 封装自己的API
```dart
class MockApi {

  Future getUserName() async {
    return await NetManager().request(path: '/posts/1', log: true);
  }
  
}
```


## 其他默认配置的启用和关闭方式请看详细文档

