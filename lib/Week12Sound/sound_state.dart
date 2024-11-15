import 'dart:typed_data';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundState {
  FlutterSoundRecorder recorder;
  FlutterSoundPlayer player;
  bool isRecording;
  List<Uint8List?> buffers; // List to store buffers for 5 sounds
  StreamController<Uint8List> streamController;

  SoundState({
    required this.recorder,
    required this.player,
    required this.isRecording,
    required this.buffers,
    required this.streamController,
  });

  SoundState.init()
      : recorder = FlutterSoundRecorder(),
        player = FlutterSoundPlayer(),
        isRecording = false,
        buffers = List<Uint8List?>.filled(5, null),
        streamController = StreamController<Uint8List>();
}

class SoundCubit extends Cubit<SoundState> {
  SoundCubit() : super(SoundState.init());

  Future<void> startRecording(int index) async {
    final PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print("Microphone permission not granted");
      return;
    }

    try {
      await state.recorder.openRecorder();
      await state.recorder.startRecorder(
        codec: Codec.aacADTS, // Use a supported codec
        toStream: state.streamController.sink,
      );
      state.streamController.stream.listen((buffer) {
        state.buffers[index] = buffer;
      });
      print("Recording started");
      emit(SoundState(
        recorder: state.recorder,
        player: state.player,
        isRecording: true,
        buffers: state.buffers,
        streamController: state.streamController,
      ));
    } catch (e) {
      print("Error starting recorder: $e");
    }
  }

  Future<void> stopRecording(int index) async {
    try {
      await state.recorder.stopRecorder();
      print("Recording stopped");
      emit(SoundState(
        recorder: state.recorder,
        player: state.player,
        isRecording: false,
        buffers: state.buffers,
        streamController: state.streamController,
      ));
    } catch (e) {
      print("Error stopping recorder: $e");
    }
  }

  Future<void> playRecording(int index) async {
    final buffer = state.buffers[index];
    if (buffer != null) {
      try {
        await state.player.startPlayer(
          fromDataBuffer: buffer,
          codec: Codec.aacADTS, // Use the same codec as recording
        );
        print("Playing recording");
      } catch (e) {
        print("Error playing recording: $e");
      }
    } else {
      print("No recording found at index $index");
    }
  }

  Future<void> stopPlaying() async {
    try {
      await state.player.stopPlayer();
      print("Playback stopped");
    } catch (e) {
      print("Error stopping playback: $e");
    }
  }
}