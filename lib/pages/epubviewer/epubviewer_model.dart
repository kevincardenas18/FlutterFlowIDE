import '/flutter_flow/flutter_flow_util.dart';
import 'epubviewer_widget.dart' show EpubviewerWidget;
import 'package:flutter/material.dart';

class EpubviewerModel extends FlutterFlowModel<EpubviewerWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
