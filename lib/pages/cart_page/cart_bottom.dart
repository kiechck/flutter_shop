import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartBottom extends StatelessWidget {
  const CartBottom({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Provide<CartProvide>(
        builder: (context,child,val){
          return Row(
            children: <Widget>[
              _selectAllBtn(context),
              _allPriceArea(context),
              _goBtn(context)
            ],
          );
        },
      )
    );
  }

  Widget _selectAllBtn(context){
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: Provide.value<CartProvide>(context).isAllCheck,
            activeColor: Colors.pink,
            onChanged: (val){
              Provide.value<CartProvide>(context).changeAllCheckState(val);
            },
          ),
          Text("全选")
        ],
      ),
    );
  }

  Widget _allPriceArea(context){
    double totalPrice = Provide.value<CartProvide>(context).totalPrice;
    return Container(
      width: ScreenUtil().setWidth(430),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(230),
                child: Text(
                  "合计:",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36)
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(200),
                child: Text(
                  "$totalPrice",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    color: Colors.red
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(430),
            alignment: Alignment.centerRight,
            child: Text(
              "满10元免配送费,预购免配送费",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(22),
                color: Colors.black38
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _goBtn(context){
    int totalGoodsCount = Provide.value<CartProvide>(context).totalGoodsCount;
    return Container(
      width: ScreenUtil().setWidth(160),
      height: ScreenUtil().setHeight(80),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: (){},
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(3)
          ),
          child: Text(
            "结算($totalGoodsCount)",
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}