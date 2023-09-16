import 'package:flutter/material.dart';
import 'package:life_counter/blocs/counter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_counter/blocs/menus_bloc.dart';

//region Center Menu
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
  CenterAnimation({super.key, required this.controller})
      : scale = Tween<double>(begin: 0, end: 1.0).animate(
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
          return (prev is MenusLoaded &&
              curr is MenusLoaded &&
              prev.centerOpen != curr.centerOpen);
        },
        listener: (context, state) {
          if (state is MenusLoaded) {
            if (state.centerOpen) {
              _open();
            } else {
              _close();
            }
          } else {
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
                                  offset: Offset(0, -(scale.value * 75)),
                                  child: const PlayersMenu(),
                                ),
                                Transform.translate(
                                  offset: Offset(scale.value * 75, 0),
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
                                  offset: Offset(0, scale.value * 75),
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
                                        borderRadius: BorderRadius.circular(25),
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
                                  offset: Offset(-(scale.value * 75), 0),
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
                      if (state is MenusLoaded) {
                        print(state.playersOpen);
                      }
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
        ));
  }
}
//endregion

//region Players Menu
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
    return PlayerAnimation(
      controller: controller,
    );
  }
}

class PlayerAnimation extends StatelessWidget {
  PlayerAnimation({super.key, required this.controller})
      : scale = Tween<double>(begin: 0.0, end: 1.0).animate(
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
        return (prev is MenusLoaded &&
            curr is MenusLoaded &&
            prev.playersOpen != curr.playersOpen);
      },
      listener: (context, state) {
        if (state is MenusLoaded) {
          if (state.playersOpen) {
            _open();
          } else {
            _close();
          }
        } else {
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset((scale.value * 30), -(scale.value * 80)),
                  child: buildPlayerButton(context,4),
                ),
                Transform.translate(
                  offset: Offset((scale.value * 70), -(scale.value * 40)),
                  child: buildPlayerButton(context,5),
                ),
                Transform.translate(
                  offset: Offset((scale.value * 80), (scale.value * 15)),
                  child: buildPlayerButton(context,6),
                ),
                Transform.translate(
                  offset: Offset(-(scale.value * 80), (scale.value * 15)),
                  child: buildPlayerButton(context,1),
                ),
                Transform.translate(
                  offset: Offset(-(scale.value * 70), -(scale.value * 40)),
                  child: buildPlayerButton(context,2),
                ),
                Transform.translate(
                  offset: Offset(-(scale.value * 30), -(scale.value * 80)),
                  child: buildPlayerButton(context,3),
                ),
                GestureDetector(
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
                    ))
              ],
            ),
          );
        },
      ),
    );
  }

  GestureDetector buildPlayerButton(BuildContext context,final int playerNum) {
    final String imagePath = () {
      switch (playerNum) {
        case 1:
          return "assets/life_counter_grids-1p.png";
        case 2:
          return "assets/life_counter_grids-2p.png";
        case 3:
          return "assets/life_counter_grids-3p.png";
        case 4:
          return "assets/life_counter_grids-4p.png";
        case 5:
          return "assets/life_counter_grids-5p.png";
        case 6:
          return "assets/life_counter_grids-6p.png";
        default:
          return "assets/life_counter_grids-4p.png";
      }
    }();

    return GestureDetector(
      onTap: () {
        context.read<CounterBloc>().add(ChangeLayout(playerNum: playerNum));
      },
      child: Container(
        alignment: Alignment.center,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
//endregion
