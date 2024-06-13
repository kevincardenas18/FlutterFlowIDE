// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';
import 'package:epub_view/epub_view.dart';
import 'package:universal_file/universal_file.dart';

class EpubReader extends StatefulWidget {
  const EpubReader({
    Key? key,
    this.width,
    this.height,
    required this.assetPath,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String assetPath;

  @override
  State<EpubReader> createState() => _EpubReaderState();
}

class _EpubReaderState extends State<EpubReader> {
  late EpubController _epubController;
  bool _isDarkMode = false;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _epubController = EpubController(
      // document: EpubDocument.openAsset(widget.assetPath),
      document: EpubDocument.openFile(File(widget.assetPath)),
    );
  }

  @override
  void dispose() {
    _epubController.dispose();
    super.dispose();
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _changeFontSize(double delta) {
    setState(() {
      _fontSize = (_fontSize + delta).clamp(12.0, 24.0);
    });
  }

  void _showTableOfContents(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        child: EpubViewTableOfContents(controller: _epubController),
      ),
    );
  }

  void _showCurrentEpubCfi(BuildContext context) {
    final cfi = _epubController.generateEpubCfi();

    if (cfi != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bookmark added: $cfi'),
          action: SnackBarAction(
            label: 'GO',
            onPressed: () {
              _epubController.gotoEpubCfi(cfi);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.brightness_6),
                onPressed: _toggleDarkMode,
              ),
              IconButton(
                icon: Icon(Icons.text_decrease),
                onPressed: () => _changeFontSize(-1),
              ),
              IconButton(
                icon: Icon(Icons.text_increase),
                onPressed: () => _changeFontSize(1),
              ),
              IconButton(
                icon: Icon(Icons.list),
                onPressed: () => _showTableOfContents(context),
              ),
              IconButton(
                icon: Icon(Icons.bookmark),
                onPressed: () => _showCurrentEpubCfi(context),
              ),
            ],
          ),
          Expanded(
            child: EpubView(
              builders: EpubViewBuilders<DefaultBuilderOptions>(
                options: DefaultBuilderOptions(
                  textStyle: TextStyle(
                    fontSize: _fontSize,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                chapterDividerBuilder: (_) => const Divider(),
              ),
              controller: _epubController,
            ),
          ),
        ],
      ),
    );
  }
}
