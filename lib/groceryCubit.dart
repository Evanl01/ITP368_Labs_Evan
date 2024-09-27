import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider_linux/path_provider_linux.dart';
import 'dart:io';
import 'dart:async';

class GroceryState {
  final List<String> groceries;
  final String? message;

  GroceryState(this.groceries, {this.message});
}

class GroceryCubit extends Cubit<GroceryState> {
  GroceryCubit() : super(GroceryState([])) {
    _loadGroceries();
  }

  Future<void> _loadGroceries() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print('directory: $directory');

      final directoryPath = directory.path;
      final file = File('${directory.path}/grocery.txt');
      print('file: $file');
      print('directory.path: $directoryPath');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final groceries = contents.split('\n').where((item) => item.isNotEmpty).toList();
        emit(GroceryState(groceries));
      } else {
        await file.create();
        await file.writeAsString('');
        emit(GroceryState([]));
      }
    } catch (e) {
      print('Error: $e');
      emit(GroceryState([], message: 'Error loading groceries'));
    }
  }

  Future<void> addGrocery(String grocery) async {
    final updatedGroceries = List<String>.from(state.groceries)..add(grocery);
    emit(GroceryState(updatedGroceries));
    await _saveGroceries(updatedGroceries);
  }

  Future<void> _saveGroceries(List<String> groceries) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/grocery.txt');
      await file.writeAsString(groceries.join('\n'));
    } catch (e) {
      emit(GroceryState(state.groceries, message: 'Error saving groceries'));
    }
  }
}