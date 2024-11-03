import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'newsItem.dart';
import 'package:flutter/gestures.dart';

class NewsItemPage extends StatelessWidget {
  final NewsItem newsItem;

  NewsItemPage({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(newsItem.headline)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsItem.headline,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: 'Note: hacker-news API often does not provide the full story text, only an external URL to the story. If the story below is blank, ',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                children: [
                  TextSpan(
                    text: 'click here.',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunch(newsItem.url)) {
                          await launch(newsItem.url);
                        } else {
                          throw 'Could not launch ${newsItem.url}';
                        }
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              newsItem.text,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}