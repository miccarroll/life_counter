part of 'menus_bloc.dart';


abstract class MenusEvent {}

class LoadMenus extends MenusEvent{}


class ToggleCenter extends MenusEvent{}

class TogglePlayers extends MenusEvent{}

class ClosedCenter extends MenusEvent{}

class ClosedPlayer extends MenusEvent{}