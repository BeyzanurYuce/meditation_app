import 'package:flutter/material.dart';


class QuoteWidget extends StatelessWidget {
  var quote = "";
  var author = "";
  var onShareClick;
  var onLikeClick;
  var bgColor;


  QuoteWidget({this.bgColor,required this.quote, required this.author, this.onShareClick, this.onLikeClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      padding: EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(
            flex: 2,
          ),

          Image.asset(
            'assets/images/quote.png',
            height: 30,
            width: 30,
            color: Colors.white,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            quote,
            style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 25),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            author,
            style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 25),
            ),

          Spacer(),
        ],
      ),
    );
  }
}
