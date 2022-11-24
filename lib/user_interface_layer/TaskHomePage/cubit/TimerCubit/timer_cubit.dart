import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState>  {
  final Duration time;
   Duration remainingTime = Duration.zero;

  Timer? timer;
  TimerCubit(this.time) : super(TimerInitial(time));
  
  void startTimer(){
    if(timer?.isActive??false)
      {
        timer?.cancel();
      }
    remainingTime = time;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _setCountDown();
    });
  }

  void _setCountDown() {
    const reduceSecondsBy = 1;
     remainingTime = Duration(seconds: remainingTime.inSeconds - reduceSecondsBy);
     print(remainingTime.inSeconds);
    if (remainingTime.inSeconds <= 0) {
      timer!.cancel();
      emit(TimerRunning(remainingTime));

    } else {
      emit(TimerRunning(remainingTime));
    }
  }

  void pauseTimer() {
    timer?.cancel();
    emit(TimerPaused(remainingTime));
  }


  void resumeTime()
  {
    if(timer?.isActive??false)
    {
      timer?.cancel();
    }
    
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _setCountDown();
    });
  }

  void resetTimer(){
    remainingTime = Duration.zero;
    startTimer();
  }

}
