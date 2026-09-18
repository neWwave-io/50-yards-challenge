import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/component/notification_pop_up/notification_pop_up_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'home_admin_widget.dart' show HomeAdminWidget;
import '/backend/supabase_compat/compat_types.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomeAdminModel extends FlutterFlowModel<HomeAdminWidget> {
  ///  Local state fields for this page.

  List<UsersRecord> user = [];
  void addToUser(UsersRecord item) => user.add(item);
  void removeFromUser(UsersRecord item) => user.remove(item);
  void removeAtIndexFromUser(int index) => user.removeAt(index);
  void insertAtIndexInUser(int index, UsersRecord item) =>
      user.insert(index, item);
  void updateUserAtIndex(int index, Function(UsersRecord) updateFn) =>
      user[index] = updateFn(user[index]);

  int? newUserThisMonth;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in HomeAdmin widget.
  List<UsersRecord>? allUsers;
  // Stores action output result for [Custom Action - newUsers] action in HomeAdmin widget.
  int? newUsers;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
