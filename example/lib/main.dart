import 'package:flutter/material.dart';

import 'package:infinity_page_view/infinity_page_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'infinity_page_view'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String label;
  int itemCount;
  InfinityPageController infinityPageController;

  @override
  void initState() {
    //  infinityPageController = new InfinityPageController(initialPage: 0);
    itemCount = 3;
    label = "1/${itemCount}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Column(
          children: <Widget>[
            new SizedBox(
              height: 300.0,
              child: new InfinityPageView(
                itemBuilder: (BuildContext context, int index) {
                  switch (index) {
                    case 0:
                      return new Image.network(
                        "http://via.placeholder.com/350x150",
                        fit: BoxFit.fill,
                      );
                    case 1:
                      return new Image.network(
                        "http://via.placeholder.com/250x100",
                        fit: BoxFit.fill,
                      );
                  }
                  return new Image.network(
                    "http://via.placeholder.com/288x188",
                    fit: BoxFit.fill,
                  );
                },
                itemCount: itemCount,
                onPageChanged: (int index) {
                  setState(() {
                    label = "${index+1}/${itemCount}";
                  });
                },
                controller: infinityPageController,
              ),
            ),
            new Text(
              label,
              style: new TextStyle(fontSize: 100.0),
            ),
            new Row(
              children: <Widget>[
                new FlatButton(
                    onPressed: () {
                      print("the page is ${infinityPageController.page}");

                      infinityPageController.animateToPage(
                          infinityPageController.page - 1,
                          duration: new Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: new Text("left")),
                new FlatButton(
                    onPressed: () {
                      print("the page is ${infinityPageController.page}");

                      infinityPageController.animateToPage(
                          infinityPageController.page + 1,
                          duration: new Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: new Text("right")),
                new FlatButton(
                    onPressed: () {
                      print("the page is ${infinityPageController.page}");

                      infinityPageController
                          .jumpToPage(infinityPageController.page - 1);
                    },
                    child: new Text("left")),
                new FlatButton(
                    onPressed: () {
                      print("the page is ${infinityPageController.page}");

                      infinityPageController
                          .jumpToPage(infinityPageController.page + 1);
                    },
                    child: new Text("right")),
              ],
            ),
          ],
        ));
  }
}
