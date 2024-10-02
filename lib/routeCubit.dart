import 'package:bloc/bloc.dart';

class RouteState {
  final int count;
  const RouteState(this.count);
}

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(const RouteState(0));

  void increment() {
    emit(RouteState(state.count + 1));
  }
}