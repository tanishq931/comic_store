import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/Components/CommonInput.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/UploadComic.dart';
import 'package:comic_store/Components/UploadImages.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController writer = TextEditingController();
  TextEditingController publisher = TextEditingController();
  TextEditingController character = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             CommonInput(controller: title,label: 'Enter book title'),
             CommonInput(controller: desc,label: 'Enter description',maxLines: 4,keyboard: TextInputType.multiline ),
             CommonInput(controller: writer,label: 'Enter author name'),
             CommonInput(controller: publisher,label: 'Enter publisher name'),
             CommonInput(controller: character,label: 'Enter Characters (Optional)'),
             const UploadComic(),
             const UploadImages()
            ],
          ),
        ),
      ),
    );
  }
}
