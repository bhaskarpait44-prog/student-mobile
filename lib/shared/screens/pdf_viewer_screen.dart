import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../core/theme/app_colors.dart';

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final Uint8List? pdfBytes;
  final String? url;

  const PdfViewerScreen({
    super.key,
    required this.title,
    this.pdfBytes,
    this.url,
  }) : assert(pdfBytes != null || url != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: pdfBytes != null
          ? SfPdfViewer.memory(pdfBytes!)
          : SfPdfViewer.network(url!),
    );
  }
}
