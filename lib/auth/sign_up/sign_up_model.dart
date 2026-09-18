import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/component/add_child/add_child_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'dart:math' as math;
import 'sign_up_widget.dart' show SignUpWidget;
import '/backend/supabase_compat/compat_types.dart';
import 'package:collection/collection.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  ///  Local state fields for this page.

  String? shirtSize;

  String? image;

  FFUploadedFile? profile;

  String? hashImageCode;

  bool multipleChildren = false;

  List<JoinGroupStruct> groupDetail = [];
  void addToGroupDetail(JoinGroupStruct item) => groupDetail.add(item);
  void removeFromGroupDetail(JoinGroupStruct item) => groupDetail.remove(item);
  void removeAtIndexFromGroupDetail(int index) => groupDetail.removeAt(index);
  void insertAtIndexInGroupDetail(int index, JoinGroupStruct item) =>
      groupDetail.insert(index, item);
  void updateGroupDetailAtIndex(
          int index, Function(JoinGroupStruct) updateFn) =>
      groupDetail[index] = updateFn(groupDetail[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in signUp widget.
  SettingsRecord? setting;
  // State field(s) for name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for Childname widget.
  FocusNode? childnameFocusNode;
  TextEditingController? childnameTextController;
  String? Function(BuildContext, String?)? childnameTextControllerValidator;
  // State field(s) for gender widget.
  String? genderValue;
  FormFieldController<String>? genderValueController;
  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for pass widget.
  FocusNode? passFocusNode;
  TextEditingController? passTextController;
  late bool passVisibility;
  String? Function(BuildContext, String?)? passTextControllerValidator;
  // State field(s) for pass2 widget.
  FocusNode? pass2FocusNode;
  TextEditingController? pass2TextController;
  late bool pass2Visibility;
  String? Function(BuildContext, String?)? pass2TextControllerValidator;
  // State field(s) for city widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  // State field(s) for state widget.
  String? stateValue;
  FormFieldController<String>? stateValueController;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  bool isDataUploading_uploadDataKw9 = false;
  FFUploadedFile uploadedLocalFile_uploadDataKw9 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_uploadDataI = false;
  FFUploadedFile uploadedLocalFile_uploadDataI =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_uploadDataXjl = false;
  FFUploadedFile uploadedLocalFile_uploadDataXjl =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataXjl = '';

  @override
  void initState(BuildContext context) {
    passVisibility = false;
    pass2Visibility = false;
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    childnameFocusNode?.dispose();
    childnameTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    passFocusNode?.dispose();
    passTextController?.dispose();

    pass2FocusNode?.dispose();
    pass2TextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    expandableExpandableController.dispose();
  }
}
