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
import 'submit_lawn_widget.dart' show SubmitLawnWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
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

class SubmitLawnModel extends FlutterFlowModel<SubmitLawnWidget> {
  ///  Local state fields for this page.

  int hours = 0;

  String? beforeLawn;

  String? afterLawn;

  String? yourChildAction;

  String? owerPhoto;

  bool before = false;

  bool after = false;

  bool meInAction = false;

  bool meNHomeOwner = false;

  String? the1hash;

  String? the2hash;

  String? the3hash;

  String? the4hash;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in SubmitLawn widget.
  List<LeaderboardsRecord>? isMe;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // State field(s) for TextFieldhours widget.
  FocusNode? textFieldhoursFocusNode;
  TextEditingController? textFieldhoursTextController;
  String? Function(BuildContext, String?)?
      textFieldhoursTextControllerValidator;
  bool isDataUploading_uploadDataGrass0 = false;
  FFUploadedFile uploadedLocalFile_uploadDataGrass0 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataGrass0 = '';

  bool isDataUploading_uploadDataGrass1 = false;
  FFUploadedFile uploadedLocalFile_uploadDataGrass1 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataGrass1 = '';

  bool isDataUploading_uploadDataMe3 = false;
  FFUploadedFile uploadedLocalFile_uploadDataMe3 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataMe3 = '';

  bool isDataUploading_uploadDataMe4 = false;
  FFUploadedFile uploadedLocalFile_uploadDataMe4 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataMe4 = '';

  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  LawnsRecord? summited;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldhoursFocusNode?.dispose();
    textFieldhoursTextController?.dispose();
  }
}
