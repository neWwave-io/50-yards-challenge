import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/component/admin/add_hall_of_fame/add_hall_of_fame_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'leaderboard_admin_widget.dart' show LeaderboardAdminWidget;
import '/backend/supabase_compat/compat_types.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class LeaderboardAdminModel extends FlutterFlowModel<LeaderboardAdminWidget> {
  ///  Local state fields for this page.

  List<UsersRecord> users = [];
  void addToUsers(UsersRecord item) => users.add(item);
  void removeFromUsers(UsersRecord item) => users.remove(item);
  void removeAtIndexFromUsers(int index) => users.removeAt(index);
  void insertAtIndexInUsers(int index, UsersRecord item) =>
      users.insert(index, item);
  void updateUsersAtIndex(int index, Function(UsersRecord) updateFn) =>
      users[index] = updateFn(users[index]);

  String? state;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in LeaderboardAdmin widget.
  List<UsersRecord>? fameUsers;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
