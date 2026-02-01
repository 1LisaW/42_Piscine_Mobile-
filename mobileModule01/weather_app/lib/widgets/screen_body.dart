import 'package:flutter/material.dart';

class ScreenBody extends StatefulWidget {
  final String tabBarTitle;
  final String tabBarGeoposition;
  final TabController tabController;

  const ScreenBody(
      {Key? key,
      required this.tabBarTitle,
      required this.tabBarGeoposition,
      required this.tabController})
      : super(key: key);

  @override
  State<ScreenBody> createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<ScreenBody> {
  @override
  Widget build(BuildContext) {
    return (Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.tabBarTitle,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.tabBarGeoposition,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        )))));
  }
}
