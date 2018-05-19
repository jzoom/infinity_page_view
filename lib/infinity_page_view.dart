library infinity_page_view;


import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';


final InfinityPageController _defaultPageController = new InfinityPageController();
const int MAX_VALUE = 2000000000;
const int MIDDLE_VALUE = 1000000000;

class InfinityPageView extends StatefulWidget{


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
    InfinityPageController controller,
    this.physics,
    this.pageSnapping: true,
    this.onPageChanged,
    @required this.itemBuilder,
    @required this.itemCount,
  }) :controller = controller ?? _defaultPageController,
        assert(itemCount!=null);

  @override
  State<StatefulWidget> createState() {
    return new _InfinityPageViewState();
  }

}


class InfinityPageController{

  final PageController pageController;

  int itemCount;
  int realIndex;

  InfinityPageController({
    int initialPage: 0,
    bool keepPage: true,
    double viewportFraction: 1.0,
  }):
        realIndex = initialPage + MIDDLE_VALUE ,
        pageController = new PageController(
            initialPage: initialPage + MIDDLE_VALUE,
            keepPage: keepPage,
            viewportFraction: viewportFraction
        );


  int get page{
    return calcIndex(this.realIndex);
  }

  int calcIndex(int realIndex){
    int index = (realIndex - MIDDLE_VALUE) % this.itemCount;
    if(index < 0  ){
      index += this.itemCount;
    }
    return index;
  }

  Future<Null> animateToPage(int page, {
    @required Duration duration,
    @required Curve curve,
  }){
    assert(page != null);
    //find the nearest value greater/little than realIndex
    int offset = page - this.page;

    if(offset == 0){
      return new Future.value(null);
    }

    int destPage = offset + realIndex;

    return pageController.animateToPage( destPage ,
        duration: duration,
        curve: curve);
  }


  void jumpToPage(int value){
    assert(value!=null);

    pageController.jumpToPage(value  + MIDDLE_VALUE);
  }


  void dispose(){
    pageController.dispose();
  }

}

class _InfinityPageViewState extends State<InfinityPageView>{


  void _onPageChange(int realIndex){
    widget.controller.realIndex = realIndex;
    widget?.onPageChanged(widget.controller.page);
  }

  Widget _itemBuild(BuildContext context,int index){
    int _index = widget.controller.calcIndex(index);
    return widget.itemBuilder(context,_index);
  }

  @override
  Widget build(BuildContext context) {


    return new PageView.builder(
      key: widget.key,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller.pageController,
      physics: widget.physics,
      pageSnapping: widget.pageSnapping,
      onPageChanged: _onPageChange,
      itemBuilder: _itemBuild,
      itemCount: MAX_VALUE,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(InfinityPageView oldWidget) {
    if(widget.controller!=oldWidget.controller){
      widget.controller.itemCount = widget.itemCount;
      widget.controller.realIndex = oldWidget.controller.realIndex;

    }
    super.didUpdateWidget(oldWidget);
  }


  @override
  void initState() {
    widget.controller.itemCount = widget.itemCount;
    super.initState();
  }



  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

}