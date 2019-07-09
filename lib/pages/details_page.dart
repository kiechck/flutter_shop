import 'package:flutter/material.dart';
import '../provide/details_info.dart';
import 'package:provide/provide.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/details_tabbar.dart';

class DetailsPage extends StatelessWidget {

  final String goodsId;

  const DetailsPage(this.goodsId,{Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("商品详情"),
      ),
      body: FutureBuilder(
        future: getGoodsInfo(context),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Text("加载中..........");
          }
          return Container(
            child: ListView(
              children: <Widget>[
                DetailsTopArea(),
                DetailsExplain(),
                DetailTabbar()
              ],
            ),
          );
        },
      ),
    );
  }

  Future getGoodsInfo(content) async{
    Provide.value<DetailsInfoProvide>(content).getGoodsInfo(goodsId);
    return "加载完成!";
  }
}