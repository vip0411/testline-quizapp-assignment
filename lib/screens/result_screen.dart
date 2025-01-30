import 'package:flutter/material.dart';
import '../models/quiz.dart';

class ResultScreen extends StatelessWidget {
  final Quiz quiz;
  final double score;

  const ResultScreen({super.key, required this.quiz, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Your Score: ${score.toStringAsFixed(1)}'),
          Expanded(
            child: ListView.builder(
              itemCount: quiz.questions.length,
              itemBuilder: (ctx, index) {
                final question = quiz.questions[index];
                return ExpansionTile(
                  title: Text(question.description),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(question.detailedSolution),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}