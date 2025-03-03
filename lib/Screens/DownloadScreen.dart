import 'dart:io';

import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Screens/PDFScreen.dart';
import 'package:comic_store/constant/constant.dart';
import 'package:comic_store/provider/DownloadProvider.dart';
import 'package:comic_store/service/LocalStorage.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DownloadProvider>(context);
    var comics = provider.downloadedComics;
    void deleteComic(int index) async {
      File pdf = File(comics[index]?.pdf);
      File banner = File(comics[index]?.banner);
      await pdf.delete();
      await banner.delete();
      provider.removeComic(comics[index]?.id);
      LocalStorage.storeList(DOWNLOADED_COMICS, comics);
    }

    Future onPressDelete(int index) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Sure, you want to delete this comic?',
                    style:
                        heading(color: Colors.black, weight: FontWeight.bold),
                  )),
              actions: [
                CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Cancel',
                          style: heading(
                              color: Colors.red, weight: FontWeight.bold),
                        ))),
                CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                      deleteComic(index);
                    },
                    child: Text(
                      'Yes, sure',
                      style:
                          heading(color: Colors.blue, weight: FontWeight.bold),
                    )),
              ],
            );
          });
    }

    return Scaffold(
      appBar: CommonAppbar(title: "Downloaded Comics"),
      body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: double.infinity,
          width: double.infinity,
          child: comics.isEmpty? Center(
            child: Text('No comics downloaded',style: heading(size: 18),),
          ) : ListView.separated(
            itemBuilder: (context, index) {
              var comic = comics[index];
              var imgFile = File(comic.banner);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    CustomButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PDFScreen(bookDetails: comics[index])));
                      },
                      child: Row(
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              imgFile,
                              height: 150,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              constraints: const BoxConstraints(minHeight: 140),
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(right: 50),
                                        child: Text(
                                          comic.title,
                                          style:
                                              heading(weight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        spacing: 4,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${comic.ratings}',
                                            style: heading(size: 14),
                                          ),
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            '${comics[index]?.pages} pages',
                                            style: heading(
                                                size: 12, color: Colors.grey),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '${comic.language}',
                                        style: heading(
                                            size: 14, color: Colors.white60),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          '${comics[index]?.author}',
                                          style: heading(
                                              size: 14, color: Colors.grey),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          '${comic.publisher}',
                                          style: heading(
                                              size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 10,
                        child: CustomButton(
                            onTap: () {
                              onPressDelete(index);
                            },
                            child: const Icon(Icons.delete,
                                color: Colors.red, size: 27)))
                  ],
                ),
              );
            },
            itemCount: comics.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
          )),
    );
  }
}
