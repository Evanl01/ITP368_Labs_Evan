import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'newsItem.dart';
import 'newsItemPage.dart';

void main() {
  runApp(News());
}

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "news",
      home: Scaffold(
        appBar: AppBar(title: Text("news")),
        body: News1(),
      ),
    );
  }
}

class News1 extends StatefulWidget {
  @override
  _News1State createState() => _News1State();
}

class _News1State extends State<News1> {
  List<NewsItem> allni = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNewsItems();
  }

  void fetchNewsItems() async {
    List<NewsItem> newsItems = await topStreamItems();
    setState(() {
      allni = newsItems;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: Text("Loading ..."));
    }
    return ListView.builder(
      itemCount: allni.length,
      itemBuilder: (context, index) {
        final ni = allni[index];
        return ElevatedButton(
          child: Text(ni.headline),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsItemPage(newsItem: ni),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<NewsItem>> topStreamItems() async {
    String root = "https://hacker-news.firebaseio.com/v0/";
    List<int> topList = await getTopNumbers();
    List<NewsItem> newsItems = [];
    for (int sn in topList) {
      final url = Uri.parse('${root}item/${sn}.json');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> theItem = jsonDecode(response.body);
        NewsItem ni = NewsItem.fromJson(theItem);
        newsItems.add(ni);
        // print('Fetched story: ${ni.headline}');
      } else {
        print('Failed to load news item');
      }
    }
    return newsItems;
  }

  Future<List<int>> getTopNumbers() async {
    String root = "https://hacker-news.firebaseio.com/v0/";
    final url = Uri.parse('${root}topstories.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> dataList = jsonDecode(response.body);
      List<int> topList = [];
      for (int i = 0; i < 10; i++) {
        topList.add(dataList[i]);
      }
      print('Top stories: $topList');
      return topList;
    } else {
      print('Failed to load top stories');
      return [];
    }
  }
}