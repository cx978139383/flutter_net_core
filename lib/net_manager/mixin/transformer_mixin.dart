part of net_manager;

/// 数据转换器设置功能
mixin TransformerMixin on _NetManager {

  /// 默认格式转换器
  ResponseTransformer _transformer = DefaultErrorTransformer();

  /// 设置数据转换器
  setResponseTransformer(ResponseTransformer value) {
    _transformer = value;
  }

}