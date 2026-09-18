import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/component/admin/user_tag/user_tag_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/backend/supabase_compat/compat_types.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_hall_of_fame_model.dart';
export 'add_hall_of_fame_model.dart';

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
class AddHallOfFameWidget extends StatefulWidget {
  const AddHallOfFameWidget({
    super.key,
    required this.users,
    this.action,
  });

  final List<UsersRecord>? users;
  final Future Function(UsersRecord doc)? action;

  @override
  State<AddHallOfFameWidget> createState() => _AddHallOfFameWidgetState();
}

class _AddHallOfFameWidgetState extends State<AddHallOfFameWidget> {
  late AddHallOfFameModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddHallOfFameModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.users = widget!.users!.toList().cast<UsersRecord>();
      safeSetState(() {});
    });

    _model.childnameTextController ??= TextEditingController();
    _model.childnameFocusNode ??= FocusNode();
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
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0x9A5D844B),
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add Our Superhero',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                font: GoogleFonts.poppins(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.childnameTextController,
                                    focusNode: _model.childnameFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.childnameTextController',
                                      Duration(milliseconds: 300),
                                      () async {
                                        _model.users = widget!.users!
                                            .where((e) =>
                                                functions.searchName(
                                                    e.displayName,
                                                    _model
                                                        .childnameTextController
                                                        .text)! ||
                                                functions.searchName(
                                                    e.state,
                                                    _model
                                                        .childnameTextController
                                                        .text)!)
                                            .toList()
                                            .cast<UsersRecord>();
                                        safeSetState(() {});
                                      },
                                    ),
                                    autofocus: false,
                                    enabled: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.poppins(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                      hintText: 'Name',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            font: GoogleFonts.poppins(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF757575),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      filled: true,
                                      fillColor: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    enableInteractiveSelection: true,
                                    validator: _model
                                        .childnameTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ].divide(SizedBox(height: 5.0)),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Builder(
                                  builder: (context) {
                                    if (_model.selectedUser == null) {
                                      return Container(
                                        height: 425.0,
                                        decoration: BoxDecoration(),
                                        child: Builder(
                                          builder: (context) {
                                            final allusers =
                                                _model.users.toList();

                                            return SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                        allusers.length,
                                                        (allusersIndex) {
                                                  final allusersItem =
                                                      allusers[allusersIndex];
                                                  return ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40.0),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                        sigmaX: 5.0,
                                                        sigmaY: 5.0,
                                                      ),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 180.0,
                                                        decoration:
                                                            BoxDecoration(),
                                                        child: UserTagWidget(
                                                          key: Key(
                                                              'Key0a8_${allusersIndex}_of_${allusers.length}'),
                                                          profile: allusersItem
                                                              .userProfile
                                                              .image,
                                                          hashCodeImage:
                                                              allusersItem
                                                                  .userProfile
                                                                  .hashCodeImage,
                                                          name: allusersItem
                                                              .displayName,
                                                          state: allusersItem
                                                              .state,
                                                          lawns: valueOrDefault<
                                                              int>(
                                                            allusersItem
                                                                .totalLawns,
                                                            1,
                                                          ),
                                                          hours: valueOrDefault<
                                                              double>(
                                                            allusersItem
                                                                .totalHours,
                                                            1.0,
                                                          ),
                                                          userDoc: allusersItem,
                                                          isSelected: false,
                                                          action:
                                                              (userdoc) async {
                                                            _model.selectedUser =
                                                                userdoc;
                                                            safeSetState(() {});
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })
                                                    .divide(
                                                        SizedBox(height: 20.0))
                                                    .addToEnd(
                                                        SizedBox(height: 60.0)),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      return wrapWithModel(
                                        model: _model.userTagModel2,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: UserTagWidget(
                                          profile: _model
                                              .selectedUser?.userProfile?.image,
                                          hashCodeImage: _model.selectedUser
                                              ?.userProfile?.hashCodeImage,
                                          name:
                                              _model.selectedUser?.displayName,
                                          state: _model.selectedUser?.state,
                                          lawns:
                                              _model.selectedUser?.totalLawns,
                                          hours:
                                              _model.selectedUser?.totalHours,
                                          isSelected: true,
                                          action: (userdoc) async {},
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        text: 'Cancel',
                                        options: FFButtonOptions(
                                          width: 140.0,
                                          height: 48.0,
                                          padding: EdgeInsets.all(8.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: Color(0xFFE0E3E7),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          await _model.selectedUser!.reference
                                              .update(createUsersRecordData(
                                            isHallOfFame: true,
                                          ));
                                          await widget.action?.call(
                                            _model.selectedUser!,
                                          );
                                          Navigator.pop(context);
                                        },
                                        text: 'Submit',
                                        options: FFButtonOptions(
                                          width: 140.0,
                                          height: 48.0,
                                          padding: EdgeInsets.all(8.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .generalGreen,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 16.0)),
                                ),
                              ].divide(SizedBox(height: 10.0)),
                            ),
                          ].divide(SizedBox(height: 20.0)),
                        ),
                      ].divide(SizedBox(height: 20.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
