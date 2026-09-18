import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_video_player.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'congrats_got_shirt_model.dart';
export 'congrats_got_shirt_model.dart';

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
class CongratsGotShirtWidget extends StatefulWidget {
  const CongratsGotShirtWidget({
    super.key,
    this.shirtLevel,
    this.action,
    this.gender,
  });

  final String? shirtLevel;
  final Future Function()? action;
  final String? gender;

  @override
  State<CongratsGotShirtWidget> createState() => _CongratsGotShirtWidgetState();
}

class _CongratsGotShirtWidgetState extends State<CongratsGotShirtWidget>
    with TickerProviderStateMixin {
  late CongratsGotShirtModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CongratsGotShirtModel());

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
    return Container(
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
                height: 517.23,
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
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Text(
                              'Congratulations!!',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                                    color:
                                        FlutterFlowTheme.of(context).greenWhite,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    elevation: 0.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: Builder(
                                      builder: (context) {
                                        if (widget!.gender ==
                                            Gender.Male.name) {
                                          return Builder(
                                            builder: (context) {
                                              if (widget!.shirtLevel ==
                                                  ShirtLevel.starter.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/WhiteMan.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  lazyLoad: true,
                                                  pauseOnNavigate: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.orange.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/OrangeMan.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.green.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/GreenMan.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  lazyLoad: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.blue.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/BlueMan.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.red.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/RedMan.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/BlackMan.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  pauseOnNavigate: false,
                                                );
                                              }
                                            },
                                          );
                                        } else {
                                          return Builder(
                                            builder: (context) {
                                              if (widget!.shirtLevel ==
                                                  ShirtLevel.starter.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/WhiteWm.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.orange.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/OrangeWm.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  lazyLoad: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.green.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/GreenWm.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.blue.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/BlueWm.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else if (widget!.shirtLevel ==
                                                  ShirtLevel.red.name) {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/RedWm.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  lazyLoad: false,
                                                  pauseOnNavigate: false,
                                                );
                                              } else {
                                                return FlutterFlowVideoPlayer(
                                                  path:
                                                      'assets/videos/BlackWm.mp4',
                                                  videoType: VideoType.asset,
                                                  height: 350.0,
                                                  autoPlay: true,
                                                  looping: true,
                                                  showControls: false,
                                                  allowFullScreen: false,
                                                  allowPlaybackSpeedMenu: false,
                                                  pauseOnNavigate: false,
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, -1.0),
                                    child: Text(
                                      'We Got Your Request',
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
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineSmall
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ].divide(SizedBox(height: 20.0)),
                              ),
                            ].divide(SizedBox(height: 20.0)),
                          ),
                          Flexible(
                            child: FFButtonWidget(
                              onPressed: () async {
                                await widget.action?.call();
                                Navigator.pop(context);
                              },
                              text: 'Yes!',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 48.0,
                                padding: EdgeInsets.all(8.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).greenWhite,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .letterGreen,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                        ],
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!);
  }
}
