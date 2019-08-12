import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cartInfo.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Text("正在加载....");
          }
          List<CartInfoModel> cartList = Provide.value<CartProvide>(context).cartList;
          if(cartList == null || cartList.isEmpty){
            return Text("购物车无数据!");
          }

          return Stack(
            children: <Widget>[
              Provide<CartProvide>(
                builder: (context,child,val){
                  return ListView.builder(
                    itemCount: val.cartList.length,
                    itemBuilder: (context,index){
                      return CartItem(val.cartList[index]);
                    },
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: CartBottom(),
              )
            ],
          );

        },
      )
    );
  }

  _getCartInfo(context) async{
    await Provide.value<CartProvide>(context).getCartInfo();
    return "success";
  }
}