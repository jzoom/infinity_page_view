library infinity_page_view;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

const int MAX_VALUE = 2000000000;
const int MIDDLE_VALUE = 1000000000;

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
    InfinityPageController controller,
    this.physics,
    this.pageSnapping: true,
    this.onPageChanged,
    @required this.itemBuilder,
    @required this.itemCount,
  })  : controller = (controller == null
            ? new InfinityPageController(initialPage: 0)
            : controller),
        assert(itemCount != null) {
    this.controller.wrap(itemCount);
  }

  @override
  State<StatefulWidget> createState() {
    return new _InfinityPageViewState();
  }
}

class InfinityPageController {
  final PageController pageController;

  int _itemCount;

  void set itemCount(int itemCount) => _itemCount = itemCount;
  void set infiniteIndex(int infiniteIndex) => _infiniteIndex = infiniteIndex;

  int _infiniteIndex;

  InfinityPageController wrap(int itemCount) {
    _itemCount = itemCount;
    return this;
  }

  InfinityPageController({
    int initialPage: 0,
    bool keepPage: true,
    double viewportFraction: 1.0,
  })  : _infiniteIndex = initialPage + MIDDLE_VALUE,
        pageController = new PageController(
            initialPage: initialPage + MIDDLE_VALUE,
            keepPage: keepPage,
            viewportFraction: viewportFraction);

  int get page {
    return calcIndex(this._infiniteIndex);
  }

  int calcIndex(int infiniteIndex) {
    int index = (infiniteIndex - MIDDLE_VALUE) % _itemCount;
    if (index < 0) {
      index += _itemCount;
    }
    return index;
  }

  Future<Null> animateToPage(
    int page, {
    @required Duration duration,
    @required Curve curve,
  }) {
    assert(page != null);
    //find the nearest value greater/little than infiniteIndex
    int offset = page - this.page;

    if (offset == 0) {
      return new Future.value(null);
    }

    int destPage = offset + _infiniteIndex;

    return pageController.animateToPage(destPage,
        duration: duration, curve: curve);
  }

  void jumpToPage(int value) {
    assert(value != null);

    pageController.jumpToPage(value + MIDDLE_VALUE);
  }

  void dispose() {
    pageController.dispose();
  }
}

class _InfinityPageViewState extends State<InfinityPageView> {
  void _onPageChange(int infiniteIndex) {
    widget.controller.infiniteIndex = infiniteIndex;
    widget?.onPageChanged(widget.controller.page);
  }

  Widget _itemBuild(BuildContext context, int index) {
    int _index = widget.controller.calcIndex(index);
    return widget.itemBuilder(context, _index);
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
  void didUpdateWidget(InfinityPageView oldWidget) {
    widget.controller.itemCount = widget.itemCount;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    widget.controller.itemCount = widget.itemCount;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
