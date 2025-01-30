import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';

class QuizService {
  Future<Quiz> fetchQuiz() async {
    final response = await http.get(Uri.parse('https://api.jsonserve.com/Uw5CrX'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Quiz.fromJson(data);
    } else {
      throw Exception('Failed to load quiz');
    }
  }
}