import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

// 商城获取数据请求 需要带上经纬度参数
const Map defaultFormData = {"lon": "115.02932", "lat": "35.76189"};

//获取首页内容
Future postRequest(String url,{Map formData}) async {
  Response response;
  Dio dio = Dio();
  try {
    print("开始调用接口获取数据,url=$url,完整url=${servicePath[url]},formData=$formData");
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    if(formData == null){
      response = await dio.post(servicePath[url]);
    }else{
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode != 200) {
      throw new Exception("调用接口出现异常,url=$url,formData=$formData");
    }
    print(response.data);
    return response.data;
  } catch (e) {
    return print("ERROR===========>$e");
  }
}
