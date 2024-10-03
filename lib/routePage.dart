import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routeCubit.dart';

class RoutePage extends StatelessWidget {
  final String title;
  final String pageText;
  final int currentRoute;
  static const List<int> routeNumbers = [1, 2, 3];

  const RoutePage({
    super.key,
    required this.title,
    required this.pageText,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final nextRoutes = routeNumbers
        .where((route) => route > currentRoute)
        .map((route) => '/route$route')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: BlocBuilder<RouteCubit, RouteState>(
        builder: (context, state) {
          return Column(
            children: [
              Text(pageText, style: const TextStyle(fontSize: 30)),
              SizedBox(height: 10),
              Text('Count: ${state.count}', style: const TextStyle(fontSize: 30)),
              ElevatedButton(
                onPressed: () {
                  context.read<RouteCubit>().increment();
                },
                child: const Text('Add 1'),
              ),
              SizedBox(height: 30),
              ...nextRoutes.map((route) => ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
                child: Text('Go to $route'),
              )).toList(),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: Navigator.canPop(context) ? () {
                  Navigator.pop(context);
                } : null,
                child: const Text('Go back'),
              ),
            ],
          );
        },
      ),
    );
  }
}