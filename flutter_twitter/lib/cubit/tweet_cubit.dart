import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_twitter/tweet.dart';
part 'package:flutter_twitter/state/tweet_state.dart';

class TweetCubit extends Cubit<TweetState> {
  TweetCubit() : super(TweetInitial());

  final Random random = Random();
  final List<String> authors = ["Thomas", "Hebert", "Erwin"];
  final List<String> messages = [
    "Hallo Welt!",
    "Bin neu hier.",
    "X.com war gestern, ab heute nur noch cubitter",
    "Creative Test Message 1",
    "Diese Nachricht wurde nicht randomized."
  ];

  void initializeTweet() {
    if (state is TweetInitial) {
      Future.delayed(Duration(seconds: 2), () {
        emit(TweetEmpty());
      }).catchError((error) {
        emit(TweetError(
            message: "Failed to initialize Tweets: ${error.toString()}"));
      });
    }
  }

  void addUserTweet(String author, String message) {
    if ((state is TweetLoaded || state is TweetEmpty) &&
        message.isNotEmpty &&
        author.isNotEmpty) {
      try {
        final List<Tweet> currentTweets =
            (state is TweetLoaded) ? (state as TweetLoaded).tweets : [];
        emit(AddingTweet(tweets: currentTweets));

        final Tweet userTweet = Tweet(author, message, DateTime.now());
        final List<Tweet> newTweets = List.from(currentTweets)..add(userTweet);

        Future.delayed(Duration(seconds: 2), () {
          emit(TweetLoaded(tweets: newTweets));
        });
      } catch (error) {
        emit(TweetError(
            message: "Failed to add user tweet: ${error.toString()}"));
        _fallbackToPreviousState();
      }
    } else {
      emit(
          TweetError(message: "Invalid state or empty input for adding tweet"));
      _fallbackToPreviousState();
    }
  }

  void deleteSpecificTweet(int index) {
    if (state is TweetLoaded) {
      try {
        final List<Tweet> currentTweets = (state as TweetLoaded).tweets;
        if (index >= 0 && index < currentTweets.length) {
          final List<Tweet> newTweets = List.from(currentTweets)
            ..removeAt(index);

          emit(TweetDeleted(tweets: currentTweets));
          Future.delayed(Duration(seconds: 2), () {
            emit(newTweets.isEmpty
                ? TweetEmpty()
                : TweetLoaded(tweets: newTweets));
          });
        } else {
          emit(TweetError(message: "Invalid tweet index: $index"));
        }
      } catch (error) {
        emit(TweetError(
            message: "Failed to delete specific tweet: ${error.toString()}"));
        _fallbackToPreviousState();
      }
    } else {
      emit(TweetError(message: "Attempted to delete tweet in invalid state"));
      _fallbackToPreviousState();
    }
  }

  void addRandomTweet() {
    if (state is TweetLoaded || state is TweetEmpty) {
      try {
        final List<Tweet> currentTweets =
            (state is TweetLoaded) ? (state as TweetLoaded).tweets : [];
        emit(AddingTweet(tweets: currentTweets));

        final Tweet tweet = Tweet(
          authors[random.nextInt(authors.length)],
          messages[random.nextInt(messages.length)],
          DateTime(2012 + random.nextInt(12)),
        );

        final List<Tweet> newTweets = List.from(currentTweets)..add(tweet);
        Future.delayed(Duration(seconds: 2), () {
          emit(TweetLoaded(tweets: newTweets));
        });
      } catch (error) {
        emit(TweetError(
            message: "Failed to add random tweet: ${error.toString()}"));
        _fallbackToPreviousState();
      }
    } else {
      emit(TweetError(message: "Invalid state for adding random tweet"));
      _fallbackToPreviousState();
    }
  }

  void clearTweets() {
    if (state is TweetLoaded) {
      emit(TweetEmpty());
    } else if (state is TweetEmpty) {
      emit(TweetError(message: "No tweets to clear"));
      emit(TweetEmpty());
    } else {
      emit(TweetError(message: "Attempted to clear tweets in invalid state"));
      emit(TweetInitial());
    }
  }

  void _fallbackToPreviousState() {
    if (state is TweetLoaded && (state as TweetLoaded).tweets.isNotEmpty) {
      emit(TweetLoaded(tweets: (state as TweetLoaded).tweets));
    } else {
      emit(TweetEmpty());
    }
  }
}
