import 'package:flutter/material.dart';

import './pages/homePage.dart';
import './pages/newsPage.dart';
import '/pages/githubPage.dart';

import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "assets/config/.env");
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  // TabController? controller;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // controller = TabController(length: 3, vsync: this);

    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Listview Example'),
      // ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          homePage(),
          githubPage(),
          newsPage(),
        ],
      ),


      bottomNavigationBar: MotionTabBar(
        labels: const ["Home", "Trend", "News"],
        initialSelectedTab: "Home",
        icons: [
          Icons.home,
          Icons.trending_up,
          Icons.newspaper,
        ],
        tabIconColor: Color.fromARGB(255, 36, 41, 47),
        tabSelectedColor: Color.fromARGB(255, 36, 41, 47),
        onTabItemSelected: (int value) {
          setState(() {
            _tabController!.index = value;
          });
        },
        textStyle: TextStyle(color: Color.fromARGB(255, 36, 41, 47)),
      ),

      // bottomNavigationBar: TabBar(tabs: <Tab>[
      //     Tab(icon: Icon(Icons.home, color: Colors.blue),) ,
      //     Tab(icon: Icon(Icons.trending_up, color: Colors.blue),),
      //     Tab(icon: Icon(Icons.newspaper, color: Colors.blue),)
      //   ], controller: controller,
      // )
    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
}