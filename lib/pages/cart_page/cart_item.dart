import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/cartInfo.dart';
import './cart_count.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';

class CartItem extends StatelessWidget { 
  final CartInfoModel item;
  const CartItem(this.item,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black26,width: 1)
        )
      ),
      child: Row(
        children: <Widget>[
          _cartCheckButton(context,item),
          _cartImage(),
          _cartGoodsName(),
          _cartPrice(context)
        ],
      ),
    );
  }

  Widget _cartCheckButton(BuildContext context,CartInfoModel item){
    return Container(
      child: Checkbox(
        onChanged: (val){
          item.isCheck = val;
          Provide.value<CartProvide>(context).changeCheckState(item);
        },
        value: item.isCheck,
        activeColor: Colors.pink,
      ),
    );
  }

  Widget _cartImage(){
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.black26)
      ),
      child: Image.network(item.images),
    );
  }

  Widget _cartGoodsName(){
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(item.goodsName),
          CartCount(item)
        ],
      ),
    );
  }

  Widget _cartPrice(context){
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text("￥${item.price}"),
          Container(
            child: InkWell(
              onTap: (){
                Provide.value<CartProvide>(context).deleteOneGoods(item.goodsId);
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.black26,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}