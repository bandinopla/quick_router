<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
# QuickRoute
[![pub package](https://img.shields.io/pub/v/quick_router.svg)](https://pub.dev/packages/quick_router)

A quick routing mechanism for [Flutter](https://flutter.dev/) to handle deep linking on a hurry. 

## Getting started

Import the package and just create as many `QuickRoute` widgets as you need, they can be nested in which case they will start analazing the path where their parent left of.

## Install 

```bash
flutter pub add quick_router
```

In this example `onGenerateRoute` is being used, but the QuickRoute just needs a `path` (a url) and it will cascade down while analyzing the path's segments.

```dart
void main() {
  runApp(MaterialApp( 
    onGenerateRoute: (settings) {
        String url = settings.name; // url to use as base...
        return QuickRoute(path: url, match:"/library", child:Column(children:[
            QuickRoute(math:"/horror", child:Text("Horror books")), // will run on /library/horror
            QuickRoute(math:"/drama", child:Text("Drama books")), // will run on /library/drama
        ]));
    }
  )); 
}
```

## One widget

`QuickRoute` is a widget that IF it has a `path` it will act as the *main* route. Any children `QuickRoute` will start analizing the path after the parent eat it's match from the `path` and so on...

Each route creates a context that can be accessed calling `context.quickRouteContext?` and exposes a method `param` to get the parameters (if any) 

The method `T param<T>(String paramKey)` allows you to cast the param to a specific type.

## Parameters
You get them from the build context of your widget, like so:
```dart
  @override
  Widget build(BuildContext context) {
    // if the url is /some/url/:someKey/etc/:count
    // and the real url is: /some/url/magic/etc/123
    var myParamValue = context.quickRouteContext?.param<String>("someKey"); // = magic
    var myParamValue2 = context.quickRouteContext?.param<int>("count"); // = 123
    return Text("child param: $myParamValue;");
  }
```


There are 3 types of parameters:
1. **URL SEGMENT** that look like this `/some/:wildcard/path` in this case **wildcard** will be a parameter that will match anything between the slashes.
2. **QUERY STRING** anything in the querystring portion will be added to the params bag with the `?` prefix. So `/some/url?nice=string&foo=bar` will add `?nice` and `?foo` to the params.
3. **HASH** same as with querystring but for hash values: `/some/path#foo=bar&batman=forever` will have `#foo` and `#batman` in the params
