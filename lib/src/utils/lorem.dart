import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoremText {
  LoremText({math.Random? random}) : random = random ?? math.Random(978);

  final math.Random random;

  static final List<String> words =
  'ad adipiscing aliqua aliquip amet anim aute cillum commodo consectetur consequat culpa cupidatat deserunt do dolor dolore duis ea eiusmod elit enim esse est et eu ex excepteur exercitation fugiat id in incididunt ipsum irure labore laboris laborum lorem magna minim mollit nisi non nostrud nulla occaecat officia pariatur proident qui quis reprehenderit sed sint sit sunt tempor ullamco ut velit veniam voluptate'
      .split(' ');

  String word() {
    return words[random.nextInt(words.length - 1)];
  }

  String sentence(int length) {
    final wordList = <String>[];
    for (var i = 0; i < length; i++) {
      var w = word();
      if (i < length - 1 && random.nextInt(10) == 0) {
        w += ',';
      }
      wordList.add(w);
    }
    final text = '${wordList.join(' ')}.';
    return text[0].toUpperCase() + text.substring(1);
  }

  String paragraph(int length) {
    var wordsCount = 0;
    final sentenceList = <String>[];
    var n = 0;
    while (wordsCount < length) {
      n++;
      if (n > 100) {
        break;
      }
      final count = math.min(length,
          math.max(10, math.min(3, random.nextInt(length - wordsCount))));
      sentenceList.add(sentence(count));
      wordsCount += count;
    }
    return sentenceList.join(' ');
  }
}


class Lorem extends StatelessWidget {
  Lorem(
      {this.length = 50,
        this.random,
        this.style,
        this.textAlign = TextAlign.left,
        this.softWrap = true,
        this.textScaleFactor = 1.0,
        this.maxLines});

  final int length;
  final math.Random? random;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool softWrap;
  final double textScaleFactor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final lorem = LoremText(random: random);
    final text = lorem.paragraph(length);

    return Text(text,
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines);
  }
}