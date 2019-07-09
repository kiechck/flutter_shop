import 'package:flutter/material.dart';
import 'package:flutter_shop/model/categoryGoodsList.dart';

class CategoryGoodsListProvide with ChangeNotifier{
  List<CategoryGoodsListData> goodsList = [];

  setCategoryGoodsList(List<CategoryGoodsListData> list){
    list ??= [];
    goodsList = list;
    notifyListeners();
  }

  // 翻页时增加商品列表
  addMoreCategoryGoodsList(List<CategoryGoodsListData> list){
    list ??= [];
    goodsList.addAll(list);
    notifyListeners();
  }
}