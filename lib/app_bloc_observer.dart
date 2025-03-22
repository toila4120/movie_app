import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/utils/app_log.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);

    AppLog.info("${bloc.runtimeType} onCreate()", tag: "${bloc.runtimeType}");
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);

    AppLog.info("${bloc.runtimeType} onClose()", tag: "${bloc.runtimeType}");
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    AppLog.info("$error\n$stackTrace", tag: "${bloc.runtimeType}");
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);

    AppLog.info(transition.toString(), tag: "${bloc.runtimeType}");
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    AppLog.info(change.toString(), tag: "${bloc.runtimeType}");
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);

    AppLog.info(event.runtimeType, tag: "${bloc.runtimeType}");
  }
}
