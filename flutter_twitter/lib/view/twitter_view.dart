import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/cubit/tweet_cubit.dart';
import 'package:flutter_twitter/view/tweet_widget.dart';

class TwitterView extends StatelessWidget {
  const TwitterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authorController = TextEditingController();
    final tweetTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Cubitter"),
        elevation: 2,
        shadowColor: Colors.black,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: BlocBuilder<TweetCubit, TweetState>(
                  builder: (context, state) {
                    if (state is TweetInitial) {
                      context.read<TweetCubit>().initializeTweet();
                      return Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("No Tweets Yet"),
                            Text(state.toString())
                          ],
                        ),
                      );
                    } else if (state is TweetEmpty) {
                      return Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No tweets available."),
                          Text(state.toString())
                        ],
                      ));
                    } else if (state is AddingTweet) {
                      return CircularProgressIndicator();
                    } else if (state is TweetDeleted) {
                      return CircularProgressIndicator();
                    } else if (state is TweetError) {
                      return Text("Error: ${state.message}");
                    } else if (state is TweetLoaded) {
                      return Container(
                        child: ListView.builder(
                          itemCount: state.tweets.length,
                          itemBuilder: (context, index) {
                            final tweet = state.tweets[index];
                            return TweetWidget(tweet: tweet, index: index);
                          },
                        ),
                      );
                    } else {
                      return Text("Unknown state");
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    key: Key("TextFieldAuthorName"),
                    decoration: InputDecoration(labelText: 'Write your Name!'),
                    controller: authorController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    key: Key("TextFieldTweetText"),
                    decoration: InputDecoration(labelText: 'Write your Tweet!'),
                    controller: tweetTextController,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (context.read<TweetCubit>().state
                                    is TweetLoaded ||
                                context.read<TweetCubit>().state
                                    is TweetEmpty) {
                              context.read<TweetCubit>().addUserTweet(
                                  authorController.text,
                                  tweetTextController.text);
                            }
                          },
                          child: Text("Add a your Tweet"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (context.read<TweetCubit>().state
                                    is TweetLoaded ||
                                context.read<TweetCubit>().state
                                    is TweetEmpty) {
                              context.read<TweetCubit>().addRandomTweet();
                            }
                          },
                          child: Text("Add a random Tweet"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (context.read<TweetCubit>().state
                                    is TweetLoaded ||
                                context.read<TweetCubit>().state
                                    is TweetEmpty) {
                              context.read<TweetCubit>().clearTweets();
                            }
                          },
                          child: Text("Clear all Tweets"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
