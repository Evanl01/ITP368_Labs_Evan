import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routeCubit.dart';

class RoutePage extends StatelessWidget {
  final String title;
  final String pageText;
  final String nextRoute;

  const RoutePage({
    super.key,
    required this.title,
    required this.pageText,
    required this.nextRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<RouteCubit, RouteState>(
        builder: (context, state) {
          return Column(
            children: [
              Text(pageText, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 10),

              Text('${state.count}', style: const TextStyle(fontSize: 30)),
              ElevatedButton(
                onPressed: () {
                  context.read<RouteCubit>().increment();
                },
                child: const Text('Add 1'),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, nextRoute);
                },
                child: Text('Go to $nextRoute'),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back'),
              ),
            ],
          );
        },
      ),
    );
  }
}