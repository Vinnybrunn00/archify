import 'package:archify/core/services/files_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:archify/constants/constants_color.dart';

class PdfViewer extends StatefulWidget {
  final String path; // caminho do arquivo PDF
  final String nameFile;

  const PdfViewer({super.key, required this.path, required this.nameFile});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  int totalPages = 0;
  int currentPage = 0;
  bool isReady = false;
  PDFViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        title: Text(widget.path.split('/').last),
        actionsPadding: EdgeInsets.only(right: 20),
        actions: [
          InkWell(
            onTap: () async {
              final FilesServices filesServices = FilesServices();
              await filesServices.onShareOnlyFile(widget.path, widget.nameFile);
            },
            child: Icon(Icons.share),
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            onRender: (pages) {
              setState(() {
                totalPages = pages ?? 0;
                isReady = true;
              });
            },
            onViewCreated: (pdfViewController) {
              controller = pdfViewController;
            },
            onPageChanged: (page, total) {
              setState(() {
                currentPage = page ?? 0;
                totalPages = total ?? 0;
              });
            },
            onError: (error) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Erro: $error')));
            },
            onPageError: (page, error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro na página $page: $error')),
              );
            },
          ),
          if (!isReady) const Center(child: CircularProgressIndicator()),
          if (isReady)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 30),
                    onPressed: currentPage > 0
                        ? () => controller?.setPage(currentPage - 1)
                        : null,
                  ),
                  Text(
                    '${currentPage + 1} / $totalPages',
                    style: const TextStyle(
                      color: AppColor.blackBlueLow,
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 30),
                    onPressed: currentPage < totalPages - 1
                        ? () => controller?.setPage(currentPage + 1)
                        : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
