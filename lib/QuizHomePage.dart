import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'QuizCubit.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Capitals Quiz',
      home: BlocProvider(
        create: (context) => QuizCubit()..loadQuestions(),
        child: QuizHomePage(),
      ),
    );
  }
}
class QuizHomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('State Capitals Quiz')),
      body: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state.userAnswer.isEmpty) {
            _controller.clear();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('State: ${state.state}', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Text('Capital:', style: TextStyle(fontSize: 24)),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type answer here',
                  ),
                  onChanged: (value) {
                    context.read<QuizCubit>().updateUserAnswer(value);
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.answerRevealed
                            ? null
                            : () => context.read<QuizCubit>().checkAnswer(state.userAnswer),
                        child: Text('Check Answer'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.answerRevealed
                            ? null
                            : () => context.read<QuizCubit>().showAnswer(state.userAnswer),
                        child: Text('Show Answer'),
                      ),
                    ),


                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.nextQuestionEnabled
                            ? () => context.read<QuizCubit>().nextQuestion()
                            : null,
                        child: Text('Next Question'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  state.answerRevealed
                      ? (state.userAnswer.toLowerCase() == state.capital.toLowerCase()
                      ? 'Correct!'
                      : 'Wrong. Answer is ${state.capital}.')
                      : '',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
                SizedBox(height: 16),
                Text(
                  'Score: ${state.correctAnswers} / ${state.totalQuestions}',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}