import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartCount extends StatelessWidget {
  var item;
  CartCount(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.black26)
      ),
      child: Row(
        children: <Widget>[
          _reduceBtn(context),
          _countArea(),
          _addBtn(context),
        ],
      ),
    );
  }

  Widget _reduceBtn(context){
    return InkWell(
      onTap: (){
        Provide.value<CartProvide>(context).updateGoodsCount(item, "reduce");
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: item.count > 1 ? Colors.white : Colors.black12,
          border: Border(
            right: BorderSide(color: Colors.black26,width: 1)
          )
        ),
        child: Text("-"),
      ),
    );
  }

  Widget _addBtn(context){
    return InkWell(
      onTap: (){
        Provide.value<CartProvide>(context).updateGoodsCount(item, "add");
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(color: Colors.black26,width: 1)
          )
        ),
        child: Text("+"),
      ),
    );
  }

  Widget _countArea(){
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      child: Text("${item.count}"),
    );
  }
}