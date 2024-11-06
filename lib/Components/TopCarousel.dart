import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Screens/AllComics.dart';
import 'package:comic_store/Screens/DetailsScreen.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:dynamic_carousel_indicator/dynamic_carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopCarousel extends StatefulWidget {
  final List items;
  final double ratio;
  final double fraction;
  final bool autoPlay;
  final bool dots;
  final String imgKey;
  final String title;
  final bool top;
  final String tag;
  const TopCarousel(
      {super.key,
      required this.items,
      this.ratio = 16 / 9,
      this.fraction = 1,
      this.autoPlay = true,
      this.dots = false,
      this.imgKey = 'imgUrl',
      this.title = '',
      this.top = false,
        this.tag=''
      });
  @override
  State<TopCarousel> createState() => TopCarouselState();
}

class TopCarouselState extends State<TopCarousel> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    print(widget.tag);
    List list = widget.items;
    return Stack(
      children: [
        CarouselSlider(
            items: List.generate(list.length, (index) {
              return Consumer<Comicprovider>(
                builder: (context, value, child) {
                  return CustomButton(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Hero(
                          tag: '${widget.tag}${list[index]['id']}${widget.title}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: list[index][widget.imgKey],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (!widget.top) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                        bookDetails: list[index],
                                        tag:
                                            '${widget.tag}${list[index]['id']}${widget.title}',
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Allcomics(
                                      list: value.comics, title: 'Top Rated')));
                        }
                      });
                },
              );
            }),
            options: CarouselOptions(
                initialPage: 0,
                viewportFraction: widget.fraction,
                aspectRatio: widget.ratio,
                enableInfiniteScroll: false,
                autoPlay: widget.autoPlay,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                padEnds: false,
                onPageChanged: (i, _) {
                  setState(() {
                    index = i;
                  });
                })),
        widget.dots
            ? Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Center(
                    child: DynamicCarouselIndicator(
                        dotHeight: 10,
                        dotWidth: 10,
                        activeDotColor: const Color(0xffedf2f4),
                        pageIndex: index,
                        count: list.length)))
            : Container(),
      ],
    );
  }
}
