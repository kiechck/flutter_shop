import 'package:flutter/material.dart';
import 'package:flutter_shop/model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo;

  bool isLeft = true;
  bool isRight = false;

  // tabbar的切换方法
  changeLeftAndRight(String changeState){
    if(changeState == "left"){
      isLeft = true;
      isRight = false;
    }else{
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  getGoodsInfo(String goodsId) async{
    var formData = {'goodId':goodsId};
    await postRequest("getGoodsDetailById",formData: formData).then((val){
      var responseData = json.decode(val);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
}