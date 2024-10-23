import 'package:bloc/bloc.dart';

class RouteState {
  final int count;
  RouteState(this.count);
}

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(RouteState(0));

  void increment() {
    emit(RouteState(state.count + 1));
  }
}