import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_counter/blocs/counter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:life_counter/blocs/menus_bloc.dart';

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

class CenterMenu extends StatefulWidget {
  const CenterMenu({
    super.key,
  });

  @override
  State<CenterMenu> createState() => _CenterMenuState();
}

class _CenterMenuState extends State<CenterMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return CenterAnimation(controller: controller);
  }
}

class CenterAnimation extends StatelessWidget {
  CenterAnimation({super.key, required this.controller}) :
        scale = Tween<double>(
            begin: 0,
            end: 1.0
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));

  final AnimationController controller;
  final Animation<double> scale;

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenusBloc, MenusState>(
        listenWhen: (prev, curr) {
          return (prev is MenusLoaded && curr is MenusLoaded &&
              prev.centerOpen != curr.centerOpen);
        },
        listener: (context, state) {
          if (state is MenusLoaded) {
            if (state.centerOpen) {
              _open();
            } else {
              _close();
            }
          }else{
            _close();
          }
        },
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, builder) {
            return Stack(
              children: <Widget>[
                Opacity(
                  opacity: scale.value,
                  child: Builder(builder: (context) {
                    if (scale.value > 0) {
                      return Container(
                        alignment: AlignmentDirectional.center,
                        color: const Color(0x4F000000),
                        child: SizedBox.expand(
                          child: Stack(
                            alignment: Alignment.center,
                              children: <Widget>[

                            Transform.translate(
                              offset: Offset(75, 75 - (scale.value * 75)),
                              child: PlayersMenu(),
                            ),
                            Transform.translate(
                              offset: Offset((scale.value * 75) + 75, 75),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(75, 75 + (scale.value * 75)),
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<CounterBloc>()
                                      .add(ResetLife());
                                  context
                                      .read<MenusBloc>()
                                      .add(ToggleCenter());
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(
                                        25),
                                  ),
                                  child: const Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.rotateRight,
                                        size: 20,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(75 - (scale.value * 75), 75),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            )
                          ]),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ),
                Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: () {
                      MenusState state = context.read<MenusBloc>().state;
                      context.read<MenusBloc>().add(ToggleCenter());
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        )
    );
  }
}

class PlayersMenu extends StatefulWidget {

  const PlayersMenu({
    super.key,
  });

  @override
  State<PlayersMenu> createState() => _PlayersMenuState();
}

class _PlayersMenuState extends State<PlayersMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return PlayerAnimation(controller: controller,);
  }
}

class PlayerAnimation extends StatelessWidget {
  PlayerAnimation({super.key, required this.controller}) :
        scale = Tween<double>(
            begin: 0.0,
            end: 1.0
        ).animate(
            CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));

  final AnimationController controller;
  final Animation<double> scale;

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenusBloc, MenusState>(
      listenWhen: (prev, curr) {
        return (prev is MenusLoaded && curr is MenusLoaded &&
            prev.playersOpen != curr.playersOpen);
      },
      listener: (context, state) {
        if (state is MenusLoaded) {
          if (state.playersOpen) {
            _open();
          } else {
            _close();
          }
        }else{
          _close();
        }
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return GestureDetector(
            onTap: () {
              context.read<MenusBloc>().add(TogglePlayers());
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset((scale.value * 75), 75),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
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
