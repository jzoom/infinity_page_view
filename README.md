# infinity_page_view
A Flutter infinity page view.

[![build status](https://api.travis-ci.org/jzoom/infinity_page_view.svg?branch=master)](https://travis-ci.org/jzoom/infinity_page_view)

# Showcase


![](https://github.com/jzoom/infinity_page_view/raw/master/preview.gif)


# Usage

 ## Example: add the module to your project pubspec.yaml:
 
```
    
    dependencies:
     ...
     infinity_page_view: ^1.0.0
    
```
 
And install it using flutter packages get on your project folder. After that, just import the module and use it:
 
 
 ```
 
 import 'package:infinity_page_view/infinity_page_view.dart';
 
 ...
 
 InfinityPageController infinityPageController = new InfinityPageController(initialPage: 0);
 ...
 
 
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
```
