import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_counter/blocs/counter_bloc.dart';

import 'package:life_counter/widgets/menus.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, CounterState>(
      buildWhen: (previous, current) {
        if ((previous is CounterLoading && current is CounterLoaded) ||
            (current is CounterLoaded &&
                previous is CounterLoaded &&
                current.counters.length != previous.counters.length)) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state is CounterLoading) {
          return const CircularProgressIndicator();
        } else if (state is CounterLoaded) {
          return const Scaffold(
            body: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: PlayerBox(
                                color: Colors.white, angle: 90, id: 0),
                          ),
                          Expanded(
                            flex: 1,
                            child: PlayerBox(
                                color: Colors.black, angle: -90, id: 1),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child:
                            PlayerBox(color: Colors.red, angle: 90, id: 2),
                          ),
                          Expanded(
                            flex: 1,
                            child: PlayerBox(
                                color: Colors.blue, angle: -90, id: 3),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                CenterMenu(),
              ],
            ),
          );
        } else {
          return const Text("I fucked up :(");
        }
      },
    );
  }
}

class PlayerBox extends StatelessWidget {
  const PlayerBox({super.key,
    this.color = const Color(0xFFFFFFFF),
    this.angle = 360,
    required this.id});

  final Color color;
  final int angle;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              color: color),
          child: Center(
            child: Transform.rotate(
              angle: (angle / 180) * pi,
              child: BlocBuilder<CounterBloc, CounterState>(
                buildWhen: (previous, current) {
                  return (previous is CounterLoaded &&
                      current is CounterLoaded &&
                      (previous
                          .getCounter(id)
                          .life !=
                          current
                              .getCounter(id)
                              .life));
                },
                builder: (context, state) {
                  if (state is CounterLoaded) {
                    return Stack(
                      children: <Widget>[
                        Text(
                          state.counters[id].life.toString(),
                          style: TextStyle(
                            fontSize: 60,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          state.counters[id].life.toString(),
                          style: const TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: BlocListener<CounterBloc, CounterState>(
                listener: (context, state) {},
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    //print("hit");
                    context.read<CounterBloc>().add(
                      AddLife(life: 1, counterId: id),
                    );
                  },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      width: 25,
                      height: 25,
                      child: Transform.rotate(
                        angle: (angle / 180) * pi,
                        child: const Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "+",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  //print("hit");
                  context.read<CounterBloc>().add(
                    RemoveLife(life: 1, counterId: id),
                  );
                },
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    width: 25,
                    height: 25,
                    child: Transform.rotate(
                      angle: (angle / 180) * pi,
                      child: const Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "-",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
