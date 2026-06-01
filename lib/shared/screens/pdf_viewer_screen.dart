import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/app_colors.dart';

class PdfViewerScreen extends StatefulWidget {
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
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isDownloading = false;

  Future<void> _downloadPdf() async {
    if (widget.url == null) return;

    if (Platform.isAndroid) {
      final statuses = await [
        Permission.storage,
        Permission.photos,
        Permission.videos,
        Permission.audio,
      ].request();
      
      final granted = statuses[Permission.storage]!.isGranted || 
                     statuses[Permission.photos]!.isGranted;

      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission is required to download files.')),
          );
        }
        return;
      }
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final fileName = widget.url!.split('/').last;
      final savePath = '${directory!.path}/$fileName';

      final dio = Dio();
      await dio.download(
        widget.url!,
        savePath,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File downloaded successfully to: $savePath'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (widget.url != null)
            IconButton(
              icon: _isDownloading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.download),
              onPressed: _isDownloading ? null : _downloadPdf,
              tooltip: 'Download PDF',
            ),
        ],
      ),
      body: widget.pdfBytes != null
          ? SfPdfViewer.memory(widget.pdfBytes!)
          : SfPdfViewer.network(widget.url!),
    );
  }
}
