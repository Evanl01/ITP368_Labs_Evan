import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path_provider_linux/path_provider_linux.dart';
import 'groceryCubit.dart';
import 'dart:async';

void main() {
  runApp(const GroceryApp());
}

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => GroceryCubit(),
        child: const GroceryHomePage(),
      ),
    );
  }
}

class GroceryHomePage extends StatefulWidget {
  const GroceryHomePage({super.key});

  @override
  _GroceryHomePageState createState() => _GroceryHomePageState();
}

class _GroceryHomePageState extends State<GroceryHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<GroceryCubit, GroceryState>(
              builder: (context, state) {
                return Flexible(
                  child: Column(
                    children: [
                      if (state.message != null)
                        Text(state.message!, style: TextStyle(color: Colors.red)),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.groceries.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(state.groceries[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter grocery item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final grocery = _controller.text;
                if (grocery.isNotEmpty) {
                  context.read<GroceryCubit>().addGrocery(grocery);
                  _controller.clear();
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}