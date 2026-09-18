import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/component/nav/nav_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'dart:math' as math;
import 'leader_board_widget.dart' show LeaderBoardWidget;
import 'package:auto_size_text/auto_size_text.dart';
import '/backend/supabase_compat/compat_types.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LeaderBoardModel extends FlutterFlowModel<LeaderBoardWidget> {
  ///  Local state fields for this page.

  bool loading = true;

  List<TopUsersStruct> topUsers = [];
  void addToTopUsers(TopUsersStruct item) => topUsers.add(item);
  void removeFromTopUsers(TopUsersStruct item) => topUsers.remove(item);
  void removeAtIndexFromTopUsers(int index) => topUsers.removeAt(index);
  void insertAtIndexInTopUsers(int index, TopUsersStruct item) =>
      topUsers.insert(index, item);
  void updateTopUsersAtIndex(int index, Function(TopUsersStruct) updateFn) =>
      topUsers[index] = updateFn(topUsers[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Firestore Query - Query a collection] action in LeaderBoard widget.
  LeaderboardsRecord? topusers;
  // Model for Nav component.
  late NavModel navModel;

  @override
  void initState(BuildContext context) {
    navModel = createModel(context, () => NavModel());
  }

  @override
  void dispose() {
    navModel.dispose();
  }
}
