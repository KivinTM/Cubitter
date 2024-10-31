import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_twitter/cubit/tweet_cubit.dart';
import 'package:flutter_twitter/view/twitter_view.dart';

class TwitterPage extends StatelessWidget {
  const TwitterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TweetCubit(),
      child: const TwitterView(),
    );
  }
}
