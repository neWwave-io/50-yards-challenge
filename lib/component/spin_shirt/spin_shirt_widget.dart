import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'spin_shirt_model.dart';
export 'spin_shirt_model.dart';

/// **"Edit Record" screen with a simple, clean layout.
///
/// At the top, there is a header titled “Edit Record.”
/// Below it are two dropdown fields:
///
/// "Who is this lawn for?" – selection input
///
/// "How many hours did this lawn take?" – selection input
///
/// Under the dropdowns is a 2×2 grid displaying four image upload slots.
/// Each slot shows a placeholder image icon with a label like (01), (02),
/// (03), (04) above each row.
///
/// At the bottom, there are two rounded buttons:
///
/// Cancel (light grey)
///
/// Confirm (dark green)
///
/// The design uses soft rounded corners, muted earthy green tones, and a
/// simple, friendly style."**
class SpinShirtWidget extends StatefulWidget {
  const SpinShirtWidget({
    super.key,
    this.shirtLevel,
    this.gender,
  });

  final String? shirtLevel;
  final String? gender;

  @override
  State<SpinShirtWidget> createState() => _SpinShirtWidgetState();
}

class _SpinShirtWidgetState extends State<SpinShirtWidget>
    with TickerProviderStateMixin {
  late SpinShirtModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SpinShirtModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeIn,
            delay: 320.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.5, 0.5),
            end: Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 59.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        Navigator.pop(context);
      },
      child: Container(
        height: 450.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0x995D844B),
                    borderRadius: BorderRadius.circular(40.0),
                    border: Border.all(
                      color: Color(0x80FFFFFF),
                      width: 0.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.0, -1.0),
                                child: Text(
                                  'Spin me',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .greenWhite,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          if (widget!.gender ==
                                              Gender.Male.name) {
                                            return Card(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              color: Colors.transparent,
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              child: FlutterFlowWebView(
                                                content: () {
                                                  if (widget!.shirtLevel ==
                                                      ShirtLevel.starter.name) {
                                                    return 'https://my.spline.design/whitenm-fuSYbzDtDm8XmSgLwD8gJLuU/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.orange.name) {
                                                    return 'https://my.spline.design/orangenm-ZYNLkd4b6oXB73zUNy7sv4bs/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.green.name) {
                                                    return 'https://my.spline.design/greennm-mfr4LOjUpDv9x526alMeXymc/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.blue.name) {
                                                    return 'https://my.spline.design/bluenm-LEdSWTXmJ9EvxUscqrhY6SSE/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.red.name) {
                                                    return 'https://my.spline.design/rednm-lSu7ZF4V3KdCMeVeN2uz3u1a/';
                                                  } else {
                                                    return 'https://my.spline.design/blacknm-6z76x350pRwwKDoCSoqsP1Bi/';
                                                  }
                                                }(),
                                                bypass: false,
                                                height: 300.0,
                                                verticalScroll: false,
                                                horizontalScroll: false,
                                              ),
                                            );
                                          } else {
                                            return Card(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              color: Colors.transparent,
                                              elevation: 0.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              child: FlutterFlowWebView(
                                                content: () {
                                                  if (widget!.shirtLevel ==
                                                      ShirtLevel.starter.name) {
                                                    return 'https://my.spline.design/whiten-zOpChPrs2SmNomTibFVV8vLY/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.orange.name) {
                                                    return 'https://my.spline.design/orangen-JHtmqwJHbgFobGTjxnUkzWpw/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.green.name) {
                                                    return 'https://my.spline.design/greenn-cDAwIRZfc1SRLRIvl3DFn4N0/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.blue.name) {
                                                    return 'https://my.spline.design/bluen-Po2MMG5DplmN2sYsjXfbDgoG/';
                                                  } else if (widget!
                                                          .shirtLevel ==
                                                      ShirtLevel.red.name) {
                                                    return 'https://my.spline.design/redn-WoJjl19qIbpSIW6lTjbseB2B/';
                                                  } else {
                                                    return 'https://my.spline.design/blackn-vOkTbMX7kV3VE2dziIjovg1C/';
                                                  }
                                                }(),
                                                bypass: false,
                                                width: 300.0,
                                                height: 400.0,
                                                verticalScroll: false,
                                                horizontalScroll: false,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ].divide(SizedBox(height: 20.0)),
                                  ),
                                ].divide(SizedBox(height: 20.0)),
                              ),
                            ].divide(SizedBox(height: 20.0)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1.0, 1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/4fa4229e-5726-4d8b-9f8f-0d82ad13d3c4_5-2.png',
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 20.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderRadius: 8.0,
                            buttonSize: 40.0,
                            icon: Icon(
                              Icons.close_rounded,
                              color: FlutterFlowTheme.of(context).info,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }
}
