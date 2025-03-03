import 'dart:io';

import 'package:comic_store/Comic.dart';
import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/constant/constant.dart';
import 'package:comic_store/provider/DownloadProvider.dart';
import 'package:comic_store/service/LocalStorage.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PDFScreen extends StatefulWidget {
  final dynamic bookDetails;
  final bool isDownloaded;

  const PDFScreen({super.key, this.bookDetails = '',this.isDownloaded=false});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String pdfPath = "";
  bool isLoading = true;
  int? currIndex = 0;
  int? totalPages = 0;

  @override
  void initState() {
    super.initState();
    if(!widget.isDownloaded) {
      downloadPDF(widget.bookDetails.pdf).then((file) {
        setState(() {
          pdfPath = file.path;
          isLoading = false;
        });
      });
    }else{
      setState(() {
        pdfPath = widget.bookDetails.pdf;
        isLoading=false;
      });
    }
  }

  void setData(var comicData) {
    var provider = Provider.of<DownloadProvider>(context, listen: false);
    var comic = Comic.copyComic(
        comicData['bookDetails'], comicData['pdfPath'], comicData['imgUrl']);
    List comics = LocalStorage.retrieveList(DOWNLOADED_COMICS) ?? [];
    comics.add(comic);
    provider.addComic(comic);
    LocalStorage.storeList(DOWNLOADED_COMICS, comics);
  }

  Future downloadPDF(String url) async {
    try {
      Dio dio = Dio();
      var dir = await getApplicationDocumentsDirectory();
      String suffix = url.split('/').last;
      String fileName = suffix.split('?').first;
      File file = File("${dir.path}/$fileName");
      if (!await file.exists()) {
        var imgUrl = '${dir.path}/${fileName}_Img';
        await dio.download(widget.bookDetails.banner, imgUrl);
        await dio.download(url, file.path);
        setData({
          "imgUrl": imgUrl,
          "pdfPath": file.path,
          "bookDetails": widget.bookDetails
        });
      }
      return file;
    } catch (e) {
      throw Exception("Error downloading PDF file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(title: widget.bookDetails.title),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                PDFView(
                  swipeHorizontal: true,
                  filePath: pdfPath,
                  onPageChanged: (index, last) {
                    setState(() {
                      currIndex = index;
                      totalPages = last;
                    });
                  },
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      color: Colors.black,
                      child: Text(
                        '${currIndex! + 1}/$totalPages',
                        style: heading(),
                      ),
                    ))
              ],
            ),
    );
  }
}
