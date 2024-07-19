import 'dart:io';

import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadComic extends StatefulWidget {
  const UploadComic({super.key});

  @override
  State<UploadComic> createState() => _UploadComicState();
}

class _UploadComicState extends State<UploadComic> {
  File? _pickedFile;
  String _fileName = '';

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'ppt'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
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
          'Upload Comic (pdf)',
          style: heading(size: 14),
        ),
        const SizedBox(height: 10),
        _fileName.isEmpty
            ? Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1,
                        color: Colors.white,
                        style: BorderStyle.solid)),
                child: CustomButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.upload,
                        color: Colors.white,
                      ),
                      Text('Upload Comic', style: heading(size: 14)),
                    ],
                  ),
                  onTap: () {
                    _openFileExplorer();
                  },
                ))
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.blueAccent,
                    )),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _fileName,
                      style: heading(size: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    CustomButton(
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onTap: () {
                          showAlert(context);
                        })
                  ],
                ),
              ),
      ],
    );
  }
  Future showAlert(BuildContext context ){
    return showDialog(context: context, builder:(context){
      return AlertDialog(
        title:  Text('Are you sure you want to delete ?',style: heading(color: Colors.black),),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('No, cancel',style: heading(size: 12,color: Colors.blue.shade800),)),
          TextButton(onPressed: (){
            setState(() {
              _fileName='';
              _pickedFile=null;
            });
            Navigator.pop(context);
          }, child: Text('Yes, delete',style: heading(size: 12,color: Colors.red),)),
        ],
        actionsAlignment:MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.only(right: 10)
      );
    });
  }
}
