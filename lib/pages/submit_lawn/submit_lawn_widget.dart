import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import '/backend/supabase_compat/compat_types.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'submit_lawn_model.dart';
export 'submit_lawn_model.dart';

class SubmitLawnWidget extends StatefulWidget {
  const SubmitLawnWidget({super.key});

  static String routeName = 'SubmitLawn';
  static String routePath = '/submitLawn';

  @override
  State<SubmitLawnWidget> createState() => _SubmitLawnWidgetState();
}

class _SubmitLawnWidgetState extends State<SubmitLawnWidget> {
  late SubmitLawnModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubmitLawnModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.isMe = await queryLeaderboardsRecordOnce(
        queryBuilder: (leaderboardsRecord) => leaderboardsRecord.where(
          'top_users',
          arrayContains: getTopUsersFirestoreData(
            TopUsersStruct(
              userRef: currentUserReference,
            ),
            true,
          ),
        ),
      );
    });

    _model.textFieldhoursTextController ??= TextEditingController();
    _model.textFieldhoursFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SettingsRecord>>(
      stream: querySettingsRecord(
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<SettingsRecord> submitLawnSettingsRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final submitLawnSettingsRecord = submitLawnSettingsRecordList.isNotEmpty
            ? submitLawnSettingsRecordList.first
            : null;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            body: Container(
              decoration: BoxDecoration(),
              child: Container(
                width: double.infinity,
                child: PageView(
                  controller: _model.pageViewController ??=
                      PageController(initialPage: 0),
                  onPageChanged: (_) => safeSetState(() {}),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).greenWhite,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(1.0, 1.0),
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(1.0, 0.59),
                                child: Image.asset(
                                  'assets/images/Vector_16.png',
                                  width: MediaQuery.sizeOf(context).width * 0.7,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Opacity(
                                opacity: 0.7,
                                child: Align(
                                  alignment: AlignmentDirectional(-0.51, 0.53),
                                  child: Image.asset(
                                    'assets/images/bee.png',
                                    width: 70.0,
                                    height: 70.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1.0, 1.0),
                                child: Image.asset(
                                  'assets/images/4fa4229e-5726-4d8b-9f8f-0d82ad13d3c4_5-1.png',
                                  height: 180.0,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Container(
                                        height: 130.11,
                                        decoration: BoxDecoration(),
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/submitMylawn.png',
                                            width: 200.13,
                                            height: 210.6,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 0.0, 20.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Who is this lawn for?',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 80.0,
                                                  decoration: BoxDecoration(),
                                                  child: FlutterFlowDropDown<
                                                      String>(
                                                    controller: _model
                                                            .dropDownValueController ??=
                                                        FormFieldController<
                                                            String>(null),
                                                    options:
                                                        submitLawnSettingsRecord!
                                                            .allowMowedCategories,
                                                    onChanged: (val) =>
                                                        safeSetState(() => _model
                                                                .dropDownValue =
                                                            val),
                                                    textStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              font: GoogleFonts
                                                                  .poppins(
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                    hintText: 'Who',
                                                    icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 24.0,
                                                    ),
                                                    fillColor: FlutterFlowTheme
                                                            .of(context)
                                                        .secondaryBackground,
                                                    elevation: 1.0,
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderWidth: 0.0,
                                                    borderRadius: 20.0,
                                                    margin:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(20.0, 0.0,
                                                                20.0, 0.0),
                                                    hidesUnderline: true,
                                                    isOverButton: false,
                                                    isSearchable: false,
                                                    isMultiSelect: false,
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 20.0)),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'How Many Hours',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 80.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 0.0,
                                                                15.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            width: 200.0,
                                                            child:
                                                                TextFormField(
                                                              controller: _model
                                                                  .textFieldhoursTextController,
                                                              focusNode: _model
                                                                  .textFieldhoursFocusNode,
                                                              onChanged: (_) =>
                                                                  EasyDebounce
                                                                      .debounce(
                                                                '_model.textFieldhoursTextController',
                                                                Duration(
                                                                    milliseconds:
                                                                        300),
                                                                () async {
                                                                  _model.hours =
                                                                      int.parse(_model
                                                                          .textFieldhoursTextController
                                                                          .text);
                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                              ),
                                                              autofocus: false,
                                                              enabled: true,
                                                              obscureText:
                                                                  false,
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                hintText: _model
                                                                    .hours
                                                                    .toString(),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0x00000000),
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0x00000000),
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                focusedErrorBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .error,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                filled: true,
                                                                fillColor: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    font: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                              cursorColor:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                              enableInteractiveSelection:
                                                                  true,
                                                              validator: _model
                                                                  .textFieldhoursTextControllerValidator
                                                                  .asValidator(
                                                                      context),
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model.hours =
                                                                    _model.hours +
                                                                        1;
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .angleUp,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 18.0,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                _model
                                                                    .hours = _model
                                                                        .hours +
                                                                    (_model.hours ==
                                                                            0
                                                                        ? 0
                                                                        : -1);
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .angleDown,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                size: 18.0,
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 5.0)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 20.0)),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 40.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 2.0,
                                          sigmaY: 2.0,
                                        ),
                                        child: Container(
                                          width: 300.0,
                                          height: 54.0,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0x80C7CAC1),
                                                Color(0x7FBFC4B7),
                                                Color(0x7FA1A59B)
                                              ],
                                              stops: [0.2, 0.9, 1.0],
                                              begin: AlignmentDirectional(
                                                  0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                          ),
                                          child: FFButtonWidget(
                                            onPressed:
                                                (!(submitLawnSettingsRecord!
                                                            .allowMowedCategories
                                                            .isNotEmpty) ||
                                                        (_model.hours == null))
                                                    ? null
                                                    : () async {
                                                        await _model
                                                            .pageViewController
                                                            ?.nextPage(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          curve: Curves.ease,
                                                        );
                                                      },
                                            text: 'Let\'s Start',
                                            options: FFButtonOptions(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .generalGreen,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: Colors.white,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                              disabledColor: Color(0x195F6B4B),
                                              disabledTextColor:
                                                  FlutterFlowTheme.of(context)
                                                      .greenWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                      .divide(SizedBox(height: 80.0))
                                      .addToStart(SizedBox(height: 60.0))
                                      .addToEnd(SizedBox(height: 40.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.7),
                              child: Image.asset(
                                'assets/images/Vector_17.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.2),
                              child: Image.asset(
                                'assets/images/beeTail.png',
                                height: 70.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, 1.0),
                              child: Image.asset(
                                'assets/images/4fa4229e-5726-4d8b-9f8f-0d82ad13d3c4_5.png',
                                height: 90.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1.0, 1.0),
                              child: Image.asset(
                                'assets/images/4fa4229e-5726-4d8b-9f8f-0d82ad13d3c4_4.png',
                                height: 180.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, -0.8),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      context.safePop();
                                    },
                                    text: 'Back',
                                    icon: Icon(
                                      Icons.chevron_left_rounded,
                                      size: 24.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      iconColor: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      color: Color(0x00FFFFFF),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w300,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w300,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    height: 120.0,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, -1.0),
                                              child: Text(
                                                'Lawn',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                  font: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w900,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .displaySmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .generalGreen,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmall
                                                          .fontStyle,
                                                  shadows: [
                                                    Shadow(
                                                      color: Color(0x66000000),
                                                      offset: Offset(0.0, 2.0),
                                                      blurRadius: 4.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 1.0),
                                              child: Text(
                                                'Differences',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                  font: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w900,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .displaySmall
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .letterGreen,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmall
                                                          .fontStyle,
                                                  shadows: [
                                                    Shadow(
                                                      color: Color(0x66000000),
                                                      offset: Offset(0.0, 2.0),
                                                      blurRadius: 4.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.59, -1.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              'assets/images/butterfly.png',
                                              width: 70.0,
                                              height: 70.0,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  'Before Mowing',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    if (_model.beforeLawn ==
                                                            null ||
                                                        _model.beforeLawn ==
                                                            '') {
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          _model.before = true;
                                                          safeSetState(() {});
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            allowPhoto: true,
                                                            includeBlurHash:
                                                                true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading_uploadDataGrass0 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            var downloadUrls =
                                                                <String>[];
                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                            originalFilename:
                                                                                m.originalFilename,
                                                                          ))
                                                                      .toList();

                                                              downloadUrls =
                                                                  (await Future
                                                                          .wait(
                                                                selectedMedia
                                                                    .map(
                                                                  (m) async =>
                                                                      await uploadData(
                                                                          m.storagePath,
                                                                          m.bytes),
                                                                ),
                                                              ))
                                                                      .where((u) =>
                                                                          u !=
                                                                          null)
                                                                      .map((u) =>
                                                                          u!)
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading_uploadDataGrass0 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length &&
                                                                downloadUrls
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile_uploadDataGrass0 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                                _model.uploadedFileUrl_uploadDataGrass0 =
                                                                    downloadUrls
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }

                                                          _model.beforeLawn = _model
                                                              .uploadedFileUrl_uploadDataGrass0;
                                                          _model.before = false;
                                                          _model.the1hash = _model
                                                              .uploadedLocalFile_uploadDataGrass0
                                                              .blurHash;
                                                          safeSetState(() {});
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 180.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .greenWhite,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            children: [
                                                              if (_model
                                                                      .before !=
                                                                  true)
                                                                Icon(
                                                                  Icons
                                                                      .file_upload_outlined,
                                                                  color: Color(
                                                                      0xFF757575),
                                                                  size: 24.0,
                                                                ),
                                                              if (_model
                                                                      .before ==
                                                                  true)
                                                                Lottie.asset(
                                                                  'assets/jsons/Lawnmower.json',
                                                                  width: 200.0,
                                                                  height: 200.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  animate: true,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: OctoImage(
                                                          placeholderBuilder:
                                                              (_) => SizedBox
                                                                  .expand(
                                                            child: Image(
                                                              image: BlurHashImage(
                                                                  _model
                                                                      .the1hash!),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          image: NetworkImage(
                                                            _model.beforeLawn!,
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          height: 200.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  'After Mowing',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    if (_model.afterLawn ==
                                                            null ||
                                                        _model.afterLawn ==
                                                            '') {
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          _model.after = true;
                                                          safeSetState(() {});
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            allowPhoto: true,
                                                            includeBlurHash:
                                                                true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading_uploadDataGrass1 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            var downloadUrls =
                                                                <String>[];
                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                            originalFilename:
                                                                                m.originalFilename,
                                                                          ))
                                                                      .toList();

                                                              downloadUrls =
                                                                  (await Future
                                                                          .wait(
                                                                selectedMedia
                                                                    .map(
                                                                  (m) async =>
                                                                      await uploadData(
                                                                          m.storagePath,
                                                                          m.bytes),
                                                                ),
                                                              ))
                                                                      .where((u) =>
                                                                          u !=
                                                                          null)
                                                                      .map((u) =>
                                                                          u!)
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading_uploadDataGrass1 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length &&
                                                                downloadUrls
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile_uploadDataGrass1 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                                _model.uploadedFileUrl_uploadDataGrass1 =
                                                                    downloadUrls
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }

                                                          _model.afterLawn = _model
                                                              .uploadedFileUrl_uploadDataGrass1;
                                                          _model.after = false;
                                                          _model.the2hash = _model
                                                              .uploadedLocalFile_uploadDataGrass1
                                                              .blurHash;
                                                          safeSetState(() {});
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 180.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .greenWhite,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            children: [
                                                              if (_model
                                                                      .after ==
                                                                  false)
                                                                Icon(
                                                                  Icons
                                                                      .file_upload_outlined,
                                                                  color: Color(
                                                                      0xFF757575),
                                                                  size: 24.0,
                                                                ),
                                                              if (_model
                                                                      .after ==
                                                                  true)
                                                                Lottie.asset(
                                                                  'assets/jsons/Lawnmower.json',
                                                                  width: 200.0,
                                                                  height: 200.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  animate: true,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: OctoImage(
                                                          placeholderBuilder:
                                                              (_) => SizedBox
                                                                  .expand(
                                                            child: Image(
                                                              image: BlurHashImage(
                                                                  _model
                                                                      .the2hash!),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          image: NetworkImage(
                                                            valueOrDefault<
                                                                String>(
                                                              _model
                                                                  .uploadedFileUrl_uploadDataGrass1,
                                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Closeup_of_lawn_grass.jpg/1200px-Closeup_of_lawn_grass.jpg',
                                                            ),
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          height: 200.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ].divide(SizedBox(height: 20.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 40.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10.0,
                                        sigmaY: 10.0,
                                      ),
                                      child: FFButtonWidget(
                                        onPressed: ((_model.beforeLawn ==
                                                        null ||
                                                    _model.beforeLawn == '') ||
                                                (_model.afterLawn == null ||
                                                    _model.afterLawn == ''))
                                            ? null
                                            : () async {
                                                await _model.pageViewController
                                                    ?.nextPage(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              },
                                        text: 'Next',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 50.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: Color(0xB5F9F9F9),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          disabledColor: Color(0x665F6B4B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                                  .divide(SizedBox(height: 40.0))
                                  .addToStart(SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.06))
                                  .addToEnd(SizedBox(height: 40.0)),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-0.79, 1.01),
                              child: Image.asset(
                                'assets/images/bee.png',
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).greenWhite,
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Vector_18.png',
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1.0, 0.2),
                              child: Image.asset(
                                'assets/images/beeHead.png',
                                height: 70.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, 0.8),
                              child: Image.asset(
                                'assets/images/bee.png',
                                height: 70.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, 1.0),
                              child: Image.asset(
                                'assets/images/4fa4229e-5726-4d8b-9f8f-0d82ad13d3c4_5.png',
                                height: 70.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(-1.0, 1.0),
                              child: Image.asset(
                                'assets/images/4fa4229e-5726-4d8b-9f8f-0d82ad13d3c4_5-2.png',
                                height: 90.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(-1.0, -0.8),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      context.safePop();
                                    },
                                    text: 'Back',
                                    icon: Icon(
                                      Icons.chevron_left_rounded,
                                      size: 24.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 40.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      iconColor: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      color: Color(0x00FFFFFF),
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            font: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w300,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w300,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                      elevation: 0.0,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    height: 120.0,
                                    decoration: BoxDecoration(),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.8, 0.0),
                                          child: Image.asset(
                                            'assets/images/camera.png',
                                            height: 120.0,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            GradientText(
                                              'My',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .displaySmall
                                                      .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondary,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w900,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .fontStyle,
                                                shadows: [
                                                  Shadow(
                                                    color: Color(0x66000000),
                                                    offset: Offset(0.0, 2.0),
                                                    blurRadius: 4.0,
                                                  )
                                                ],
                                              ),
                                              colors: [
                                                Color(0xFF5FB636),
                                                FlutterFlowTheme.of(context)
                                                    .letterGreen,
                                                Color(0xFF347814)
                                              ],
                                              gradientDirection:
                                                  GradientDirection.ttb,
                                              gradientType: GradientType.linear,
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 1.0),
                                              child: GradientText(
                                                'Pictures',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                  font: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w900,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .displaySmall
                                                            .fontStyle,
                                                  ),
                                                  color: Color(0xFF58712B),
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .displaySmall
                                                          .fontStyle,
                                                  shadows: [
                                                    Shadow(
                                                      color: Color(0x66000000),
                                                      offset: Offset(0.0, 2.0),
                                                      blurRadius: 4.0,
                                                    )
                                                  ],
                                                ),
                                                colors: [
                                                  Color(0xFF5FB636),
                                                  FlutterFlowTheme.of(context)
                                                      .letterGreen,
                                                  Color(0xFF347814)
                                                ],
                                                gradientDirection:
                                                    GradientDirection.ttb,
                                                gradientType:
                                                    GradientType.linear,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  'Me in Action',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    if (_model.yourChildAction ==
                                                            null ||
                                                        _model.yourChildAction ==
                                                            '') {
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          _model.meInAction =
                                                              true;
                                                          safeSetState(() {});
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            allowPhoto: true,
                                                            includeBlurHash:
                                                                true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading_uploadDataMe3 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            var downloadUrls =
                                                                <String>[];
                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                            originalFilename:
                                                                                m.originalFilename,
                                                                          ))
                                                                      .toList();

                                                              downloadUrls =
                                                                  (await Future
                                                                          .wait(
                                                                selectedMedia
                                                                    .map(
                                                                  (m) async =>
                                                                      await uploadData(
                                                                          m.storagePath,
                                                                          m.bytes),
                                                                ),
                                                              ))
                                                                      .where((u) =>
                                                                          u !=
                                                                          null)
                                                                      .map((u) =>
                                                                          u!)
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading_uploadDataMe3 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length &&
                                                                downloadUrls
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile_uploadDataMe3 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                                _model.uploadedFileUrl_uploadDataMe3 =
                                                                    downloadUrls
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }

                                                          _model.yourChildAction =
                                                              _model
                                                                  .uploadedFileUrl_uploadDataMe3;
                                                          _model.meInAction =
                                                              false;
                                                          _model.the3hash = _model
                                                              .uploadedLocalFile_uploadDataMe3
                                                              .blurHash;
                                                          safeSetState(() {});
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 180.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            children: [
                                                              if (_model
                                                                      .meInAction ==
                                                                  false)
                                                                Icon(
                                                                  Icons
                                                                      .file_upload_outlined,
                                                                  color: Color(
                                                                      0xFF757575),
                                                                  size: 24.0,
                                                                ),
                                                              if (_model
                                                                      .meInAction ==
                                                                  true)
                                                                Lottie.asset(
                                                                  'assets/jsons/Lawnmower.json',
                                                                  width: 200.0,
                                                                  height: 200.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  animate: true,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: OctoImage(
                                                          placeholderBuilder:
                                                              (_) => SizedBox
                                                                  .expand(
                                                            child: Image(
                                                              image: BlurHashImage(
                                                                  _model
                                                                      .the1hash!),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          image: NetworkImage(
                                                            valueOrDefault<
                                                                String>(
                                                              _model
                                                                  .uploadedFileUrl_uploadDataMe3,
                                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Closeup_of_lawn_grass.jpg/1200px-Closeup_of_lawn_grass.jpg',
                                                            ),
                                                          ),
                                                          width: 150.0,
                                                          height: 200.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  'Me With Home Owner',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondary,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    if (_model.owerPhoto ==
                                                            null ||
                                                        _model.owerPhoto ==
                                                            '') {
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          _model.meNHomeOwner =
                                                              true;
                                                          safeSetState(() {});
                                                          final selectedMedia =
                                                              await selectMediaWithSourceBottomSheet(
                                                            context: context,
                                                            allowPhoto: true,
                                                            includeBlurHash:
                                                                true,
                                                          );
                                                          if (selectedMedia !=
                                                                  null &&
                                                              selectedMedia.every((m) =>
                                                                  validateFileFormat(
                                                                      m.storagePath,
                                                                      context))) {
                                                            safeSetState(() =>
                                                                _model.isDataUploading_uploadDataMe4 =
                                                                    true);
                                                            var selectedUploadedFiles =
                                                                <FFUploadedFile>[];

                                                            var downloadUrls =
                                                                <String>[];
                                                            try {
                                                              selectedUploadedFiles =
                                                                  selectedMedia
                                                                      .map((m) =>
                                                                          FFUploadedFile(
                                                                            name:
                                                                                m.storagePath.split('/').last,
                                                                            bytes:
                                                                                m.bytes,
                                                                            height:
                                                                                m.dimensions?.height,
                                                                            width:
                                                                                m.dimensions?.width,
                                                                            blurHash:
                                                                                m.blurHash,
                                                                            originalFilename:
                                                                                m.originalFilename,
                                                                          ))
                                                                      .toList();

                                                              downloadUrls =
                                                                  (await Future
                                                                          .wait(
                                                                selectedMedia
                                                                    .map(
                                                                  (m) async =>
                                                                      await uploadData(
                                                                          m.storagePath,
                                                                          m.bytes),
                                                                ),
                                                              ))
                                                                      .where((u) =>
                                                                          u !=
                                                                          null)
                                                                      .map((u) =>
                                                                          u!)
                                                                      .toList();
                                                            } finally {
                                                              _model.isDataUploading_uploadDataMe4 =
                                                                  false;
                                                            }
                                                            if (selectedUploadedFiles
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length &&
                                                                downloadUrls
                                                                        .length ==
                                                                    selectedMedia
                                                                        .length) {
                                                              safeSetState(() {
                                                                _model.uploadedLocalFile_uploadDataMe4 =
                                                                    selectedUploadedFiles
                                                                        .first;
                                                                _model.uploadedFileUrl_uploadDataMe4 =
                                                                    downloadUrls
                                                                        .first;
                                                              });
                                                            } else {
                                                              safeSetState(
                                                                  () {});
                                                              return;
                                                            }
                                                          }

                                                          _model.owerPhoto = _model
                                                              .uploadedFileUrl_uploadDataMe4;
                                                          _model.meNHomeOwner =
                                                              false;
                                                          _model.the4hash = _model
                                                              .uploadedLocalFile_uploadDataMe4
                                                              .blurHash;
                                                          safeSetState(() {});
                                                        },
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          height: 180.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Stack(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    0.0, 0.0),
                                                            children: [
                                                              if (_model
                                                                      .meNHomeOwner ==
                                                                  false)
                                                                Icon(
                                                                  Icons
                                                                      .file_upload_outlined,
                                                                  color: Color(
                                                                      0xFF757575),
                                                                  size: 24.0,
                                                                ),
                                                              if (_model
                                                                      .meNHomeOwner !=
                                                                  false)
                                                                Lottie.asset(
                                                                  'assets/jsons/Lawnmower.json',
                                                                  width: 200.0,
                                                                  height: 200.0,
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  animate: true,
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: OctoImage(
                                                          placeholderBuilder:
                                                              (_) => SizedBox
                                                                  .expand(
                                                            child: Image(
                                                              image: BlurHashImage(
                                                                  _model
                                                                      .the4hash!),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          image: NetworkImage(
                                                            valueOrDefault<
                                                                String>(
                                                              _model
                                                                  .uploadedFileUrl_uploadDataMe4,
                                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Closeup_of_lawn_grass.jpg/1200px-Closeup_of_lawn_grass.jpg',
                                                            ),
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          height: 200.0,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ].divide(SizedBox(height: 20.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 40.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 0.0, 20.0, 0.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10.0,
                                        sigmaY: 10.0,
                                      ),
                                      child: FFButtonWidget(
                                        onPressed: ((_model.yourChildAction ==
                                                        null ||
                                                    _model.yourChildAction ==
                                                        '') ||
                                                (_model.owerPhoto == null ||
                                                    _model.owerPhoto == ''))
                                            ? null
                                            : () async {
                                                await _model.pageViewController
                                                    ?.nextPage(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  curve: Curves.ease,
                                                );
                                              },
                                        text: 'Done',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 50.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: Color(0xB5F9F9F9),
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40.0),
                                          disabledColor: Color(0x665F6B4B),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                                  .divide(SizedBox(height: 40.0))
                                  .addToStart(SizedBox(height: 60.0))
                                  .addToEnd(SizedBox(height: 40.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/Vector_19.png',
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 1.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/4fa4229e-5726-4d8b-9f8f-0d82ad13d3c4_5-2.png',
                                        height: 70.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(1.8, 1.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/beegrass.png',
                                        width: 300.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        AlignmentDirectional(0.62, -0.28),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/butterfly.png',
                                        width: 70.0,
                                        height: 70.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10.0, 0.0, 10.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional(-1.0, -0.8),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              context.safePop();
                                            },
                                            text: 'Back',
                                            icon: Icon(
                                              Icons.chevron_left_rounded,
                                              size: 24.0,
                                            ),
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              iconColor:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              color: Color(0x00FFFFFF),
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(1.0, -0.8),
                                          child: FFButtonWidget(
                                            onPressed: () async {
                                              context.pushNamed(
                                                  HomeScreen.routeName);
                                            },
                                            text: 'Cancel',
                                            options: FFButtonOptions(
                                              height: 40.0,
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 0.0, 16.0, 0.0),
                                              iconPadding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 0.0),
                                              color: Color(0x00FFFFFF),
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .titleSmall
                                                  .override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                              elevation: 0.0,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20.0, 0.0, 20.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Container(
                                              height: 115.0,
                                              decoration: BoxDecoration(),
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, -1.0),
                                                    child: GradientText(
                                                      'I AM',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displayMedium
                                                              .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displayMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF58712B),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .displayMedium
                                                                .fontStyle,
                                                        shadows: [
                                                          Shadow(
                                                            color: Color(
                                                                0x66000000),
                                                            offset: Offset(
                                                                0.0, 2.0),
                                                            blurRadius: 4.0,
                                                          )
                                                        ],
                                                      ),
                                                      colors: [
                                                        Color(0xFF5FB636),
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .letterGreen,
                                                        Color(0xFF347814)
                                                      ],
                                                      gradientDirection:
                                                          GradientDirection.ttb,
                                                      gradientType:
                                                          GradientType.linear,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 1.0),
                                                    child: GradientText(
                                                      'Ready to',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displayMedium
                                                              .override(
                                                        font:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .displayMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            Color(0xFF3A4A1D),
                                                        fontSize: 56.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .displayMedium
                                                                .fontStyle,
                                                        shadows: [
                                                          Shadow(
                                                            color: Color(
                                                                0x66000000),
                                                            offset: Offset(
                                                                0.0, 2.0),
                                                            blurRadius: 4.0,
                                                          )
                                                        ],
                                                      ),
                                                      colors: [
                                                        Color(0xFF5FB636),
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .letterGreen,
                                                        Color(0xFF347814)
                                                      ],
                                                      gradientDirection:
                                                          GradientDirection.ttb,
                                                      gradientType:
                                                          GradientType.linear,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 72.0,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 5.0,
                                                  color: Colors.white,
                                                  offset: Offset(
                                                    0.0,
                                                    1.0,
                                                  ),
                                                  spreadRadius: 1.0,
                                                )
                                              ],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFABF186),
                                                  Color(0xB24FAB24),
                                                  Color(0xFF4FAB24),
                                                  Color(0xFF317912)
                                                ],
                                                stops: [0.05, 0.3, 0.8, 1.0],
                                                begin: AlignmentDirectional(
                                                    0.0, -1.0),
                                                end: AlignmentDirectional(
                                                    0, 1.0),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                            ),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                var lawnsRecordReference =
                                                    LawnsRecord.collection
                                                        .doc();
                                                await lawnsRecordReference
                                                    .set(createLawnsRecordData(
                                                  userRef: currentUserReference,
                                                  whoFor: _model.dropDownValue,
                                                  hoursTaken:
                                                      _model.hours.toDouble(),
                                                  status: 'Not Verify',
                                                  createdAt:
                                                      getCurrentTimestamp,
                                                  updatedAt:
                                                      getCurrentTimestamp,
                                                  photos:
                                                      updateLawnsPhotosStruct(
                                                    LawnsPhotosStruct(
                                                      before: PhotoDetailStruct(
                                                        image:
                                                            _model.beforeLawn,
                                                        hashCodeImage:
                                                            _model.the1hash,
                                                      ),
                                                      after: PhotoDetailStruct(
                                                        image: _model.afterLawn,
                                                        hashCodeImage:
                                                            _model.the2hash,
                                                      ),
                                                      action: PhotoDetailStruct(
                                                        image: _model
                                                            .yourChildAction,
                                                        hashCodeImage:
                                                            _model.the3hash,
                                                      ),
                                                      homeowner:
                                                          PhotoDetailStruct(
                                                        image: _model.owerPhoto,
                                                        hashCodeImage:
                                                            _model.the4hash,
                                                      ),
                                                    ),
                                                    clearUnsetFields: false,
                                                    create: true,
                                                  ),
                                                ));
                                                _model.summited = LawnsRecord
                                                    .getDocumentFromData(
                                                        createLawnsRecordData(
                                                          userRef:
                                                              currentUserReference,
                                                          whoFor: _model
                                                              .dropDownValue,
                                                          hoursTaken: _model
                                                              .hours
                                                              .toDouble(),
                                                          status: 'Not Verify',
                                                          createdAt:
                                                              getCurrentTimestamp,
                                                          updatedAt:
                                                              getCurrentTimestamp,
                                                          photos:
                                                              updateLawnsPhotosStruct(
                                                            LawnsPhotosStruct(
                                                              before:
                                                                  PhotoDetailStruct(
                                                                image: _model
                                                                    .beforeLawn,
                                                                hashCodeImage:
                                                                    _model
                                                                        .the1hash,
                                                              ),
                                                              after:
                                                                  PhotoDetailStruct(
                                                                image: _model
                                                                    .afterLawn,
                                                                hashCodeImage:
                                                                    _model
                                                                        .the2hash,
                                                              ),
                                                              action:
                                                                  PhotoDetailStruct(
                                                                image: _model
                                                                    .yourChildAction,
                                                                hashCodeImage:
                                                                    _model
                                                                        .the3hash,
                                                              ),
                                                              homeowner:
                                                                  PhotoDetailStruct(
                                                                image: _model
                                                                    .owerPhoto,
                                                                hashCodeImage:
                                                                    _model
                                                                        .the4hash,
                                                              ),
                                                            ),
                                                            clearUnsetFields:
                                                                false,
                                                            create: true,
                                                          ),
                                                        ),
                                                        lawnsRecordReference);

                                                await currentUserReference!
                                                    .update({
                                                  ...mapToFirestore(
                                                    {
                                                      'total_hours':
                                                          FieldValue.increment(
                                                              _model.hours
                                                                  .toDouble()),
                                                      'total_lawns':
                                                          FieldValue.increment(
                                                              1),
                                                    },
                                                  ),
                                                });
                                                if (valueOrDefault(
                                                        currentUserDocument
                                                            ?.totalLawns,
                                                        0) ==
                                                    40) {
                                                  await currentUserReference!
                                                      .update(
                                                          createUsersRecordData(
                                                    isHallOfFame: true,
                                                  ));
                                                }

                                                context.pushNamed(
                                                    HomeScreen.routeName);

                                                safeSetState(() {});
                                              },
                                              text: 'SUBMIT',
                                              options: FFButtonOptions(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color: Color(0x4C458B24),
                                                textStyle: FlutterFlowTheme.of(
                                                        context)
                                                    .headlineSmall
                                                    .override(
                                                      font: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmall
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .greenWhite,
                                                      letterSpacing: 1.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineSmall
                                                              .fontStyle,
                                                    ),
                                                elevation: 0.0,
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 80.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
