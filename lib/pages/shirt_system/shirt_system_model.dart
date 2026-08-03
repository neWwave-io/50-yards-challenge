import '/component/btn_for_new_ver/btn_for_new_ver_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'dart:math' as math;
import 'shirt_system_widget.dart' show ShirtSystemWidget;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ShirtSystemModel extends FlutterFlowModel<ShirtSystemWidget> {
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
