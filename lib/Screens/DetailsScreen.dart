import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/PopularCharacters.dart';
import 'package:comic_store/Screens/PDFScreen.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  final String tag;
  final dynamic bookDetails;
  const DetailsScreen({super.key, this.bookDetails = '', required this.tag});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: widget.bookDetails['title'],
      ),
      body: Column(
        children: [
           Expanded(
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   SizedBox(
                     height: 200,
                     child: Center(
                       child: Hero(
                         tag: widget.tag,
                         child: CachedNetworkImage(
                           imageUrl: widget.bookDetails['banner'],
                         ),
                       ),
                     ),
                   ),
                   Column(
                     children: [
                       Container(
                         margin: const EdgeInsets.all(10),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               widget.bookDetails['title'],
                               style: heading(
                                   size: 18, weight: FontWeight.bold),
                             ),
                             SizedBox(
                               height: 30,
                               child: Row(
                                 crossAxisAlignment:
                                     CrossAxisAlignment.center,
                                 children: [
                                   Container(
                                       margin: const EdgeInsets.only(
                                           top: 1.5),
                                       child: Text('5',
                                           style: heading(size: 12))),
                                   const SizedBox(width: 5),
                                   RatingBar.builder(
                                       minRating: 5,
                                       itemCount: 5,
                                       initialRating: 5,
                                       itemSize: 15,
                                       allowHalfRating: true,
                                       direction: Axis.horizontal,
                                       itemBuilder: (context, _) {
                                         return const Icon(
                                           Icons.star,
                                           color: Colors.amber,
                                         );
                                       },
                                       onRatingUpdate: (_) {}),
                                   const SizedBox(width: 5),
                                   Text(widget.bookDetails['language'],
                                       style: heading(
                                           size: 12,
                                           color: Colors.grey)),
                                   const SizedBox(width: 5),
                                   Text(
                                     ' • ${widget.bookDetails['pages']} pages',
                                     style: heading(
                                         size: 12, color: Colors.grey),
                                   )
                                 ],
                               ),
                             ),
                             descRow('Author : ',
                                 widget.bookDetails['author']),
                             descRow('Publisher : ',
                                 widget.bookDetails['publisher']),
                             Text(
                               'Description :',
                               style: heading(size: 14),
                             ),
                             const SizedBox(height: 10),
                             Text(
                               widget.bookDetails['descHi'],
                               style:
                                   heading(size: 12, color: Colors.grey),
                             ),
                             Consumer<Comicprovider>(
                                 builder: (context, val, child) {
                               var list = List.from(val.characters);
                               list.removeWhere((element) {
                                 return !widget.bookDetails['characters']
                                     .contains(element['id']);
                               });
                               return PopularCharacters(
                                 title: 'Characters',
                                 characters: list,
                                 showButton: false,
                               );
                             }),
                           ],
                         ),
                       ),
                       // WebView
                     ],
                   ),
                 ],

             ),
                         ),
           ),
        ],
      ),
      bottomNavigationBar:  CustomButton(
          child: Container(
            height: 50,
            width: double.maxFinite,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Text(
                  'Open',
                  style: heading(),
                )),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PDFScreen(
                      url: widget.bookDetails['pdf'],
                      title: widget.bookDetails['title'],
                    )));
          }),
    );
  }

  Widget descRow(String title, String desc) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(title, style: heading(size: 12)),
          Text(
            desc,
            style: heading(size: 12, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
