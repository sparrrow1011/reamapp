import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }
   pop() {
    navigatorKey.currentState!.pop();
  }

  Future<dynamic> popAndPushNamed(String routeName, {arguments}) {
    return navigatorKey.currentState!.popAndPushNamed(routeName, arguments: arguments);
  }
  Future<dynamic> pushReplacementNamed(String routeName, {arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
  Future<dynamic> pushNamedAndRemoveUntil(String routeName, {arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  Future<dynamic> setPushNamedAndRemoveUntil(
      String routeName, RoutePredicate predicate) {
    return navigatorKey.currentState
        !.pushNamedAndRemoveUntil(routeName, predicate);
  }

  popUntil(RoutePredicate route) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      navigatorKey.currentState!.popUntil(route);
    });
  }
}
