import 'package:flutter/material.dart';
import 'package:flutter_twitter/tweet.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this import
import 'package:flutter_twitter/cubit/tweet_cubit.dart';

class TweetWidget extends StatelessWidget {
  final Tweet tweet;
  final int index;

  const TweetWidget({Key? key, required this.tweet, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tweet.author,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  DateFormat('dd MM yyyy, hh:mm a').format(tweet.date),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(tweet.message),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (context.read<TweetCubit>().state is TweetLoaded) {
                    context.read<TweetCubit>().deleteSpecificTweet(index);
                  }
                },
                child: Text("Delete Tweet"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
