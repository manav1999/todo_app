import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'view_toggle_state.dart';

class ViewToggleCubit extends Cubit<ViewToggleState> {
  ViewToggleCubit() : super(ViewToggleInitial()) {
    emit(GridViewState());
  }

  bool isGridView = true;

  void toggleView() {
    if (isGridView) {
      emit(ListViewState());
    } else {
      emit(GridViewState());
    }
    isGridView = !isGridView;
  }
}
