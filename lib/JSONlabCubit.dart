import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JSONlabState {
  final List<dynamic> launches;
  JSONlabState(this.launches);
}

class JSONlabCubit extends Cubit<JSONlabState> {
  List<dynamic> allLaunches = [];

  JSONlabCubit() : super(JSONlabState([]));

  void fetchLaunches() async {
    final url = Uri.parse('https://api.spacexdata.com/v4/launches');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      allLaunches = jsonDecode(response.body);
      allLaunches.sort((a, b) => DateTime.parse(b['date_utc']).compareTo(DateTime.parse(a['date_utc'])));
      emit(JSONlabState(allLaunches));
    } else {
      emit(JSONlabState([]));
    }
  }

  void filterLaunches(DateTime startDate, DateTime endDate) {
    final filteredLaunches = allLaunches.where((launch) {
      final launchDate = DateTime.parse(launch['date_utc']);
      return launchDate.isAfter(startDate) && launchDate.isBefore(endDate);
    }).toList();
    emit(JSONlabState(filteredLaunches));
  }
}