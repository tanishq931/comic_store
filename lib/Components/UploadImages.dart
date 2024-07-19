import 'dart:io';

import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadImages extends StatefulWidget {
  const UploadImages({super.key});

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  List<File> _pickedFiles = [];
  List<String> _fileNames = [];

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      List<String> fileNames =
          result.paths.map((path) => path!.split('/').last).toList();

      setState(() {
        _pickedFiles = files;
        _fileNames = fileNames;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Upload Images ',
          style: heading(size: 14),
        ),
        const SizedBox(height: 10),
        if (_fileNames.isEmpty)
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1, color: Colors.white, style: BorderStyle.solid)),
              child: CustomButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.upload,
                      color: Colors.white,
                    ),
                    Text('Upload Images', style: heading(size: 14)),
                  ],
                ),
                onTap: () {
                  _openFileExplorer();
                },
              ))
        else
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_pickedFiles[index]),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: CustomButton(
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onTap: () {
                                showAlert(context, index);
                              }))
                    ],
                  ),
                );
              },
              itemCount: _pickedFiles.length,
              scrollDirection: Axis.horizontal,
            ),
          ),
      ],
    );
  }

  Future showAlert(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                'Are you sure you want to delete ?',
                style: heading(color: Colors.black),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No, cancel',
                      style: heading(size: 12, color: Colors.blue.shade800),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _pickedFiles.removeAt(index);
                        _fileNames.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Yes, delete',
                      style: heading(size: 12, color: Colors.red),
                    )),
              ],
              actionsAlignment: MainAxisAlignment.end,
              actionsPadding: const EdgeInsets.only(right: 10));
        });
  }
}
