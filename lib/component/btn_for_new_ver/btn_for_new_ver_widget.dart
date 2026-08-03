import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'btn_for_new_ver_model.dart';
export 'btn_for_new_ver_model.dart';

class BtnForNewVerWidget extends StatefulWidget {
  const BtnForNewVerWidget({
    super.key,
    required this.action,
    required this.title,
    required this.fontSize,
    this.icon,
  });

  final Future Function()? action;
  final String? title;
  final int? fontSize;
  final Widget? icon;

  @override
  State<BtnForNewVerWidget> createState() => _BtnForNewVerWidgetState();
}

class _BtnForNewVerWidgetState extends State<BtnForNewVerWidget> {
  late BtnForNewVerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BtnForNewVerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.white,
            offset: Offset(
              0.0,
              1.0,
            ),
            spreadRadius: 1.0,
          )
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xFFABF186),
            Color(0xB24FAB24),
            Color(0xFF4FAB24),
            Color(0xFF317912)
          ],
          stops: [0.05, 0.3, 0.8, 1.0],
          begin: AlignmentDirectional(0.0, -1.0),
          end: AlignmentDirectional(0, 1.0),
        ),
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: FFButtonWidget(
          onPressed: () async {
            await widget.action?.call();
          },
          text: widget!.title!,
          icon: widget!.icon,
          options: FFButtonOptions(
            width: double.infinity,
            height: 56.0,
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            iconAlignment: IconAlignment.start,
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: Color(0x4C458B24),
            textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: widget!.fontSize?.toDouble(),
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.normal,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
            elevation: 4.0,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }
}
