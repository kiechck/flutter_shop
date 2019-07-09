import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/details_info.dart';


class DetailsTopArea extends StatelessWidget {
  const DetailsTopArea({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (BuildContext context, Widget child, value){
        if(Provide.value<DetailsInfoProvide>(context).goodsInfo == null){
          return Text("加载中....");
        }
        var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
        if(goodsInfo == null){
          return Text("加载中....");
        }
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _goodsImage(goodsInfo.image1),
              _goodsName(goodsInfo.goodsName),
              _goodsNum(goodsInfo.goodsSerialNumber)
            ],
          ),
        );
      }
    );
  }

  // 商品图片
  Widget _goodsImage(url){
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740),
    );
  }

  // 商品名称
  Widget _goodsName(name){
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left:10),
      child: Text(
        name,
        style:TextStyle(
          fontSize: ScreenUtil().setSp(30)
        )
      ),
    );
  }

  // 商品编号
  Widget _goodsNum(num){
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left:10),
      margin: EdgeInsets.only(top: 8),
      child: Text(
        "编号:$num",
        style: TextStyle(
          color: Colors.black12
        ),
      ),
    );
  }
}

