import 'package:flutter/material.dart';

class ChildCategory with ChangeNotifier{
  List<Map> childCategory = [];
  int childCategoryIndex = 0; // 子分类高亮索引
  String categoryId = "4";
  int page = 1;
  String noMoreText = "";

  setCategory(List<Map> list, String categoryId){
    page = 1;
    childCategoryIndex = 0;
    list ??= [];
    this.categoryId = categoryId;
    childCategory = [{'mallSubName':'全部'}];
    childCategory.addAll(list);
    notifyListeners();
  }

  // 改变子类索引 (高亮)
  changeChildCategoryIndex(index){
    page = 1;
    childCategoryIndex = index;
    notifyListeners();
  }

  // 翻页
  addPage(){
    page++;
  }

  get subCategoryId{
    if(childCategory == null || childCategory.length <= 0){
      return "";
    }
    return childCategory[childCategoryIndex]['mallSubId'] ?? "";
  }

  setNoMoreText(String noMoreText) => this.noMoreText = noMoreText;
}