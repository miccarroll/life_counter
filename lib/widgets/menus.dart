

import 'package:flutter/material.dart';
import 'package:life_counter/blocs/counter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_counter/blocs/menus_bloc.dart';



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

