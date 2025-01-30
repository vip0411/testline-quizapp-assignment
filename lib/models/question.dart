class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correct'],
    );
  }
}