import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier{
  String cartString = "";
  List<CartInfoModel> cartList = [];
  double totalPrice = 0;
  int totalGoodsCount = 0;
  bool isAllCheck = true;

  save(goodsId, goodsName, count, price, images) async{
    SharedPreferences s = await SharedPreferences.getInstance();
    cartString = s.getString("cartInfo");
    var temp = cartString == null ? [] : json.decode(cartString);
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    var index = 0;
    totalPrice = 0;
    totalGoodsCount = 0;
    tempList = tempList.map((item){
      if(item['goodsId'] == goodsId){
        item['count'] += count;
        cartList[index].count += count;
        isHave = true;
      }
      if(item['isCheck']){
        totalPrice += item['count']*item['price'];
        totalGoodsCount += item['count'];
      }
      return item;
    }).toList();

    if(!isHave){
      Map<String, dynamic> newGoods = {
        "goodsId": goodsId, 
        "goodsName": goodsName, 
        "count": count, 
        "price": price, 
        "images": images,
        "isCheck": true,
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));

      totalPrice += count*price;
      totalGoodsCount += count;
    }

    cartString = json.encode(tempList).toString();
    print(cartString);
    s.setString("cartInfo", cartString);

    notifyListeners();
  }

  remove() async{
    SharedPreferences s = await SharedPreferences.getInstance();
    s.remove("cartInfo");
    cartList.clear();
    print("清空完成");
    notifyListeners();
  }

  getCartInfo() async{
    SharedPreferences s = await SharedPreferences.getInstance();
    cartString = s.get("cartInfo");
    cartList.clear();
    if(cartString != null && cartString.isNotEmpty){
      List<Map> tempList = (json.decode(cartString) as List).cast();
      totalPrice = 0;
      totalGoodsCount = 0;
      isAllCheck = true;
      tempList.forEach((item){
        if(item['isCheck']){
          totalPrice += (item['count'] * item['price']);
          totalGoodsCount += item['count'];
        }else{
          isAllCheck = false;
        }
        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  deleteOneGoods(String goodsId) async{
    SharedPreferences s = await SharedPreferences.getInstance();
    if(cartString != null && cartString.isNotEmpty){
      List<Map> tempList = (json.decode(cartString) as List).cast();
      int tempIndex = 0;
      int delIndex = 0;
      tempList.forEach((item){
        if(item['goodsId'] == goodsId){
          delIndex = tempIndex;
        }
        tempIndex++;
      });
      tempList.removeAt(delIndex);

      cartString = json.encode(tempList).toString();
      s.setString("cartInfo", cartString);
      getCartInfo();
    }
  }

  changeCheckState(CartInfoModel model) async{
    SharedPreferences s = await SharedPreferences.getInstance();
    cartString = s.getString("cartInfo");
    List<Map> tempList = (json.decode(cartString) as List).cast();
    int changeIndex = 0;
    tempList.forEach((item){
      if(model.goodsId == item['goodsId']){
        changeIndex = tempList.indexOf(item);
      }
    });
    tempList[changeIndex] = model.toJson();
    cartString = json.encode(tempList).toString();
    s.setString("cartInfo", cartString);
    await getCartInfo();
  }

  changeAllCheckState(bool isCheck) async{
    SharedPreferences s = await SharedPreferences.getInstance();
    cartString = s.getString("cartInfo");
    List<Map> tempList = (json.decode(cartString) as List).cast();
    tempList.map((val){
      val['isCheck'] = isCheck;
      return val;
    }).toList();
    cartString = json.encode(tempList).toString();
    s.setString("cartInfo", cartString);
    await getCartInfo();
  }

  updateGoodsCount(CartInfoModel model, String operation) async{
    SharedPreferences s = await SharedPreferences.getInstance();
    cartString = s.getString("cartInfo");
    List<Map> tempList = (json.decode(cartString) as List).cast();
    tempList.map((val){
      if(model.goodsId == val['goodsId']){
        if(operation == "add"){
          val['count']++;
        }else if(val['count'] > 1){
          val['count']--;
        }
      }
      return val;
    }).toList();
    cartString = json.encode(tempList).toString();
    s.setString("cartInfo", cartString);
    await getCartInfo();
  }

}