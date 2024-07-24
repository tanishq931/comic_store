import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/Components/CommonInput.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/Toast.dart';
import 'package:comic_store/Components/UploadComic.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController descEn = TextEditingController();
  TextEditingController descHi = TextEditingController();
  TextEditingController author = TextEditingController();
  TextEditingController publisher = TextEditingController();
  TextEditingController ratings = TextEditingController();
  TextEditingController pages = TextEditingController();
  Object? characterId;
  File? comicPdf, banner;
  bool isBtnDisabled = true;
  bool reset = false;
  bool isLoading = false;
  var firestore = FirebaseFirestore.instance.collection('comics');

  Future _uploadFile(dynamic pickedFile, String fileName) async {
    if (pickedFile == null) return;

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      await storageRef.putFile(pickedFile!);
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error occurred while uploading file: $e');
    }
  }

  void uploadData() async {
    setState(() {
      isLoading = true;
    });
    String docId = firestore.doc().id;
    String bannerImg = await _uploadFile(banner, '${title.text}-img');
    String pdfUrl = await _uploadFile(comicPdf, '${title.text}-pdf');
    try {
      var payload = {
        'author': author.text,
        'banner': bannerImg,
        'characters': [characterId.toString()],
        'descEn': descEn.text,
        'descHi': descHi.text,
        'id': docId,
        'language': 'Hindi',
        'pages': int.parse(pages.text),
        'pdf': pdfUrl,
        'publisher': publisher.text,
        'ratings':
            double.parse(ratings.text) > 5 ? 5 : double.parse(ratings.text),
        'title': title.text
      };
      await firestore.doc(docId).set(payload).then((val) {
        resetFields();
        setState(() {
          isLoading = false;
        });
        showToastMsg(context, 'Upload Success', Colors.blueAccent);
        final provider = Provider.of<Comicprovider>(context,listen: false);
        List list = List.from(provider.comics);
        list.add(payload);
        provider.setComics(list);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showToastMsg(context, 'Please Check All the fields', Colors.red);
    }
  }

  void resetFields() async {
    reset = true;
    setState(() {});
    title.text = '';
    descEn.text = '';
    descHi.text = '';
    author.text = '';
    publisher.text = '';
    ratings.text = '';
    pages.text = '';
    characterId = null;
    comicPdf = null;
    banner = null;
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        reset = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    isBtnDisabled = isLoading ||
        title.text.isEmpty ||
        descHi.text.isEmpty ||
        descEn.text.isEmpty ||
        author.text.isEmpty ||
        publisher.text.isEmpty ||
        ratings.text.isEmpty ||
        pages.text.isEmpty ||
        characterId.toString().isEmpty ||
        comicPdf == null ||
        banner == null;
    void onChangeText(String val) {
      setState(() {});
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonInput(
                    controller: title,
                    label: 'Enter book title',
                    onChangeText: onChangeText),
                CommonInput(
                    controller: descEn,
                    label: 'Enter description (English)',
                    maxLines: 4,
                    keyboard: TextInputType.multiline,
                    onChangeText: onChangeText),
                CommonInput(
                    controller: descHi,
                    label: 'Enter description (Hindi)',
                    maxLines: 4,
                    keyboard: TextInputType.multiline,
                    onChangeText: onChangeText),
                CommonInput(
                    controller: author,
                    label: 'Enter author name',
                    onChangeText: onChangeText),
                CommonInput(
                    controller: publisher,
                    label: 'Enter publisher name',
                    onChangeText: onChangeText),
                CommonInput(
                    controller: ratings,
                    keyboard: TextInputType.number,
                    label: 'Rating (5 max)',
                    onChangeText: onChangeText),
                CommonInput(
                    controller: pages,
                    keyboard: TextInputType.number,
                    label: 'Number of Pages',
                    onChangeText: onChangeText),
                Text('Select Character', style: heading()),
                const SizedBox(
                  height: 4,
                ),
                Center(
                  child: Consumer<Comicprovider>(
                    builder: (context, val, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white,
                            )),
                        child: DropdownButton(
                          hint: Text(
                            'Select Character',
                            style: heading(),
                          ),
                          value: characterId,
                          items: val.characters.map((item) {
                            return DropdownMenuItem(
                              value: item['id'],
                              child: Text(
                                item['name'],
                                style: heading(),
                              ),
                            );
                          }).toList(),
                          onChanged: (i) {
                            setState(() {
                              characterId = i;
                            });
                          },
                          isExpanded: true,
                          dropdownColor: Colors.grey.shade800,
                        ),
                      );
                    },
                  ),
                ),
                UploadComic(
                  onTap: (File file) {
                    setState(() {
                      comicPdf = file;
                    });
                  },
                  reset: reset,
                ),
                UploadComic(
                  onTap: (File file) {
                    setState(() {
                      banner = file;
                    });
                  },
                  isImage: true,
                  title: 'Upload Poster',
                  btnText: 'Upload image',
                  reset: reset,
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
        ]),
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 10),
        child: CustomButton(
          disabled: isBtnDisabled,
          onTap: () {
            uploadData();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: isBtnDisabled ? Colors.grey.shade600 : Colors.red,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Text(
              'Upload',
              style: heading(),
            )),
          ),
        ),
      ),
    );
  }
}
