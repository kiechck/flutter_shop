import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/index_page.dart';
import 'package:flutter_shop/provide/category_goods_list.dart';
import './provide/child_category.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';
import './router/routes.dart';
import './router/application.dart';
import './provide/details_info.dart';

void main() {
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  
  // 全局状态管理
  var providers = Providers()
  ..provide(Provider<ChildCategory>.value(childCategory))
  ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
  ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide));

  runApp(ProviderNode(child: MyApp(),providers: providers,)); 
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    // 路由
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Welcome to Flutter',
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(
          primaryColor: Colors.purple[400],
        ),
        home: IndexPage(),
      ),
    );
  }
}
