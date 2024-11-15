import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sound_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const SayWhat());
}

class SayWhat extends StatelessWidget {
  const SayWhat({super.key});

  @override
  Widget build(BuildContext context) {
    const title = "record demo";
    return MaterialApp(
      title: title,
      home: BlocProvider<SoundCubit>(
        create: (context) => SoundCubit(),
        child: BlocBuilder<SoundCubit, SoundState>(
          builder: (context, state) {
            return SayWhat1(title: title);
          },
        ),
      ),
    );
  }
}

class SayWhat1 extends StatelessWidget {
  final String title;
  const SayWhat1({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    SoundCubit sc = BlocProvider.of<SoundCubit>(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text('Sound ${index + 1}'),
              ElevatedButton(
                onPressed: () {
                  sc.startRecording(index);
                },
                child: Text("record"),
              ),
              ElevatedButton(
                onPressed: () {
                  sc.stopRecording(index);
                },
                child: Text("stop rec"),
              ),
              ElevatedButton(
                onPressed: () {
                  sc.playRecording(index);
                },
                child: Text("play"),
              ),
              ElevatedButton(
                onPressed: () {
                  sc.stopPlaying();
                },
                child: Text("stop play"),
              ),
            ],
          );
        },
      ),
    );
  }
}