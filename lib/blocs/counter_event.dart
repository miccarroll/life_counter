part of 'counter_bloc.dart';

abstract class CounterEvent extends Equatable{
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class LoadCounter extends CounterEvent{}

class ResetLife   extends CounterEvent{}

class AddLife extends CounterEvent{
  final int life;
  final int counterId;
  const AddLife ({required this.life, required this.counterId});

  @override
  List<Object> get props => [life,counterId];
}

class RemoveLife extends CounterEvent{
  final int life;
  final int counterId;
  const RemoveLife ({required this.life, required this.counterId});

  @override
  List<Object> get props => [life,counterId];
}

class ChangeLayout extends CounterEvent{
  final int playerNum;
  const ChangeLayout ({required this.playerNum});

  @override
  List<Object> get props => [playerNum];
}

