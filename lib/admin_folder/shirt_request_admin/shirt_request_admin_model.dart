import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/components/shirt_request_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'shirt_request_admin_widget.dart' show ShirtRequestAdminWidget;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ShirtRequestAdminModel extends FlutterFlowModel<ShirtRequestAdminWidget> {
  ///  Local state fields for this page.

  List<ShirtRequestsRecord> request = [];
  void addToRequest(ShirtRequestsRecord item) => request.add(item);
  void removeFromRequest(ShirtRequestsRecord item) => request.remove(item);
  void removeAtIndexFromRequest(int index) => request.removeAt(index);
  void insertAtIndexInRequest(int index, ShirtRequestsRecord item) =>
      request.insert(index, item);
  void updateRequestAtIndex(
          int index, Function(ShirtRequestsRecord) updateFn) =>
      request[index] = updateFn(request[index]);

  String? status;

  List<ShirtRequestsRecord> pending = [];
  void addToPending(ShirtRequestsRecord item) => pending.add(item);
  void removeFromPending(ShirtRequestsRecord item) => pending.remove(item);
  void removeAtIndexFromPending(int index) => pending.removeAt(index);
  void insertAtIndexInPending(int index, ShirtRequestsRecord item) =>
      pending.insert(index, item);
  void updatePendingAtIndex(
          int index, Function(ShirtRequestsRecord) updateFn) =>
      pending[index] = updateFn(pending[index]);

  List<ShirtRequestsRecord> approved = [];
  void addToApproved(ShirtRequestsRecord item) => approved.add(item);
  void removeFromApproved(ShirtRequestsRecord item) => approved.remove(item);
  void removeAtIndexFromApproved(int index) => approved.removeAt(index);
  void insertAtIndexInApproved(int index, ShirtRequestsRecord item) =>
      approved.insert(index, item);
  void updateApprovedAtIndex(
          int index, Function(ShirtRequestsRecord) updateFn) =>
      approved[index] = updateFn(approved[index]);

  List<ShirtRequestsRecord> rejected = [];
  void addToRejected(ShirtRequestsRecord item) => rejected.add(item);
  void removeFromRejected(ShirtRequestsRecord item) => rejected.remove(item);
  void removeAtIndexFromRejected(int index) => rejected.removeAt(index);
  void insertAtIndexInRejected(int index, ShirtRequestsRecord item) =>
      rejected.insert(index, item);
  void updateRejectedAtIndex(
          int index, Function(ShirtRequestsRecord) updateFn) =>
      rejected[index] = updateFn(rejected[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in ShirtRequestAdmin widget.
  List<ShirtRequestsRecord>? shirtsRequest;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    tabBarController?.dispose();
  }
}
