import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:quick_router/quick_router.dart";

void main() {  

  testWidgets('Simple path test', (tester) async {

    await tester.pumpWidget(TestWidget(path: "/test/one"));
    final titleFinder = find.text('Parent test;');
    final childFinder = find.text('test #1;');

    expect(titleFinder, findsOneWidget);
    expect(childFinder, findsOneWidget);
  });

  testWidgets('"Complex" path test', (tester) async {

    await tester.pumpWidget(TestWidget(path: "/test/two/batman?dummy=1"));
    final titleFinder = find.text('Parent test;');
    final childFinder = find.text('child param: batman;');

    expect(titleFinder, findsOneWidget);
    expect(childFinder, findsOneWidget);
  });

  testWidgets('reading query string', (tester) async {

    await tester.pumpWidget(TestWidget(path: "/test/two/batman?dummy=1&joker=123", childParamKey: "?joker",));
    final titleFinder = find.text('Parent test;');
    final childFinder = find.text('child param: 123;');

    expect(titleFinder, findsOneWidget);
    expect(childFinder, findsOneWidget);
  });

  testWidgets('reading hash string', (tester) async {

    await tester.pumpWidget(TestWidget(path: "/test/two/batman?dummy=1&joker=123#some=crazy&hash=madness", childParamKey: "#hash",));
    final titleFinder = find.text('Parent test;');
    final childFinder = find.text('child param: madness;');

    expect(titleFinder, findsOneWidget);
    expect(childFinder, findsOneWidget);
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({super.key, this.path, this.childParamKey = "wildcard"});

  final String? path;
  final String childParamKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Path Demo',
      home: Scaffold( 
        body: QuickRoute(path: path, match: "/test", child: Column(children: [
          Text("Parent test;"),
          QuickRoute(child: Text("test #1;"), match: "/one"),
          QuickRoute(child: ChildTest(paramKey:childParamKey), match: "/two/:wildcard"),
        ],),),
      ),
    );
  }
}

class ChildTest extends StatelessWidget {
  const ChildTest({super.key, required this.paramKey});
  final String paramKey;

  @override
  Widget build(BuildContext context) {
    var myParamValue = context.quickRouteContext?.param<String>(paramKey);
    
    return Text("child param: $myParamValue;");
  }
}