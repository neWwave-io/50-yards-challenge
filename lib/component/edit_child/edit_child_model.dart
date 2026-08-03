import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'edit_child_widget.dart' show EditChildWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditChildModel extends FlutterFlowModel<EditChildWidget> {
  ///  Local state fields for this component.

  String? shirtSize;

  ///  State fields for stateful widgets in this component.

  // State field(s) for Childname widget.
  FocusNode? childnameFocusNode;
  TextEditingController? childnameTextController;
  String? Function(BuildContext, String?)? childnameTextControllerValidator;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    childnameFocusNode?.dispose();
    childnameTextController?.dispose();

    expandableExpandableController.dispose();
  }
}
