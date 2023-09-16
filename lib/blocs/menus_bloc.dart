import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'menus_event.dart';
part 'menus_state.dart';

class MenusBloc extends Bloc<MenusEvent, MenusState> {
  MenusBloc() : super(MenusLoaded()) {
    on<LoadMenus>(_onLoadMenus);
    on<ToggleCenter>(_onToggleCenter);
    on<TogglePlayers>(_onTogglePlayers);

  }

  void _onLoadMenus (LoadMenus event, Emitter<MenusState> emit){
    final state = this.state;
    if(state is MenusLoading){
        emit(MenusLoaded(centerOpen: false, playersOpen: false));
    }
  }

  void _onToggleCenter (ToggleCenter event, Emitter<MenusState> emit){
    final state = this.state;
    if(state is MenusLoaded){
      if(state.centerOpen == true){
        emit(MenusLoaded(centerOpen: false, playersOpen: false));
      }else{
        emit(MenusLoaded(centerOpen: true, playersOpen: false));
      }
    }
  }

  void _onTogglePlayers (TogglePlayers event, Emitter<MenusState> emit){
    final state = this.state;
    if(state is MenusLoaded){
      if(state.playersOpen == true){
        emit(MenusLoaded(centerOpen: state.centerOpen, playersOpen: false));
      }else{
        emit(MenusLoaded(centerOpen: true, playersOpen: true));
      }
    }
  }

  /*void _onClosedCenter(ClosedCenter event, Emitter<MenusState> emit) {
    final state = this.state;
    if(state is MenusLoaded){
      if(state.centerOpen == false){
        emit(MenusLoaded(centerOpen: false, playersOpen: false, centerClosing: false, playersClosing: false));
      }
    }
  }

  void _onClosedPlayer(ClosedPlayer event, Emitter<MenusState> emit) {
    final state = this.state;
    if(state is MenusLoaded){
      if(state.playersOpen == false){
        emit(MenusLoaded(centerOpen: state.centerOpen, playersOpen: false, centerClosing: state.centerClosing, playersClosing: false));
      }
    }
  }*/


}
