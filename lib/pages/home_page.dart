import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  int _page = 1;
  List<Map> _hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  GlobalKey<RefreshFooterState> footerKey = GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("百姓生活+"),
      ),
      body: FutureBuilder(
        future: postRequest("homePageContent",formData: defaultFormData),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            if("success" != data['message']){
              return Center(child: Text("加载出错,请联系管理员153xxxxxxxxx!"),);
            }
            data = data['data'];
            // 轮播图信息
            List<Map> swiper = (data['slides'] as List).cast();
            // 轮播图下方 方块导航
            List<Map> categoryList = (data['category'] as List).cast();
            // 广告横幅
            Map advertesPicture = data['advertesPicture'];
            // 店长电话信息
            Map shopInfo = data['shopInfo'];
            // 商城活动
            //      秒杀
            Map saoma = data['saoma'];
            //      积分商城
            Map integralMallPic = data['integralMallPic'];
            //      新会员送好礼
            Map newUser = data['newUser'];
            // 推荐商品
            List<Map> recommendList = (data['recommend'] as List).cast();
            // 楼层标题
            Map floor1Pic = data['floor1Pic'];
            Map floor2Pic = data['floor2Pic'];
            Map floor3Pic = data['floor3Pic'];
            // 楼层商品
            List<Map> floor1 = (data['floor1'] as List).cast();
            List<Map> floor2 = (data['floor2'] as List).cast();
            List<Map> floor3 = (data['floor3'] as List).cast();
            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: "",
                moreInfo: "加载中...",
                loadReadyText: "上拉加载",
              ),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiper,),
                  TopNavigator(navigatorList: categoryList,),
                  AdBanner(advertesPicture: advertesPicture["PICTURE_ADDRESS"]),
                  LeaderPhone(leaderImage: shopInfo["leaderImage"],leaderPhone: shopInfo["leaderPhone"],),
                  MallActivity(mallActivityList: [saoma,integralMallPic,newUser],),
                  Recommend(recommendList: recommendList,),
                  Floor(floorTitlePic: floor1Pic["PICTURE_ADDRESS"],floorGoodsList: floor1,),
                  Floor(floorTitlePic: floor2Pic["PICTURE_ADDRESS"],floorGoodsList: floor2,),
                  Floor(floorTitlePic: floor3Pic["PICTURE_ADDRESS"],floorGoodsList: floor3,),
                  _hotZone()
                ],
              ),
              loadMore: () async {
                Map formData = {"page":"$_page"};
                await postRequest("homePageBelowConten",formData:formData).then((responseData){
                  var data = json.decode(responseData);
                  if(data != null && "success" == data['message']){
                    List<Map> newHotGoodsList = (data['data'] as List).cast();
                    setState(() {
                      _hotGoodsList.addAll(newHotGoodsList); 
                      _page++;
                    });
                  }else{

                  }
                });
              },
            );
          }else{
            return Center(child: Image.network("https://loading.io/assets/img/landing/text-animation.gif"),);
          }
        },
      ),
    );
  }

  // 火爆专区标题
  Widget _hotTitle = Container(
    alignment: Alignment.center,
    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Text("火爆专区",style: TextStyle(color: Colors.red,)),
  );

  // 火爆专区商品流式布局
  Widget _hotGoodsWarp(){
    if(_hotGoodsList.isEmpty){
      return Text("加载中......");
    }
    List<Widget> _hotGoodsWidgetList = _hotGoodsList.map((item){
      return InkWell(
        child: Container(
          margin: EdgeInsets.only(bottom: 5),
          width: ScreenUtil.screenWidthDp/2-10,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Image.network(
                item['image']
              ),
              SizedBox(height: 10,),
              Text(
                item['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.pink
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "￥${item['mallPrice']}",
                  ),
                  Text(
                    "￥${item['price']}",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.black26,
                    ),

                  )
                ],
              )
            ],
          ),
        ),
      );
    }).toList();

    return Wrap(
      spacing: 2,
      children: _hotGoodsWidgetList,
    );
  }

  // 火爆专区
  Widget _hotZone(){
    return Container(
      child: Column(
        children: <Widget>[
          _hotTitle,
          _hotGoodsWarp()
        ],
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

// 轮播图下方 方块导航
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
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.only(top: 5),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告图片组件
class AdBanner extends StatelessWidget {
  final String advertesPicture;
  const AdBanner({Key key, this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

// 拨打店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Image.network(leaderImage),
        onTap: () async {
          String url = "tel:$leaderPhone";
          if(await canLaunch(url)){
            launch(url);
          }else{
            throw "url不合法,url=$url";
          }
        }
      ),
    );
  }

}

// 商城活动
class MallActivity extends StatelessWidget {
  final List<Map> mallActivityList;
  const MallActivity({Key key, this.mallActivityList}) : super(key: key);

  Widget _rowItemUI(BuildContext context, item){
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.network(
            item["PICTURE_ADDRESS"],
            fit: BoxFit.fill,
            height: ScreenUtil().setHeight(330),
            width: ScreenUtil.screenWidthDp/3,
          ),
        ],
      ),
      onTap: (){
        print("点击了TopNavigator");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: mallActivityList.map((item){
          return _rowItemUI(context,item);
        }).toList(),
      )
    );
  }
}

// 推荐商品
class Recommend extends StatelessWidget {
  final List<Map> recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  Widget _titleWidget(){
    return Container(
      height: ScreenUtil().setHeight(70),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12)),
        color: Colors.white
      ),
      child: Text("商品推荐",style: TextStyle(color: Colors.pink[200]),),
    );
  }

  Widget _recommentItem(index){
    return InkWell(
      onTap: (){},
      child: Container(
        width: ScreenUtil.screenWidthDp/3,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]["image"],fit: BoxFit.fill,),
            SizedBox(height: 10,),
            Text("￥${recommendList[index]['mallPrice']}",),
            Text(
              "￥${recommendList[index]['price']}",
              style: TextStyle(
                color: Colors.black26,
                fontSize: 10,
                decoration: TextDecoration.lineThrough
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _recommentList(BuildContext context){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _recommentItem(index);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommentList(context)
        ],
      ),
    );
  }
}

// 楼层
class Floor extends StatelessWidget {
  final floorTitlePic;
  final floorGoodsList;
  const Floor({Key key, this.floorTitlePic, this.floorGoodsList}) : super(key: key);

  // 楼层标题
  Widget _titleWidget(){
    return InkWell(
      child: Image.network(floorTitlePic,width: ScreenUtil.screenWidthDp,),
    );
  }

  // 楼层商品单项
  Widget _goodsItemWidget(item,{width,height}){
    height = height != null ? ScreenUtil().setHeight(height) : height;
    width = width ?? (ScreenUtil.screenWidthDp/2);
    return InkWell(
      child: Image.network(item["image"],width: width,height: height,),
    );
  }

  // 楼层商品列表
  Widget _goodsListWidget(){
    return Container(
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              _goodsItemWidget(floorGoodsList[0],height: 400.0),
              _goodsItemWidget(floorGoodsList[3],height: 200.0),
            ],
          ),
          Column(
            children: <Widget>[
              _goodsItemWidget(floorGoodsList[1],height: 200.0),
              _goodsItemWidget(floorGoodsList[2],height: 200.0),
              _goodsItemWidget(floorGoodsList[4],height: 200.0),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _goodsListWidget()
        ],
      ),
    );
  }
}

// 热门商品

