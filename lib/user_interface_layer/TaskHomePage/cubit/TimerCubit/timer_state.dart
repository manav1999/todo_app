part of 'timer_cubit.dart';

@immutable
abstract class TimerState {}

class TimerInitial extends TimerState {
  final Duration time;

  TimerInitial(this.time);
}

class TimerRunning extends TimerState {
  final Duration time;

  TimerRunning(this.time);
}

class TimerPaused extends TimerState {
  final Duration time;

  TimerPaused(this.time);
}

class TimerFinished extends TimerState {}