import 'package:flutter/material.dart';

class QuickRoute extends StatelessWidget {
  const QuickRoute(
      {super.key,
      this.path,
      this.match,
      this.exact = false, 
      required this.child});

  final String? match;
  final String? path;
  final Widget child;
  final bool exact;  

  static void appendKeyVals( String prefix, String keyvals, Map<String, String> host )
  {
    keyvals.split("&").forEach((element) {
      var itm = element.split("=");
      host["$prefix${itm[0]}"] = itm[1];
    });
  }

  @override
  Widget build(BuildContext context) {

    QuickRouteContext? routeContext = QuickRouteContext.of(context);
    String? $path = path ?? routeContext?.path; //hardcoded path o el del context mas cercano.
    Map<String, String> params = path!=null || routeContext?.params.isEmpty == true? {} : Map.from( routeContext!.params );

    if( $path == null )
    { 
      return Text("[Route no tiene path]"); //empty
    }

    if( path!=null ) //we are the top-most quick route...
    {
      var tmp = $path.split("#");
      $path = tmp[0];
      tmp.length==2 ? appendKeyVals("#", tmp[1], params) : null;

      tmp = $path.split("?");
      $path = tmp[0];
      tmp.length==2 ? appendKeyVals("?", tmp[1], params) : null;
    }

    String afterPath = $path; 

    if ( match != null) 
    {
      List<String> patternSegments  = match!.split('/');
      List<String> pathSegments     = $path.split('/'); 

      if( patternSegments.length>pathSegments.length || (exact && patternSegments.length!=pathSegments.length))
      {
        return Container(); //empty/ no matches
      }

      for (int i = 0; i < patternSegments.length; i++) 
      {
        String segment = patternSegments[i];
        String pathSegment = pathSegments[i];

        if (segment.startsWith(':')) 
        {
          String paramName = segment.substring(1);
          params[paramName] = pathSegment;
          patternSegments[i] = pathSegment;
        }
        else if ( segment!=pathSegment )
        {
          return Container(); //exit, no match...
        }
      }  

      String myPath = patternSegments.join("/");
      afterPath = $path.replaceFirst(myPath, ""); //quitamos nuestro matching path 

      if( !afterPath.startsWith("/") )
      {
        afterPath = "/$afterPath";
      } 
    }  


    return QuickRouteContext(path: afterPath, params: params, child:child) ;
  }
}

extension QuickRouteShortcut on BuildContext {
  QuickRouteContext? get quickRouteContext => QuickRouteContext.of(this);
}

class QuickRouteContext extends InheritedWidget { 
  const QuickRouteContext({ super.key, required this.path, required this.params, required super.child });

  /// path at this stage of the context
  final String path;

  /// params are collected and put here (includes segment parameters, querystrings and hash key/values)
  final Map<String, String> params;

  @override
  bool updateShouldNotify(QuickRouteContext oldWidget) => path != oldWidget.path;

  static QuickRouteContext? of(BuildContext context) { 
    return context.dependOnInheritedWidgetOfExactType<QuickRouteContext>();
  }

  T? param<T>(String key) {
    return params[key] as T;
  }
}
