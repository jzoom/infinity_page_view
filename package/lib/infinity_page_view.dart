library infinity_page_view;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

const int kMaxValue = 2000000000;
const int kMiddleValue = 1000000000;

class InfinityPageView extends StatefulWidget {
  final Axis scrollDirection;
  final ScrollPhysics physics;
  final bool pageSnapping;
  final ValueChanged<int> onPageChanged;
  final bool reverse;
  final IndexedWidgetBuilder itemBuilder;
  final InfinityPageController controller;
  final int itemCount;

  InfinityPageView({
    Key key,
    this.scrollDirection: Axis.horizontal,
    this.reverse: false,
    this.controller,
    this.physics,
    this.pageSnapping: true,
    this.onPageChanged,
    @required this.itemBuilder,
    @required this.itemCount,
  }) : assert(itemCount != null) ,assert(itemBuilder!=null);

  @override
  State<StatefulWidget> createState() {
    return new _InfinityPageViewState();
  }
}

class InfinityPageController  {
  PageController pageController;

  int itemCount;
  int realIndex;

  InfinityPageController({
    int initialPage: 0,
    bool keepPage: true,
    double viewportFraction: 1.0,
  })  : realIndex = initialPage + kMiddleValue{
    pageController = new PageController(
        initialPage: initialPage + kMiddleValue,
        keepPage: keepPage,
        viewportFraction: viewportFraction);
  }

  int get page {
    return calcIndex(this.realIndex);
  }

  int calcIndex(int realIndex) {
    if(itemCount == 0)return 0;
    int index = (realIndex - kMiddleValue) % this.itemCount;
    if (index < 0) {
      index += this.itemCount;
    }
    return index;
  }

  Future<Null> animateToPage(
      int page, {
        @required Duration duration,
        @required Curve curve,
      }) {
    assert(page != null);
    assert(curve != null);
    assert(duration != null);

    //find the nearest value greater/little than realIndex
    int offset = page - this.page;

    if (offset == 0) {
      return new Future.value(null);
    }

    int destPage = offset + realIndex;

    return pageController.animateToPage(destPage,
        duration: duration, curve: curve);
  }

  void jumpToPage(int value) {
    assert(value != null);

    pageController.jumpToPage(value + kMiddleValue);
  }

  void dispose() {
    pageController.dispose();
  }
}

class _InfinityPageViewState extends State<InfinityPageView> {


  InfinityPageController controller;



  void _onPageChange(int realIndex) {
    widget.controller.realIndex = realIndex;
    if(widget.onPageChanged!=null)
      widget.onPageChanged(widget.controller.page);
  }

  Widget _itemBuild(BuildContext context, int index) {
    int _index = controller.calcIndex(index);
    return widget.itemBuilder(context, _index);
  }

  @override
  Widget build(BuildContext context) {
    return new PageView.builder(
      key: widget.key,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: controller.pageController,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      onPageChanged: _onPageChange,
      itemBuilder: _itemBuild,
      itemCount: kMaxValue,
    );
  }

  @override
  void initState() {

    if(widget.controller==null){
      controller = new InfinityPageController();
    }else{
      controller = widget.controller;
    }
    controller.itemCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(InfinityPageView oldWidget) {

    if(widget.controller != controller ){
      if(widget.controller!=null){
        controller = widget.controller;
      }
    }
    controller.itemCount = widget.itemCount;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if(controller!=null && controller!=widget.controller){
      controller.dispose();
    }
    super.dispose();
  }
}
