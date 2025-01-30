import 'package:flutter/material.dart';
import '/services/quiz_service.dart';
import 'quiz_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _isLoading = false;
  String _error = '';

  Future<void> _startQuiz() async {
    setState(() {
      _isLoading = true;
      _error = '';  // Clear any previous errors
    });
    try {
      final quiz = await QuizService().fetchQuiz();
      if (!mounted) return;  // Check if widget is still mounted
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizScreen(quiz: quiz),
        ),
      );
    } catch (e) {
      setState(() { _error = 'Failed to load quiz. Please try again.'; });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
              Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.psychology,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quiz App',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Test your knowledge!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 48),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _startQuiz,
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        surfaceTintColor: Colors.yellow,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (_error.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      _error,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}