import 'package:flutter/material.dart';
import 'package:peaky_blinders/Bloc/BlocProvider.dart';

class PageBloc implements BlocBase {
  int page = 0;
  PageController controller;

  PageBloc() {
    controller = new PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  void navigateToPage(int index) {
    page = index;
    controller.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
