import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../router/router_handler.dart';

class Routes {
  static String root = "/";
  static String detailsPage = "/detail";
  static void configureRoutes(Router router){
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context,Map<String,List<String>> params){
        print("ERROR====> router is not found");
      }
    );
    router.define(detailsPage,handler:detailsHandler);
  }
}