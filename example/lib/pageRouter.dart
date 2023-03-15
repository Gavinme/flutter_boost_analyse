import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_boost_example/simple_page_widgets.dart';

import 'case/bottom_navigation_bar_demo.dart';
import 'case/counter_demo.dart';
import 'case/dual_screen.dart';
import 'case/flutter_rebuild_demo.dart';
import 'case/flutter_to_flutter_sample.dart';
import 'case/hero_animation.dart';
import 'case/image_pick.dart';
import 'case/media_query.dart';
import 'case/native_view_demo.dart';
import 'case/platform_view_perf.dart';
import 'case/popUntil.dart';
import 'case/radial_hero_animation.dart';
import 'case/return_data.dart';
import 'case/rotation_transition.dart';
import 'case/selection_screen.dart';
import 'case/simple_webview_demo.dart';
import 'case/state_restoration.dart';
import 'case/system_ui_overlay_style.dart';
import 'case/transparent_widget.dart';
import 'case/webview_flutter_demo.dart';
import 'case/willpop.dart';
import 'flutter_page.dart';
import 'tab/simple_widget.dart';

///以下页面一般都采用 Scaffold 为顶级元素
Map<String, FlutterBoostRouteFactory> routerMap = {
  'embedded': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => EmbeddedFirstRouteWidget());
  },
  'presentFlutterPage': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => FlutterRouteWidget(
              params: settings.arguments as Map<dynamic, dynamic>?,
              uniqueId: uniqueId,
            ));
  },
  'imagepick': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => const ImagePickerPage(title: "xxx"));
  },
  'interceptor': (settings, uniqueId) {
    Logger.log("interceptor call");
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) =>
            const ImagePickerPage(title: "interceptor"));
  },
  'firstFirst': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => FirstFirstRouteWidget());
  },
  'willPop': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, __, ___) => const WillPopRoute(),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1.0, 0),
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      },
    );
  },
  'counter': (settings, uniqueId) {
    Logger.log("counter CounterPage");
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => const CounterPage(title: "Counter Demo"));
  },
  'dualScreen': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => const DualScreen());
  },
  'hero_animation': (settings, uniqueId) {
    return MaterialPageRoute(
        settings: settings, builder: (_) => const HeroAnimation());
  },
  'returnData': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => ReturnDataWidget());
  },
  'transparentWidget': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        barrierColor: Colors.black12,
        transitionDuration: const Duration(),
        reverseTransitionDuration: const Duration(),
        opaque: false,
        settings: settings,
        pageBuilder: (_, __, ___) => TransparentWidget());
  },
  'radialExpansion': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => RadialExpansionDemo());
  },
  'selectionScreen': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => SelectionScreen());
  },
  'secondStateful': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => SecondStatefulRouteWidget());
  },
  'platformView': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => PlatformRouteWidget());
  },
  'popUntilView': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => PopUntilRoute());
  },

  ///可以在native层通过 getContainerParams 来传递参数
  'flutterPage': (settings, uniqueId) {
    debugPrint('flutterPage settings:$settings, uniqueId:$uniqueId');
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, __, ___) => FlutterRouteWidget(
        params: settings.arguments as Map<dynamic, dynamic>?,
        uniqueId: uniqueId,
      ),
      // transitionsBuilder: (BuildContext context, Animation<double> animation,
      //     Animation<double> secondaryAnimation, Widget child) {
      //   return SlideTransition(
      //     position: Tween<Offset>(
      //       begin: const Offset(1.0, 0),
      //       end: Offset.zero,
      //     ).animate(animation),
      //     child: SlideTransition(
      //       position: Tween<Offset>(
      //         begin: Offset.zero,
      //         end: const Offset(-1.0, 0),
      //       ).animate(secondaryAnimation),
      //       child: child,
      //     ),
      //   );
      // },
    );
  },
  'tab_friend': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => SimpleWidget(
            uniqueId,
            settings.arguments as Map<dynamic, dynamic>?,
            "This is a flutter fragment"));
  },
  'tab_message': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => SimpleWidget(
            uniqueId,
            settings.arguments as Map<dynamic, dynamic>?,
            "This is a flutter fragment"));
  },
  'tab_flutter1': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => SimpleWidget(
            uniqueId,
            settings.arguments as Map<dynamic, dynamic>?,
            "This is a custom FlutterView"));
  },
  'tab_flutter2': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => SimpleWidget(
            uniqueId,
            settings.arguments as Map<dynamic, dynamic>?,
            "This is a custom FlutterView"));
  },

  'f2f_first': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => F2FFirstPage());
  },
  'f2f_second': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => F2FSecondPage());
  },
  'webview': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => WebViewExample());
  },
  'platformview/listview': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => PlatformViewPerf());
  },
  'platformview/animation': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => NativeViewExample());
  },
  'platformview/simplewebview': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => SimpleWebView());
  },
  'state_restoration': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => StateRestorationDemo());
  },
  'rotation_transition': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings, pageBuilder: (_, __, ___) => RotationTranDemo());
  },
  'bottom_navigation': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => const BottomNavigationPage());
  },
  'system_ui_overlay_style': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => const SystemUiOverlayStyleDemo());
  },
  'mediaquery': (settings, uniqueId) {
    return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => MediaQueryRouteWidget(
              params: settings.arguments as Map<dynamic, dynamic>?,
              uniqueId: uniqueId,
            ));
  },

  ///使用 BoostCacheWidget包裹你的页面时，可以解决push pageA->pageB->pageC 过程中，pageA，pageB 会多次 rebuild 的问题
  'flutterRebuildDemo': (settings, uniqueId) {
    return MaterialPageRoute(
        settings: settings,
        builder: (ctx) {
          return BoostCacheWidget(
            uniqueId: uniqueId!,
            builder: (_) => const FlutterRebuildDemo(),
          );
        });
  },
  'flutterRebuildPageA': (settings, uniqueId) {
    return MaterialPageRoute(
        settings: settings,
        builder: (ctx) {
          return BoostCacheWidget(
            uniqueId: uniqueId!,
            builder: (_) => const FlutterRebuildPageA(),
          );
        });
  },
  'flutterRebuildPageB': (settings, uniqueId) {
    return MaterialPageRoute(
        settings: settings,
        builder: (ctx) {
          return BoostCacheWidget(
            uniqueId: uniqueId!,
            builder: (_) => const FlutterRebuildPageB(),
          );
        });
  },
};
