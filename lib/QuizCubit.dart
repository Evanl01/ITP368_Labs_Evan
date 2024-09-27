import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class QuizState {
  final String state;
  final String capital;
  final String userAnswer;
  final bool answerRevealed;
  final int correctAnswers;
  final int totalQuestions;
  final bool nextQuestionEnabled;

  QuizState({
    required this.state,
    required this.capital,
    this.userAnswer = '',
    this.answerRevealed = false,
    this.correctAnswers = 0,
    this.totalQuestions = 0,
    this.nextQuestionEnabled = false,
  });

}

class QuizCubit extends Cubit<QuizState> {
  List<Map<String, String>> questions = [];
  List<int> shownQuestions = [];
  final Random _random = Random();

  QuizCubit() : super(QuizState(state: '', capital: ''));

  Future<void> loadQuestions() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/answers.txt');
      final lines = await file.readAsLines();

      for (var line in lines.skip(1)) {
        final parts = line.split(';');
        questions.add({'state': parts[0], 'capital': parts[1]});
      }

      if (questions.isNotEmpty) {
        _nextRandomQuestion();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void showAnswer(String answer) {
    checkAnswer(answer);
  }

  void updateUserAnswer(String answer) {
    emit(QuizState(
      state: state.state,
      capital: state.capital,
      userAnswer: answer,
      answerRevealed: state.answerRevealed,
      correctAnswers: state.correctAnswers,
      totalQuestions: state.totalQuestions,
      nextQuestionEnabled: state.nextQuestionEnabled,
    ));
  }

  void checkAnswer(String answer) {
    final isCorrect = answer.toLowerCase() == state.capital.toLowerCase();
    final correctAnswers = isCorrect ? state.correctAnswers + 1 : state.correctAnswers;

    emit(QuizState(
      state: state.state,
      capital: state.capital,
      userAnswer: answer,
      answerRevealed: true,
      correctAnswers: correctAnswers,
      totalQuestions: state.totalQuestions + 1,
      nextQuestionEnabled: true,
    ));
  }

  void nextQuestion() {
    _nextRandomQuestion();
    emit(QuizState(
      state: state.state,
      capital: state.capital,
      userAnswer: '',
      answerRevealed: false,
      correctAnswers: state.correctAnswers,
      totalQuestions: state.totalQuestions,
      nextQuestionEnabled: false,
    ));
  }

  void _nextRandomQuestion() {
    if (shownQuestions.length == questions.length) {
      shownQuestions.clear(); // Reset if all questions have been shown
    }

    int randomIndex;
    do {
      randomIndex = _random.nextInt(questions.length);
    } while (shownQuestions.contains(randomIndex));

    shownQuestions.add(randomIndex);

    emit(QuizState(
      state: questions[randomIndex]['state']!,
      capital: questions[randomIndex]['capital']!,
      correctAnswers: state.correctAnswers,
      totalQuestions: state.totalQuestions,
    ));
  }
}