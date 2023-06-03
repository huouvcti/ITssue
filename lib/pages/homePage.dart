import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class homePage extends StatefulWidget {
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  final String gptAPIKey = dotenv.env['gptAPIkey']!;
  String lifeQuote = "";

  @override
  void initState() {
    super.initState();

    lifeQuote = "";
    ChatGPTLifeQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 36, 41, 47),
        child: Center(
        child: Container(
          width: 300,
          
            child: (lifeQuote == "")
            ? AnimatedTextKit(

                animatedTexts: [
                  TypewriterAnimatedText(
                    '명언 불러오는 중. . .',
                    textStyle: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      
                    ),
                    textAlign: TextAlign.center,
                    speed: const Duration(milliseconds: 200),
                  ),
                  
                ],
                totalRepeatCount: 100,
            )
            : AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              '$lifeQuote',
              textStyle: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                
              ),

              textAlign: TextAlign.center,
              speed: const Duration(milliseconds: 100),
            ),
          ],
          
          totalRepeatCount: 3,
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
        )
        
      ),
    );
    
    
    
    // Scaffold(
    //     appBar: PreferredSize(
    //       preferredSize: Size.fromHeight(0),
    //       child: AppBar(
    //         backgroundColor: Color.fromARGB(255, 18, 53, 119),
    //         // title: Text("ddddddddd"),
    //         elevation: 0.0,
    //       ),
    //     ),
    //     body: Container(
    //         decoration: BoxDecoration(
    //           color: Colors.indigo,
    //         ),
    //         child: (lifeQuote == "")
    //         ? Text("준비중")
    //         : Text("$lifeQuote")
    //           )
    //         );
  }




  Future<String> ChatGPTLifeQuote() async {

    final apiUrl = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $gptAPIKey'
      },
      body: jsonEncode({
        "messages": [
            {"role": "user", "content": "IT 분야 관련 명언을 하나 알려줘"},
            {"role": "assistant", "content": "\"어려운 문제를 해결하기 위해서는 단순함을 추구해야 한다.\"\n\n- 앨런 페럴슨 (Alan Perlis)"},
            {"role": "user", "content": "IT 분야 관련 명언을 하나 알려줘"}
        ],
        "model": "gpt-3.5-turbo",
        "temperature": 0.2,
        "max_tokens": 1000,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        lifeQuote = responseData['choices'][0]['message']['content'];
      });

      
    } else {
      throw Exception('Failed to communicate with ChatGPT API');
    }


    return "success";
  }
}