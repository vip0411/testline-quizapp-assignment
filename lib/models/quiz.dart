// lib/models/quiz.dart
class Quiz {
  final String title;
  final String topic;
  final int questionsCount;
  final double correctAnswerMarks;
  final List<Question> questions;

  Quiz({
    required this.title,
    required this.topic,
    required this.questionsCount,
    required this.correctAnswerMarks,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      title: json['title'] ?? 'Untitled Quiz',
      topic: json['topic'] ?? 'General Topic',
      questionsCount: json['questions_count'] ?? 0,
      correctAnswerMarks: double.tryParse(json['correct_answer_marks'] ?? '4.0') ?? 4.0,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}

class Question {
  final String description;
  final List<Option> options;
  final int correctAnswerIndex;
  final String detailedSolution;

  Question({
    required this.description,
    required this.options,
    required this.correctAnswerIndex,
    required this.detailedSolution,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List)
        .map((o) => Option.fromJson(o))
        .toList();

    final correctIndex = options.indexWhere((o) => o.isCorrect);

    return Question(
      description: json['description'] ?? '',
      options: options,
      correctAnswerIndex: correctIndex != -1 ? correctIndex : 0,
      detailedSolution: json['detailed_solution'] ?? 'No solution available',
    );
  }
}

class Option {
  final String text;
  final bool isCorrect;

  Option({
    required this.text,
    required this.isCorrect,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['description'] ?? 'Invalid option',
      isCorrect: json['is_correct'] ?? false,
    );
  }
}