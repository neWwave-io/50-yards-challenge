import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/component/admin/user_tag/user_tag_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'add_hall_of_fame_widget.dart' show AddHallOfFameWidget;
import '/backend/supabase_compat/compat_types.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddHallOfFameModel extends FlutterFlowModel<AddHallOfFameWidget> {
  ///  Local state fields for this component.

  List<UsersRecord> users = [];
  void addToUsers(UsersRecord item) => users.add(item);
  void removeFromUsers(UsersRecord item) => users.remove(item);
  void removeAtIndexFromUsers(int index) => users.removeAt(index);
  void insertAtIndexInUsers(int index, UsersRecord item) =>
      users.insert(index, item);
  void updateUsersAtIndex(int index, Function(UsersRecord) updateFn) =>
      users[index] = updateFn(users[index]);

  UsersRecord? selectedUser;

  ///  State fields for stateful widgets in this component.

  // State field(s) for childname widget.
  FocusNode? childnameFocusNode;
  TextEditingController? childnameTextController;
  String? Function(BuildContext, String?)? childnameTextControllerValidator;
  // Model for userTag component.
  late UserTagModel userTagModel2;

  @override
  void initState(BuildContext context) {
    userTagModel2 = createModel(context, () => UserTagModel());
  }

  @override
  void dispose() {
    childnameFocusNode?.dispose();
    childnameTextController?.dispose();

    userTagModel2.dispose();
  }
}
