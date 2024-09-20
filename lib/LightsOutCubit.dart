import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class LightsOutState {
  final List<bool> lights;
  final String? message;

  LightsOutState(this.lights, {this.message});
}

class LightsOutCubit extends Cubit<LightsOutState> {
  LightsOutCubit() : super(LightsOutState([]));

  void initializeLights(int numberOfLights) {
    if (numberOfLights < 3 || numberOfLights > 15) {
      emit(LightsOutState(state.lights, message: 'Error: numberOfLights must be between 3 and 15.'));
      return;
    }
    final random = Random();
    final lights = List<bool>.generate(numberOfLights, (_) => random.nextBool());
    emit(LightsOutState(lights));
  }

  void toggleLight(int index) {
    final lights = List<bool>.from(state.lights);
    lights[index] = !lights[index];
    if (index > 0) {
      lights[index - 1] = !lights[index - 1];
    }
    if (index < lights.length - 1) {
      lights[index + 1] = !lights[index + 1];
    }
    String? message;
    if (lights.every((light) => !light)) {
      message = 'Success. All lights out!';
    }
    emit(LightsOutState(lights, message: message));
  }
}