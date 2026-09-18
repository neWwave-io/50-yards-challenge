import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/component/btn_for_new_ver/btn_for_new_ver_widget.dart';
import '/component/edit_child/edit_child_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/upload_data.dart';
import 'dart:ui';
import '/index.dart';
import 'dart:math' as math;
import 'profile_edit_widget.dart' show ProfileEditWidget;
import '/backend/supabase_compat/compat_types.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ProfileEditModel extends FlutterFlowModel<ProfileEditWidget> {
  ///  Local state fields for this page.

  String? image;

  String? hashcode;

  List<JoinGroupStruct> groupDetailInfo = [];
  void addToGroupDetailInfo(JoinGroupStruct item) => groupDetailInfo.add(item);
  void removeFromGroupDetailInfo(JoinGroupStruct item) =>
      groupDetailInfo.remove(item);
  void removeAtIndexFromGroupDetailInfo(int index) =>
      groupDetailInfo.removeAt(index);
  void insertAtIndexInGroupDetailInfo(int index, JoinGroupStruct item) =>
      groupDetailInfo.insert(index, item);
  void updateGroupDetailInfoAtIndex(
          int index, Function(JoinGroupStruct) updateFn) =>
      groupDetailInfo[index] = updateFn(groupDetailInfo[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for name widget.
  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;
  String? Function(BuildContext, String?)? nameTextControllerValidator;
  // State field(s) for childname widget.
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
  // State field(s) for city widget.
  FocusNode? cityFocusNode;
  TextEditingController? cityTextController;
  String? Function(BuildContext, String?)? cityTextControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  bool isDataUploading_uploadDataAm0 = false;
  FFUploadedFile uploadedLocalFile_uploadDataAm0 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataAm0 = '';

  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel1;
  // State field(s) for pass widget.
  FocusNode? passFocusNode1;
  TextEditingController? passTextController1;
  late bool passVisibility1;
  String? Function(BuildContext, String?)? passTextController1Validator;
  // State field(s) for pass widget.
  FocusNode? passFocusNode2;
  TextEditingController? passTextController2;
  late bool passVisibility2;
  String? Function(BuildContext, String?)? passTextController2Validator;
  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel2;

  @override
  void initState(BuildContext context) {
    btnForNewVerModel1 = createModel(context, () => BtnForNewVerModel());
    passVisibility1 = false;
    passVisibility2 = false;
    btnForNewVerModel2 = createModel(context, () => BtnForNewVerModel());
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();

    childnameFocusNode?.dispose();
    childnameTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    cityFocusNode?.dispose();
    cityTextController?.dispose();

    btnForNewVerModel1.dispose();
    passFocusNode1?.dispose();
    passTextController1?.dispose();

    passFocusNode2?.dispose();
    passTextController2?.dispose();

    btnForNewVerModel2.dispose();
  }
}
