import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'LightsOutCubit.dart';

void main() {
  runApp(const LightsOutApp());
}

class LightsOutApp extends StatelessWidget {
  const LightsOutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lights Out',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => LightsOutCubit(),
        child: const LightsOutHomePage(),
      ),
    );
  }
}

class LightsOutHomePage extends StatefulWidget {
  const LightsOutHomePage({super.key});

  @override
  _LightsOutHomePageState createState() => _LightsOutHomePageState();
}

class _LightsOutHomePageState extends State<LightsOutHomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lights Out'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter number of lights',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final int numberOfLights = int.tryParse(_controller.text) ?? 0;
                context.read<LightsOutCubit>().initializeLights(numberOfLights);
              },
              child: const Text('Initialize Lights'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<LightsOutCubit, LightsOutState>(
              builder: (context, state) {
                return Column(
                  children: [
                    if (state.message != null)
                      Text(state.message!, style: TextStyle(color: Colors.red)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: state.lights
                          .asMap()
                          .entries
                          .map((entry) => IconButton(
                        icon: Icon(
                          Icons.lightbulb,
                          color: entry.value ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: () {
                          context.read<LightsOutCubit>().toggleLight(entry.key);
                        },
                      ))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}