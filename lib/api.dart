class ApiConfig {
  static createTargetUri(String host,{required String path}){
    return Uri(
      scheme: "http",
      host: host,
      port: 6789,
      path: path,
    );
  }
}