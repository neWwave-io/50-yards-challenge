import '/auth/base_auth_user_provider.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/users_record.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import '/backend/supabase_compat/compat_types.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'loading_page_model.dart';
export 'loading_page_model.dart';

class LoadingPageWidget extends StatefulWidget {
  const LoadingPageWidget({super.key});

  static String routeName = 'LoadingPage';
  static String routePath = '/loadingPage';

  @override
  State<LoadingPageWidget> createState() => _LoadingPageWidgetState();
}

class _LoadingPageWidgetState extends State<LoadingPageWidget>
    with TickerProviderStateMixin {
  late LoadingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadingPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (loggedIn != true) {
        context.pushNamed(SigninWidget.routeName);
        return;
      }

      // Settings and the user's profile are best-effort. An empty database
      // (nothing imported yet) must NOT strand the user on this screen, so
      // every step is guarded and navigation always happens.
      try {
        _model.settings = await querySettingsRecordOnce(
          singleRecord: true,
        ).then((s) => s.firstOrNull);
        final settings = _model.settings;
        if (settings != null) {
          FFAppState().listStates = settings.listState.toList().cast<String>();
          FFAppState().optionMowed =
              settings.allowMowedCategories.toList().cast<String>();
        }
      } catch (e) {
        debugPrint('Could not load settings, continuing anyway: $e');
      }

      // currentUserDocument is filled in by authenticatedUserStream, which may
      // not have emitted yet immediately after sign-in. Fetch it directly so
      // the admin check is correct on a cold start.
      try {
        final ref = currentUserReference;
        if (currentUserDocument == null && ref != null) {
          currentUserDocument = await UsersRecord.getDocumentOnceOrNull(ref);
        }
      } catch (e) {
        debugPrint('Could not load profile, continuing anyway: $e');
      }

      if (!context.mounted) return;
      safeSetState(() {});

      final role = valueOrDefault(currentUserDocument?.role, '');
      if (role == 'admin' || role == 'super_admin') {
        context.pushNamed(HomeAdminWidget.routeName);
      } else {
        context.pushNamed(HomePageWidget.routeName);
      }
    });

    animationsMap.addAll({
      'imageOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 800.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 800.0.ms,
            duration: 800.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(0.8, 0.8),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/50BIGFLOWER.png',
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.316,
                    fit: BoxFit.contain,
                  ),
                ).animateOnPageLoad(animationsMap['imageOnPageLoadAnimation']!),
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Lottie.asset(
                    'assets/jsons/Lawnmower.json',
                    width: 147.3,
                    height: 99.5,
                    fit: BoxFit.contain,
                    animate: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
