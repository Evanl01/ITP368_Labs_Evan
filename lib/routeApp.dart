import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routeCubit.dart';
import 'routePage.dart';

void main() {
  runApp(const RouteApp());
}

class RouteApp extends StatelessWidget {
  const RouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RouteCubit(),
      child: MaterialApp(
        title: 'Route App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/route1',
        routes: {

          '/route1': (context) => const RoutePage(
            title: 'Route 1',
            pageText: 'Page 1',
            nextRoute: '/route2',
          ),
          '/route2': (context) => const RoutePage(
            title: 'Route 2',
            pageText: 'Page 2',
            nextRoute: '/route3',
          ),
          '/route3': (context) => const RoutePage(
            title: 'Route 3',
            pageText: 'Page 3',
            nextRoute: '/route1',
          ),
        },
      ),
    );
  }
}