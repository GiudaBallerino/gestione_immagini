part of 'home_cubit.dart';

enum HomeTab { gallery, settings }

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.gallery,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}