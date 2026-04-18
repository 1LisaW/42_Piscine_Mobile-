import 'package:flutter/material.dart';
import 'package:flutter_app/constants/text_constants.dart';
import 'package:flutter_app/widgets/screen_body.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App!!',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Flutter Example App'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  String geolocation = 'Geolocation';
  String searchGeolocation = '';
  final textController = TextEditingController();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() => {setState(() => {})});
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.grey.shade300,
        title: Container(
          decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1.5, color: Colors.white)),
          ),
          child: TextField(
            controller: textController,
            style: TextStyle(
              color: Colors.grey.shade300,
              decoration: TextDecoration.none,
              decorationThickness: 0,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              fillColor: Colors.grey.shade300,
              hintText: 'Search location...',
              hintStyle: TextStyle(color: Colors.grey.shade300),
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 228, 224, 224),
              ),
            ),
            onSubmitted: (text) {
              setState(() {
                searchGeolocation = text;
                textController.text = '';
              });
            },
          ),
        ),
        actions: <Widget>[
          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 10),
            icon: const Icon(Icons.near_me, color: Colors.white),
            onPressed: () {
              setState(() {
                searchGeolocation = geolocation;
                textController.text = '';
              });
            },
          ),
          // )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,

        child: TabBar(
          labelColor: Color.fromARGB(255, 101, 92, 163),
          unselectedLabelColor: Colors.grey.shade500,
          padding: EdgeInsets.all(0),
          tabs: [
            Tab(
              text: TextConstants.titleTab_1,
              icon: Icon(
                Icons.brightness_5_sharp,
                color: tabController.index == 0
                    ? Colors.indigo.shade500
                    : Colors.grey.shade500,
              ),
            ),
            Tab(
              text: TextConstants.titleTab_2,
              icon: Icon(
                Icons.today,
                color: tabController.index == 1
                    ? Colors.indigo.shade500
                    : Colors.grey.shade500,
              ),
            ),
            Tab(
              text: TextConstants.titleTab_3,
              icon: Icon(
                Icons.date_range_sharp,
                color: tabController.index == 2
                    ? Colors.indigo.shade500
                    : Colors.grey.shade500,
              ),
            ),
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ScreenBody(
            tabBarTitle: TextConstants.titleTab_1,
            tabBarGeoposition: searchGeolocation,
            tabController: tabController,
          ),
          ScreenBody(
            tabBarTitle: TextConstants.titleTab_2,
            tabBarGeoposition: searchGeolocation,
            tabController: tabController,
          ),
          ScreenBody(
            tabBarTitle: TextConstants.titleTab_3,
            tabBarGeoposition: searchGeolocation,
            tabController: tabController,
          ),
        ],
      ),
    );
  }
}
