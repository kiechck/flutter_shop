class CategoryModel{
  String mallCategoryId;  // 类别ID
  String mallCategoryName;  //类别名称
  List<Map> subCategory; // 子类别
  var comments; // 未知类型
  String image; // 类别图片

  CategoryModel({this.mallCategoryId, this.mallCategoryName, this.subCategory, this.comments, this.image});

  factory CategoryModel.fromMap(Map data){
    return CategoryModel(
      mallCategoryId : data['mallCategoryId'],
      mallCategoryName : data['mallCategoryName'],
      subCategory : (data['bxMallSubDto'] as List).cast(),
      comments : data['comments'],
      image : data['image'],
    );
  }
}

class CategoryModelList{
  List<CategoryModel> categoryList;
  CategoryModelList(this.categoryList);

  factory CategoryModelList.fromJson(data){
    List<Map> mapList = (data['data'] as List).cast();
    return CategoryModelList(
      mapList.map((mapData){
        return CategoryModel.fromMap(mapData);
      }).toList()
    );
  }
}