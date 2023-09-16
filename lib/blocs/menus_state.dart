part of 'menus_bloc.dart';

abstract class MenusState extends Equatable{
  @override
  List<Object?> get props => [];
}

class MenusLoading extends MenusState{}

class MenusLoaded extends MenusState {
  bool centerOpen;
  bool playersOpen;

  MenusLoaded({this.centerOpen = false,this.playersOpen = false});

  @override
  List<Object?> get props =>[centerOpen,playersOpen];

}
