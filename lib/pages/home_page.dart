import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("百姓生活+"),
      ),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            // 轮播图信息
            List<Map> swiper = (data['data']['slides'] as List).cast();
            // 轮播图下方 方块导航
            List<Map> categoryList = (data['data']['category'] as List).cast();
            return Column(
              children: <Widget>[
                SwiperDiy(swiperDataList: swiper,),
                TopNavigator(navigatorList: categoryList,),
              ],
            );
          }else{
            return Center(child: Text("加载中........"),);
          }
        },
      ),
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context, int index){
          return Image.network(swiperDataList[index]["image"], fit: BoxFit.fill,);
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}


class TopNavigator extends StatelessWidget {
  final List navigatorList;
  const TopNavigator({Key key, this.navigatorList}) : super(key: key);
  
  Widget _gridViewItemUI(BuildContext context, item){
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.network(item["image"],fit: BoxFit.cover,width: ScreenUtil().setWidth(95),),
          Text(item["mallCategoryName"])
        ],
      ),
      onTap: (){
        print("点击了TopNavigator");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(navigatorList.length > 10){
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.only(top: 5),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}