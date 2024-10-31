import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitter/app.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    "Adding a Tweet.",
    ($) async {
      await $.pumpWidgetAndSettle(TwitterApp());

      await $(#TextFieldAuthorName).enterText('Mathias Müller');

      await $(#TextFieldTweetText).enterText('Das ist der TweetText');

      await $.pump(Duration(milliseconds: 4000));

      await $('Add a your Tweet').tap();

      await $.pump(Duration(milliseconds: 2000));

      expect($(ListView).$('Das ist der TweetText'), findsOneWidget);
    },
  );
}
