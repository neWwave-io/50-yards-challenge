import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'shirt_level_model.dart';
export 'shirt_level_model.dart';

class ShirtLevelWidget extends StatefulWidget {
  const ShirtLevelWidget({super.key});

  @override
  State<ShirtLevelWidget> createState() => _ShirtLevelWidgetState();
}

class _ShirtLevelWidgetState extends State<ShirtLevelWidget> {
  late ShirtLevelModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ShirtLevelModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (valueOrDefault(currentUserDocument?.gender, '') ==
            Gender.Male.name) {
          return Builder(
            builder: (context) {
              if (valueOrDefault(currentUserDocument?.totalLawns, 0) < 10) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Raising_men_6_4.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Starter Shirt',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      10) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 20)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Raising_men_8.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Advanced Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      20) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 30)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Raising_men_7.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Rising Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      30) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 40)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Raising_men_11.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Pro Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      40) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 50)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Raising_men_9.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Elite Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Raising_men_10.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Master Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              }
            },
          );
        } else {
          return Builder(
            builder: (context) {
              if (valueOrDefault(currentUserDocument?.totalLawns, 0) < 10) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/wWhite.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Starter Shirt',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      10) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 20)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/WOrange.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Advanced Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      20) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 30)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Wgreen.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Rising Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      30) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 40)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Wblue.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Pro Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else if ((valueOrDefault(currentUserDocument?.totalLawns, 0) >=
                      40) &&
                  (valueOrDefault(currentUserDocument?.totalLawns, 0) < 50)) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Wred.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Elite Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/Wblack.png',
                        width: 200.0,
                        height: 141.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Master Mower',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}
