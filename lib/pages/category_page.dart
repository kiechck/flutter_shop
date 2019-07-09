import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:provide/provide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provide/child_category.dart';

import '../model/category.dart';
import '../model/categoryGoodsList.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品分类"),
      ),
      body: Row(
        children: <Widget>[
          LeftCategoryNav(),
          Column(
            children: <Widget>[
              RightCategoryNav(),
              CategoryGoodsList()
            ],
          ),
        ],
      ),
    );
  }
}

class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List<CategoryModel> list = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCategory();
    _getGoodsList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black12,width: 1))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index){
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index){
    return InkWell(
      onTap: (){
        List<Map> childCategory = list[index].subCategory;
        Provide.value<ChildCategory>(context).setCategory(childCategory,list[index].mallCategoryId);
        setState(() {
          currentIndex = index;
        });
        _getGoodsList(categoryId: list[index].mallCategoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(90),
        padding: EdgeInsets.only(left: 14,top: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12,width: 1)),
          color: currentIndex==index?Colors.black12:Colors.white
        ),
        child: Text(list[index].mallCategoryName),
      ),
    );
  }

  void _getCategory() async{
    postRequest("getCategory",).then((response){
      var data = json.decode(response);
      CategoryModelList categoryModelList = CategoryModelList.fromJson(data);
      setState(() {
        list = categoryModelList.categoryList;
      });
      Provide.value<ChildCategory>(context).setCategory(list[0].subCategory,list[0].mallCategoryId);
    });
  }

  void _getGoodsList({String categoryId, String categorySubId}) async{
    var data = {
      'categoryId': categoryId ?? '4',
      'categorySubId': categorySubId ?? '',
      'page': 1
    };
    postRequest("getMallGoods",formData: data).then((val){
      print(val);
      var response = json.decode(val);
      CategoryGoodsListResponse categoryGoodsListResponse= CategoryGoodsListResponse.fromJson(response);
      Provide.value<CategoryGoodsListProvide>(context).setCategoryGoodsList(categoryGoodsListResponse.data);
    });
  }
}


class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context,child,childCategory){
        return Container(
          width: ScreenUtil().setWidth(560),
          height: ScreenUtil().setHeight(70),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12,width: 1)),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategory.length,
            itemBuilder: (context,index){
              return _rightCategoryInkWell(index,childCategory);
            },
          )
        );
      },
    );
  }

  Widget _rightCategoryInkWell(int index, childCategory){
    bool isClick = index == childCategory.childCategoryIndex;
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(70),
        padding: EdgeInsets.only(left: 14,top: 10),
        child: Text(
          childCategory.childCategory[index]['mallSubName'],
          style: TextStyle(
            color: isClick ? Colors.pink : Colors.black
          ),
        ),
      ),
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildCategoryIndex(index);
        _getGoodsList(childCategory.childCategory[index]['mallSubId']);
      },
    );
  }

  void _getGoodsList(String categorySubId) {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId ?? '0',
      'page': 1
    };
    postRequest("getMallGoods",formData: data).then((val){
      print(val);
      var response = json.decode(val);
      CategoryGoodsListResponse categoryGoodsListResponse= CategoryGoodsListResponse.fromJson(response);
      Provide.value<CategoryGoodsListProvide>(context).setCategoryGoodsList(categoryGoodsListResponse.data);
    });
  }
}

// 分类商品列表
class CategoryGoodsList extends StatefulWidget {
  CategoryGoodsList({Key key}) : super(key: key);

  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
        if(data.goodsList == null || data.goodsList.length <= 0){
          return Text("暂无数据");
        }
        return Expanded(
          child: Container(
            width: ScreenUtil().setWidth(570),
            child: EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                moreInfo: "",
                loadReadyText: "释放加载",
                // loadedText: "上拉",
                loadingText: "加载中...",
                loadText: "上拉加载",
              ),
              child: ListView.builder(
                itemCount: data.goodsList.length,
                itemBuilder: (context,index){
                  return _listItemWidget(data.goodsList[index]);
                },
              ),
              loadMore: (){
                print("加载中...");
                Provide.value<ChildCategory>(context).addPage();
                _getMoreGoodsList();
              },
            )
            
          ),
        );
      },
    );
    
  }

  void _getMoreGoodsList() {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subCategoryId,
      'page': Provide.value<ChildCategory>(context).page
    };
    postRequest("getMallGoods",formData: data).then((val){
      print(val);
      var response = json.decode(val);
      CategoryGoodsListResponse categoryGoodsListResponse= CategoryGoodsListResponse.fromJson(response);
      if(categoryGoodsListResponse.data == null || categoryGoodsListResponse.data.length <= 0){

        Fluttertoast.showToast(
          msg: "你触碰到我的底线了",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
        );

        Provide.value<ChildCategory>(context).setNoMoreText("没有更多");
      }else{
        Provide.value<ChildCategory>(context).setNoMoreText("加载完毕");
      }
      Provide.value<CategoryGoodsListProvide>(context).addMoreCategoryGoodsList(categoryGoodsListResponse.data);
    });
  }

  Widget _goodsImage(item){
    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setHeight(200),
      child: Image.network(item.image),
    );
  }

  Widget _goodsName(item){
    return Container(
      width: ScreenUtil().setWidth(370),
      padding: EdgeInsets.all(10),
      child: Text(
        item.goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28),
        ),
      ),
    );
  }

  Widget _goodsPrice(item){
    return Container(
      width: ScreenUtil().setWidth(370),
      padding: EdgeInsets.only(left: 10,top: 10),
      child: Row(
        children: <Widget>[
          Text(
            "价格: ￥${item.presentPrice}",
            style: TextStyle(
              color: Colors.pink,
              fontSize: ScreenUtil().setSp(30)
            ),
          ),
          Text(
            "￥${item.oriPrice}",
            style: TextStyle(
              color: Colors.black26,
              decoration: TextDecoration.lineThrough
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItemWidget(item){
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top:5,bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(item),
            Column(
              children: <Widget>[
                _goodsName(item),
                _goodsPrice(item),
              ],
            )
          ],
        ),
      ),
    );
  }
}













