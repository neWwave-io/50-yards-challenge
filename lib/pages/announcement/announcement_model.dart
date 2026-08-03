import '/backend/backend.dart';
import '/backend/schema/enums/enums.dart';
import '/component/btn_for_new_ver/btn_for_new_ver_widget.dart';
import '/component/news/news_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_youtube_player.dart';
import 'dart:ui';
import '/index.dart';
import 'announcement_widget.dart' show AnnouncementWidget;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AnnouncementModel extends FlutterFlowModel<AnnouncementWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for btnForNewVer component.
  late BtnForNewVerModel btnForNewVerModel;

  @override
  void initState(BuildContext context) {
    btnForNewVerModel = createModel(context, () => BtnForNewVerModel());
  }

  @override
  void dispose() {
    btnForNewVerModel.dispose();
  }
}
