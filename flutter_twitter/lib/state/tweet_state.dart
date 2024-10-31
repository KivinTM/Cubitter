part of 'package:flutter_twitter/cubit/tweet_cubit.dart';

abstract class TweetState extends Equatable {
  final List<Tweet> tweets;

  const TweetState({this.tweets = const []});

  @override
  List<Object> get props => [tweets];
}

class TweetInitial extends TweetState {}

class TweetEmpty extends TweetState {
  const TweetEmpty();
}

class AddingTweet extends TweetState {
  const AddingTweet({required List<Tweet> tweets}) : super(tweets: tweets);
}

class TweetLoaded extends TweetState {
  const TweetLoaded({required List<Tweet> tweets}) : super(tweets: tweets);
}

class TweetDeleted extends TweetState {
  const TweetDeleted({required List<Tweet> tweets}) : super(tweets: tweets);
}

class TweetError extends TweetState {
  final String message;

  const TweetError({required this.message});

  @override
  List<Object> get props => [message, tweets];
}
