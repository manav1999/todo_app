part of 'view_toggle_cubit.dart';

@immutable
abstract class ViewToggleState {}

class ViewToggleInitial extends ViewToggleState {}


class GridViewState extends ViewToggleState {}

class ListViewState extends ViewToggleState {}