import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_boost_example/pageRouter.dart';

void main() {
  PageVisibilityBinding.instance
      .addGlobalObserver(AppGlobalPageVisibilityObserver());
  CustomFlutterBinding();
  runApp(mainAppWidget());
}

class mainAppWidget extends StatelessWidget {
  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    FlutterBoostRouteFactory? func = routerMap[settings.name!];
    // FlutterBoostRouteFactory? factory=    (settings, uniqueId) {
    //   return PageRouteBuilder<dynamic>(
    //       settings: settings,
    //       pageBuilder: (_, __, ___) => Container());
    // };

    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);// PageRouteBuilder
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(routeFactory, interceptors: [//设置 BoostNavigator.instance.routeFactory = routeFactory;
      CustomInterceptor1(),
      CustomInterceptor2(),
      CustomInterceptor3()
    ]);
  }
}

class AppGlobalPageVisibilityObserver extends GlobalPageVisibilityObserver {
  @override
  void onPagePush(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageCreate route:${route.settings.name}');
  }

  @override
  void onPageShow(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageShow route:${route.settings.name}');
  }

  @override
  void onPageHide(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageHide route:${route.settings.name}');
  }

  @override
  void onPagePop(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onPageDestroy route:${route.settings.name}');
  }

  @override
  void onForeground(Route route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onForeground route:${route.settings.name}');
  }

  @override
  void onBackground(Route<dynamic> route) {
    Logger.log(
        'boost_lifecycle: AppGlobalPageVisibilityObserver.onBackground route:${route.settings.name}');
  }
}

class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class CustomInterceptor1 extends BoostInterceptor {
  @override
  void onPrePush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPrePush1~~~, $option');
    // Add extra arguments
    option.arguments!['CustomInterceptor1'] = "1";
    super.onPrePush(option, handler);
  }

  @override
  void onPostPush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPostPush1~~~, $option');
    handler.next(option);
  }
}

class CustomInterceptor2 extends BoostInterceptor {
  @override
  void onPrePush(
      BoostInterceptorOption option, PushInterceptorHandler  handler) {
    Logger.log('CustomInterceptor#onPrePush2~~~, $option');
    // Add extra arguments
    option.arguments!['CustomInterceptor2'] = "2";
    if (!option.isFromHost! && option.name == "interceptor") {
      handler.resolve(<String, dynamic>{'result': 'xxxx'});// 对 target 进行拦截，如果 name==interceptor 直接返回结果
    } else {
      handler.next(option);
    }
  }

  @override
  void onPostPush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPostPush2~~~, $option');
    handler.next(option);
  }
}

class CustomInterceptor3 extends BoostInterceptor {
  @override
  void onPrePush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPrePush3~~~, $option');
    // Replace arguments
    option.arguments = <String, dynamic>{'CustomInterceptor3': '3'};
    handler.next(option);
  }

  @override
  void onPostPush(
      BoostInterceptorOption option, PushInterceptorHandler handler) {
    Logger.log('CustomInterceptor#onPostPush3~~~, $option');
    handler.next(option);
  }
}

class BoostNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('boost-didPush${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('boost-didPop${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('boost-didRemove${route.settings.name}');
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('boost-didStartUserGesture${route.settings.name}');
  }
}
