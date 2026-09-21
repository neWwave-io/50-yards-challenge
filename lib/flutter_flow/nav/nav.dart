import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';

import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/component/nav/nav_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '/backend/push_notifications/push_notifications_handler.dart'
    show PushNotificationsHandler;
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/features/auth/sign_in/sign_in_screen.dart';
import '/features/home/home_screen.dart';
import '/features/auth/sign_up/sign_up_screen.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  // `user == null` simply means "signed out", which is a renderable state —
  // it must not gate the UI. Treating it as "loading" meant that if the auth
  // stream was slow, errored, or never emitted, the splash image stayed up
  // forever and the app never rendered anything.
  bool get loading => showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

/// The v2 sign-up, wired to the app's router. Step 2 is pushed by step 1 once
/// it has the account details, so it has no route of its own.
SignUpScreen _signUpScreen(BuildContext context) => SignUpScreen(
      onSignIn: () => context.pushNamed(SignInScreen.routeName),
      onCompleted: () =>
          context.goNamedAuth(LoadingPageWidget.routeName, context.mounted),
    );

/// Opens a training video in the browser, or says why it cannot.
Future<void> _openLink(BuildContext context, String? url) async {
  final target = url == null ? null : Uri.tryParse(url);
  if (target == null ||
      !await launchUrl(target, mode: LaunchMode.externalApplication)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('That video is not available yet.')),
      );
    }
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn
              ? LoadingPageWidget()
              : _signUpScreen(context),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? LoadingPageWidget()
              : _signUpScreen(context),
        ),
        FFRoute(
          name: HomeScreen.routeName,
          path: HomeScreen.routePath,
          builder: (context, params) => HomeScreen(
            onStartMowing: () =>
                context.pushNamed(SubmitLawnWidget.routeName),
            onSeeAnnouncements: () =>
                context.pushNamed(AnnouncementWidget.routeName),
            onOpenAnnouncement: (_) =>
                context.pushNamed(AnnouncementWidget.routeName),
            onOpenBadges: () => context.pushNamed(AchivementWidget.routeName),
            onWatchTraining: (video) => _openLink(context, video.link),
            bottomBar: NavWidget(pageIndex: 0),
          ),
        ),
        FFRoute(
          name: SignInScreen.routeName,
          path: SignInScreen.routePath,
          builder: (context, params) => SignInScreen(
            onSignIn: (email, password) async {
              GoRouter.of(context).prepareAuthEvent();
              final user =
                  await authManager.signInWithEmail(context, email, password);
              if (user == null) {
                // The auth manager has already shown why.
                return null;
              }
              if (context.mounted) {
                context.goNamedAuth(
                    LoadingPageWidget.routeName, context.mounted);
              }
              return null;
            },
            onForgotPassword: (email) =>
                authManager.resetPassword(email: email, context: context),
            onCreateAccount: () => context.pushNamed(SignUpScreen.routeName),
          ),
        ),
        FFRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routePath,
          builder: (context, params) => _signUpScreen(context),
        ),
        FFRoute(
          name: LeaderBoardWidget.routeName,
          path: LeaderBoardWidget.routePath,
          builder: (context, params) => LeaderBoardWidget(),
        ),
        FFRoute(
          name: HowToSumitOldWidget.routeName,
          path: HowToSumitOldWidget.routePath,
          builder: (context, params) => HowToSumitOldWidget(),
        ),
        FFRoute(
          name: AchivementWidget.routeName,
          path: AchivementWidget.routePath,
          builder: (context, params) => AchivementWidget(),
        ),
        FFRoute(
          name: SubmitLawnWidget.routeName,
          path: SubmitLawnWidget.routePath,
          builder: (context, params) => SubmitLawnWidget(),
        ),
        FFRoute(
          name: ShirtSystemWidget.routeName,
          path: ShirtSystemWidget.routePath,
          builder: (context, params) => ShirtSystemWidget(),
        ),
        FFRoute(
          name: AnnouncementWidget.routeName,
          path: AnnouncementWidget.routePath,
          builder: (context, params) => AnnouncementWidget(),
        ),
        FFRoute(
          name: HowToSubmitWidget.routeName,
          path: HowToSubmitWidget.routePath,
          builder: (context, params) => HowToSubmitWidget(),
        ),
        FFRoute(
          name: HallOfFameWidget.routeName,
          path: HallOfFameWidget.routePath,
          builder: (context, params) => HallOfFameWidget(),
        ),
        FFRoute(
          name: ProfilePageWidget.routeName,
          path: ProfilePageWidget.routePath,
          builder: (context, params) => ProfilePageWidget(
            isShirt: params.getParam(
              'isShirt',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: ProfileEditWidget.routeName,
          path: ProfileEditWidget.routePath,
          builder: (context, params) => ProfileEditWidget(),
        ),
        FFRoute(
          name: LoginAdminWidget.routeName,
          path: LoginAdminWidget.routePath,
          builder: (context, params) => LoginAdminWidget(),
        ),
        FFRoute(
          name: HomeAdminWidget.routeName,
          path: HomeAdminWidget.routePath,
          builder: (context, params) => HomeAdminWidget(),
        ),
        FFRoute(
          name: ShirtRequestAdminWidget.routeName,
          path: ShirtRequestAdminWidget.routePath,
          builder: (context, params) => ShirtRequestAdminWidget(),
        ),
        FFRoute(
          name: LeaderboardAdminWidget.routeName,
          path: LeaderboardAdminWidget.routePath,
          builder: (context, params) => LeaderboardAdminWidget(),
        ),
        FFRoute(
          name: NotificationAdminWidget.routeName,
          path: NotificationAdminWidget.routePath,
          builder: (context, params) => NotificationAdminWidget(),
        ),
        FFRoute(
          name: NewsAnnocumentWidget.routeName,
          path: NewsAnnocumentWidget.routePath,
          builder: (context, params) => NewsAnnocumentWidget(),
        ),
        FFRoute(
          name: LoadingPageWidget.routeName,
          path: LoadingPageWidget.routePath,
          builder: (context, params) => LoadingPageWidget(),
        ),
        FFRoute(
          name: TestWidget.routeName,
          path: TestWidget.routePath,
          builder: (context, params) => TestWidget(),
        ),
        FFRoute(
          name: UserProfileAdminWidget.routeName,
          path: UserProfileAdminWidget.routePath,
          builder: (context, params) => UserProfileAdminWidget(
            userRef: params.getParam(
              'userRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['users'],
            ),
          ),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
      observers: [routeObserver],
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/signUp';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/50yardChallange.jpg',
                    fit: BoxFit.contain,
                  ),
                )
              : PushNotificationsHandler(child: page);

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
