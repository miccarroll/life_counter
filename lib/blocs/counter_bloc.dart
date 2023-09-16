import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:life_counter/modules/Counter_Module.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterLoading()) {
    on<LoadCounter>(_onLoadCounter);
    on<AddLife>(_onAddLife);
    on<RemoveLife>(_onRemoveLife);
    on<ResetLife>(_onResetLife);
    on<ChangeLayout>(_onChangeLayout);
  }

  void _onLoadCounter(LoadCounter event, Emitter<CounterState> emit) {
    emit(
      CounterLoaded(counters: <Counter>[
        Counter(life: 40, id: 0),
        Counter(life: 40, id: 1),
        Counter(life: 40, id: 2),
        Counter(life: 40, id: 3),
      ],baseLife: 40),
    );
  }

  void _onAddLife(AddLife event, Emitter<CounterState> emit) {
    final state = this.state;
    if (state is CounterLoaded) {
      CounterLoaded newState = state.clone();
      newState.getCounter(event.counterId).life += event.life;
      emit(newState);
    }
  }

  void _onRemoveLife(RemoveLife event, Emitter<CounterState> emit) {
    final state = this.state;
    if (state is CounterLoaded) {
      CounterLoaded newState = state.clone();
      newState.getCounter(event.counterId).life -= event.life;
      emit(newState);
    }
  }

  void _onResetLife(ResetLife event, Emitter<CounterState> emit){
    final state = this.state;
    if (state is CounterLoaded) {
      CounterLoaded newState = state.clone();
      newState.counters.forEach((counter) {
        counter.life = newState.baseLife;
      });
      emit(newState);
    }
  }

  void _onChangeLayout(ChangeLayout event, Emitter<CounterState> emit) {
    final state = this.state;
    if (state is CounterLoaded) {
      CounterLoaded newState = CounterLoaded(counters: const <Counter>[], baseLife: state.baseLife);
      for(int i = 0; i < event.playerNum;i++){
        Counter newCounter = Counter(id:i,life: newState.baseLife);
        newState.counters.add(newCounter);
      }
      emit(newState);
    }
  }
}
