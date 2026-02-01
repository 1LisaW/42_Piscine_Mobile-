import 'package:flutter/material.dart';

class ScreenBody extends StatefulWidget {
  final String tabBarTitle;
  final String tabBarGeoposition;
  final TabController tabController;
  final bool hasError;
  final String errorMessage;

  const ScreenBody(
      {Key? key,
      required this.tabBarTitle,
      required this.tabBarGeoposition,
      required this.tabController,
      required this.hasError,
      required this.errorMessage})
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
                child: widget.hasError ? Text(widget.errorMessage, style: TextStyle(fontSize: 18, color: Colors.red))
                : Column(
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
