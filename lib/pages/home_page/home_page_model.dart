import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/component/btn_for_new_ver/btn_for_new_ver_widget.dart';
import '/component/last_work/last_work_widget.dart';
import '/component/nav/nav_widget.dart';
import '/components/shirt_level_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:math' as math;
import 'home_page_widget.dart' show HomePageWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
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

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in HomePage widget.
  List<LawnsRecord>? userLawn;
  // Stores action output result for [Firestore Query - Query a collection] action in HomePage widget.
  SettingsRecord? setting2;
  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel1;
  // Model for Shirt_Level component.
  late ShirtLevelModel shirtLevelModel1;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel2;
  // Model for Shirt_Level component.
  late ShirtLevelModel shirtLevelModel2;
  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel3;
  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel4;
  // Model for Nav component.
  late NavModel navModel;

  @override
  void initState(BuildContext context) {
    btnForNewVerModel1 = createModel(context, () => BtnForNewVerModel());
    shirtLevelModel1 = createModel(context, () => ShirtLevelModel());
    btnForNewVerModel2 = createModel(context, () => BtnForNewVerModel());
    shirtLevelModel2 = createModel(context, () => ShirtLevelModel());
    btnForNewVerModel3 = createModel(context, () => BtnForNewVerModel());
    btnForNewVerModel4 = createModel(context, () => BtnForNewVerModel());
    navModel = createModel(context, () => NavModel());
  }

  @override
  void dispose() {
    btnForNewVerModel1.dispose();
    shirtLevelModel1.dispose();
    btnForNewVerModel2.dispose();
    shirtLevelModel2.dispose();
    btnForNewVerModel3.dispose();
    btnForNewVerModel4.dispose();
    navModel.dispose();
  }
}
