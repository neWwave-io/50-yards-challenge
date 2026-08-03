import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/component/congrats_got_shirt/congrats_got_shirt_widget.dart';
import '/component/nav/nav_widget.dart';
import '/component/setting_pop_up/setting_pop_up_widget.dart';
import '/component/spin_shirt/spin_shirt_widget.dart';
import '/components/shirt_level_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
import 'profile_page_widget.dart' show ProfilePageWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class ProfilePageModel extends FlutterFlowModel<ProfilePageWidget> {
  ///  Local state fields for this page.

  List<MowedCategoriesStruct> lawns = [];
  void addToLawns(MowedCategoriesStruct item) => lawns.add(item);
  void removeFromLawns(MowedCategoriesStruct item) => lawns.remove(item);
  void removeAtIndexFromLawns(int index) => lawns.removeAt(index);
  void insertAtIndexInLawns(int index, MowedCategoriesStruct item) =>
      lawns.insert(index, item);
  void updateLawnsAtIndex(
          int index, Function(MowedCategoriesStruct) updateFn) =>
      lawns[index] = updateFn(lawns[index]);

  bool highlight = false;

  bool isload = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in ProfilePage widget.
  List<LawnsRecord>? userLawns;
  // Stores action output result for [Firestore Query - Query a collection] action in ProfilePage widget.
  List<UsersRecord>? admin;
  // State field(s) for bigColumn widget.
  ScrollController? bigColumnScrollController;
  // Model for Shirt_Level component.
  late ShirtLevelModel shirtLevelModel;
  // Stores action output result for [Backend Call - Create Document] action in Button widget.
  ShirtRequestsRecord? shirt;
  // Model for Nav component.
  late NavModel navModel;

  @override
  void initState(BuildContext context) {
    bigColumnScrollController = ScrollController();
    shirtLevelModel = createModel(context, () => ShirtLevelModel());
    navModel = createModel(context, () => NavModel());
  }

  @override
  void dispose() {
    bigColumnScrollController?.dispose();
    shirtLevelModel.dispose();
    navModel.dispose();
  }
}
