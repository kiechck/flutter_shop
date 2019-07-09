import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DetailTabbar extends StatelessWidget {
  const DetailTabbar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (centext,child,data){
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        var isRight = Provide.value<DetailsInfoProvide>(context).isRight;

        return Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
            children: <Widget>[
              _myTabBarLeft(centext,isLeft),
              _myTabBarRight(centext,isRight),
            ],
          ),
        );
      },
    );
  }

  Widget _myTabBarLeft(BuildContext context, bool isLeft){
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: isLeft?Colors.pink : Colors.black12)
          )
        ),
        child: Text(
          "详情",
          style: TextStyle(
            color: isLeft? Colors.pink : Colors.black12
          ),
        ),
      ),
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight("left");
      },
    );
  }

  Widget _myTabBarRight(BuildContext context, bool isRight){
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: isRight?Colors.pink : Colors.black12)
          )
        ),
        child: Text(
          "评论",
          style: TextStyle(
            color: isRight? Colors.pink : Colors.black12
          ),
        ),
      ),
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight("right");
      },
    );
  }

}