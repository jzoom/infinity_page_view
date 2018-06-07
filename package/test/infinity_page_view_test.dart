import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:infinity_page_view/infinity_page_view.dart';
import 'dart:async' as Async;

void main() {
  testWidgets('Test basic usage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MaterialApp(
      home: new InfinityPageView(
          itemBuilder: (BuildContext context, int index) {
            return new Text("$index");
          },
          itemCount: 3),
    ));
    expect(find.text('0',skipOffstage: false), findsOneWidget);
  });


  testWidgets('Test controller', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    InfinityPageController controller = new InfinityPageController(initialPage: 1);
    await tester.pumpWidget(new MaterialApp(
      home: new InfinityPageView(
          controller:controller,
          itemBuilder: (BuildContext context, int index) {
            return new Text("$index");
          },
          itemCount: 3),
    ));
    expect(find.text('1',skipOffstage: false), findsOneWidget);

    controller.jumpToPage(2);


  });
}
