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
import 'edit_record_widget.dart' show EditRecordWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';

class EditRecordModel extends FlutterFlowModel<EditRecordWidget> {
  ///  Local state fields for this component.

  String? image1;

  String? iamge2;

  String? image3;

  String? image4;

  String? hash1;

  String? hash2;

  String? hash3;

  String? hash4;

  bool laoding = false;

  double? hours;

  ///  State fields for stateful widgets in this component.

  // State field(s) for who widget.
  String? whoValue;
  FormFieldController<String>? whoValueController;
  bool isDataUploading_uploadDataBefore = false;
  FFUploadedFile uploadedLocalFile_uploadDataBefore =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataBefore = '';

  bool isDataUploading_uploadDataAfter = false;
  FFUploadedFile uploadedLocalFile_uploadDataAfter =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataAfter = '';

  bool isDataUploading_uploadDataAction = false;
  FFUploadedFile uploadedLocalFile_uploadDataAction =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataAction = '';

  bool isDataUploading_uploadDataOwner = false;
  FFUploadedFile uploadedLocalFile_uploadDataOwner =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataOwner = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
