import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  double _score = 0;
  int? _selectedOptionIndex;
  bool _answerSubmitted = false;
  final Map<int, bool> _answerResults = {};

  void _handleAnswer(int optionIndex) {
    if (_answerSubmitted) return;

    final question = widget.quiz.questions[_currentQuestionIndex];
    final isCorrect = optionIndex == question.correctAnswerIndex;

    setState(() {
      _selectedOptionIndex = optionIndex;
      _answerSubmitted = true;
      _answerResults[_currentQuestionIndex] = isCorrect;
      if (isCorrect) {
        _score += widget.quiz.correctAnswerMarks;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedOptionIndex = null;
          _answerSubmitted = false;
        });
      } else {
        _navigateToResults();
      }
    });
  }

  void _navigateToResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          quiz: widget.quiz,
          score: _score,
          answerResults: _answerResults,
        ),
      ),
    );
  }

  Widget _buildOption(Question question, int index) {
    final option = question.options[index];
    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;

    if (_answerSubmitted) {
      if (index == question.correctAnswerIndex) {
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
      } else if (index == _selectedOptionIndex) {
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
      }
    }

    return Card(
      color: backgroundColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          option.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        onTap: () => _handleAnswer(index),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: _selectedOptionIndex == index
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
      backgroundColor: Colors.grey.shade200,
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).primaryColor,
      ),
      minHeight: 6,
    );
  }

  Widget _buildQuestionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        widget.quiz.questions[_currentQuestionIndex].description,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          ElevatedButton(
            onPressed: _answerSubmitted ? () {
              if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
                setState(() {
                  _currentQuestionIndex++;
                  _selectedOptionIndex = null;
                  _answerSubmitted = false;
                });
              } else {
                _navigateToResults();
              }
            } : null,
            child: Text(
              _currentQuestionIndex < widget.quiz.questions.length - 1
                  ? 'Next Question'
                  : 'Finish Quiz',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: _buildProgressIndicator(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildQuestionHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) =>
                    _buildOption(currentQuestion, index),
              ),
            ),
            _buildNavigationControls(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Current Score: ${_score.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final Quiz quiz;
  final double score;
  final Map<int, bool> answerResults;

  const ResultScreen({
    super.key,
    required this.quiz,
    required this.score,
    required this.answerResults,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${quiz.title} Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${score.toStringAsFixed(1)}/${quiz.questions.length * quiz.correctAnswerMarks}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: score / (quiz.questions.length * quiz.correctAnswerMarks),
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade400,
                      ),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: quiz.questions.length,
                itemBuilder: (context, index) {
                  final question = quiz.questions[index];
                  final isCorrect = answerResults[index] ?? false;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      title: Text(
                        'Question ${index + 1}',
                        style: TextStyle(
                          color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(isCorrect ? 'Correct' : 'Incorrect'),
                      leading: Icon(
                        isCorrect ? Icons.check_circle : Icons.error,
                        color: isCorrect ? Colors.green : Colors.red,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Correct Answer: ${question.options[question.correctAnswerIndex].text}',
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Explanation:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(question.detailedSolution),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}