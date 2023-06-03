import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';

import '../dataClass/news.dart';

class newsPage extends StatefulWidget {
  _newsPageState createState() => _newsPageState();
}

class _newsPageState extends State<newsPage> {
  String result = '';

  List<News> newsData = new List.empty(growable: true);


  @override
  void initState() {
    super.initState();

    newsData = [];
    getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 18, 53, 119),
            // title: Text("ddddddddd"),
            elevation: 0.0,
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(children: [
              Container(
                  height: 200,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                            child: Text(
                              "IT/과학 News",
                              style: TextStyle(fontSize: 30, color: Colors.white),
                            )),
                      ),
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
                    child: newsData!.length == 0
                        ? Text("준비중")
                        : ListView.builder(
                        itemBuilder: (context, position) {
                          return GestureDetector(
                            child: Card(
                                child: Container(
                                    padding: EdgeInsets.all(0),

                                    // child: SingleChildScrollView(
                                    //     scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                              Container(
                                                child: Image.network(newsData![position].imgUrl.toString(), fit: BoxFit.fill),
                                                  padding: EdgeInsets.all(5),
                                                width: 120,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey)
                                                ),
                                              ),

                                              Container(
                                                width: 220,
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [
                                                    Text(
                                                      '${newsData![position].title.toString()}',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.fade,
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    Text('${newsData![position].content.toString()}', maxLines: 3,overflow: TextOverflow.ellipsis,),
                                                  ],
                                                ),
                                              )



                                          ],
                                        )
                                    // )



                                )




                            ),
                            onTap: () async {
                              await launch('${newsData![position].url}', forceWebView: true, forceSafariVC: true);
                            },
                          );
                        },
                        itemCount: newsData!.length),
                  ),
                ),
              )
            ])));
  }

  Future<String> getJSONData() async {
    var url = 'https://www.bloter.net/news/articleList.html?sc_section_code=S1N4&view_type=sm';
    var response = await http.get(Uri.parse(url));

    dom.Document document = parser.parse(response.body);

    List<String> imgUrlList = [];
    List<String> titleList = [];
    List<String> contentList = [];
    List<String> urlList = [];

    newsData.clear();

    List<dom.Element> imgUrls = document.getElementsByClassName('thumb');
    for(var i=0; i<imgUrls.length-1; i++){
      dom.Element aTag = imgUrls[i].getElementsByTagName('img')[0];
      String imgUrl = aTag.attributes['src'].toString();
      imgUrlList.add(imgUrl);
    }

    

    List<dom.Element> titles = document.getElementsByClassName('titles');
    for(var i=1; i<titles.length-2; i++){
      dom.Element aTag = titles[i].getElementsByTagName('a')[0];
      String title = aTag.text.replaceAll(RegExp(r"\n|\t"), '');

      String url = "https://www.bloter.net" + aTag.attributes['href'].toString();

      titleList.add(title);

      urlList.add(url);
    }

    List<dom.Element> contents = document.getElementsByClassName('lead line-6x2');
    for(var i=0; i<contents.length-1; i++){
      dom.Element aTag = contents[i].getElementsByTagName('a')[0];
      String content = aTag.text.replaceAll(RegExp(r"^\s+|\s+$|\s+(?=\s)"), '');
      contentList.add(content);
    }


    setState(() {
      for (var i = 0; i < imgUrlList.length; i++) {
        newsData.add(News(
          imgUrl: imgUrlList[i],
          title: titleList[i],
          content: contentList[i],
          url: urlList[i],
        ));
      }
    });

    return "success";
  }
}