import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/component/btn_for_new_ver/btn_for_new_ver_widget.dart';
import '/component/edit_record/edit_record_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'achivement_widget.dart' show AchivementWidget;
import 'dart:math' as math;
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class AchivementModel extends FlutterFlowModel<AchivementWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel1;
  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel2;

  @override
  void initState(BuildContext context) {
    btnForNewVerModel1 = createModel(context, () => BtnForNewVerModel());
    btnForNewVerModel2 = createModel(context, () => BtnForNewVerModel());
  }

  @override
  void dispose() {
    btnForNewVerModel1.dispose();
    btnForNewVerModel2.dispose();
  }
}
