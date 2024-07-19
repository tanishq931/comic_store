import 'dart:io';

import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class PDFScreen extends StatefulWidget {
  final String url;
  final String title;

  const PDFScreen({super.key,required this.url,required this.title});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String pdfPath = "";
  bool isLoading = true;
  int? currIndex =0;
  int? totalPages= 0;

  @override
  void initState() {
    super.initState();
    downloadPDF(widget.url).then((file) {
      setState(() {
        pdfPath = file.path;
        isLoading = false;
      });
    });
  }

  Future downloadPDF(String url) async {
    try {
      Dio dio = Dio();
      var dir = await getApplicationDocumentsDirectory();
      String suffix = url.split('/').last;
      String fileName = suffix.split('?').first;
      File file = File("${dir.path}/$fileName");
      await dio.download(url, file.path);
      return file;
    } catch (e) {
      throw Exception("Error downloading PDF file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: widget.title),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
            children: [
              PDFView(
                      swipeHorizontal: true,
                      filePath: pdfPath,
                      onPageChanged: (index,last){
                            setState(() {
                              currIndex = index;
                              totalPages = last;
                            });
                      },
                    ),
              Positioned(
                  top:0,
                  right: 0,
                  child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                color: Colors.black,
                child: Text('${currIndex! + 1}/$totalPages',style: heading(),),

              ))
            ],
          ),
    );
  }
}
