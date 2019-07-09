import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';

Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String goodsId = params['goodsId'].first;
      print(goodsId);
      return DetailsPage(goodsId);
    }
);
