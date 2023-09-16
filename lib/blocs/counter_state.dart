part of 'counter_bloc.dart';

abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object> get props => [];
}

class CounterLoading extends CounterState {}

class CounterLoaded extends CounterState {
  final List<Counter> counters;
  final int baseLife;

  CounterLoaded({required this.counters, required this.baseLife});

  Counter getCounter(int id) {
    return counters.firstWhere((counter) => counter.id == id);
  }

  CounterLoaded clone() {
    List<Counter> newCounters = [];
    counters.forEach((counter) =>
        newCounters.add(Counter(life: counter.life, id: counter.id)));
    return CounterLoaded(counters: newCounters,baseLife: baseLife);
  }

  @override
  List<Object> get props => [counters];
}
