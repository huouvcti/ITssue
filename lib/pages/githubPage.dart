import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

import './githubDetail.dart';
import '../dataClass/trend.dart';

class githubPage extends StatefulWidget {
  _githubPageState createState() => _githubPageState();
}

class _githubPageState extends State<githubPage> {
  String result = '';

  List<Trend> trendData = new List.empty(growable: true);

  List<String> search_since = ['daily', 'weekly', 'monthly'];
  List<String> show_since = ['Today', 'This week', 'This month'];
  int select_since = 0;

  @override
  void initState() {
    super.initState();

    trendData = [];
    getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 36, 41, 47),
            // title: Text("ddddddddd"),
            elevation: 0.0,
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 36, 41, 47),
            ),
            child: Column(children: [
              Container(
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                            child: Text(
                              "Github Trending",
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            )),
                      ),
                      Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var i = 0; i < search_since.length; i++)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(100, 50),
                                      backgroundColor: (i == select_since)
                                          ? Color.fromARGB(255, 246, 248, 250)
                                          : Color.fromARGB(255, 64, 73, 83),
                                      foregroundColor: (i == select_since)
                                          ? Color.fromARGB(255, 64, 73, 83)
                                          : Color.fromARGB(255, 246, 248, 250),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),
                                  child: Text('${show_since[i]!}'),
                                  onPressed: () {
                                    setState(() {
                                      select_since = i;


                                      getJSONData();
                                    });
                                  },
                                ),
                            ],
                          ))
                    ],
                  )),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 246, 248, 250),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: trendData!.length == 0
                        ? Text("준비중")
                        : ListView.builder(
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      padding: EdgeInsets.all(15),
                                      height: 80,
                                      width: 380,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 30, 0),
                                              child: Text('${position + 1}',
                                                  style: TextStyle(
                                                      fontSize: 18)),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 300,
                                                  child:
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    child: Text(
                                                        '${trendData![position].userName.toString()} / ${trendData![position].repoName.toString()}',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Color
                                                                .fromARGB(
                                                                255,
                                                                36,
                                                                41,
                                                                47))),
                                                  ),
                                                ),
                                                Container(
                                                  width: 250,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .language,
                                                              size: 18,
                                                              color: Colors
                                                                  .grey),
                                                          Text(
                                                              '${trendData![position].language.toString()}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .star_border,
                                                              size: 18,
                                                              color: Colors
                                                                  .amber),
                                                          Text(
                                                            '${trendData![position].star.toString()}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .share_outlined,
                                                              size: 18,
                                                              color: Colors
                                                                  .blueAccent),
                                                          Text(
                                                              '${trendData![position].fork.toString()}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),

                                  // Text('${trendData![position].url.toString()}'),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => githubDetail(
                                          trend: trendData![position])));
                            },
                          );
                        },
                        itemCount: trendData!.length),
                  ),
                ),
              )
            ])));
  }

  Future<String> getJSONData() async {
    var url = 'https://github.com/trending?since=${search_since[select_since]}';
    var response = await http.get(Uri.parse(url));

    dom.Document document = parser.parse(response.body);

    List<String> userNameList = [];
    List<String> repoNameList = [];
    List<String> urlList = [];
    List<String> languageList = [];
    List<String> starList = [];
    List<String> forkList = [];

    trendData.clear();

    // userName, repoName, url
    document
        .getElementsByClassName('h3 lh-condensed')
        .forEach((dom.Element element) {
      String userName_repoName = element.text.replaceAll(RegExp(r"\s+"), '');

      List<String> userName_repoName_list =
      userName_repoName.split('/').toList();

      userNameList.add(userName_repoName_list[0]);
      repoNameList.add(userName_repoName_list[1]);

      urlList.add('https://github.com/' + userName_repoName);
    });

    // language
    document
        .getElementsByClassName('d-inline-block ml-0 mr-3')
        .forEach((dom.Element element) {
      languageList.add(element.text.replaceAll(RegExp(r"\s+"), ''));
    });

    // star, fork
    document
        .getElementsByClassName('Link--muted d-inline-block mr-3')
        .forEachIndexed((index, dom.Element element) {
      if (index % 2 == 0) {
        starList.add(element.text.replaceAll(RegExp(r"\s+"), ''));
      } else {
        forkList.add(element.text.replaceAll(RegExp(r"\s+"), ''));
      }
    });

    setState(() {
      for (var i = 0; i < userNameList.length; i++) {
        trendData.add(Trend(
            userName: userNameList[i],
            repoName: repoNameList[i],
            url: urlList[i],
            language: languageList[i],
            star: starList[i],
            fork: forkList[i]));
      }
    });

    return "success";
  }
}