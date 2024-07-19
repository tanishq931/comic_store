import 'package:comic_store/Components/Categories.dart';
import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/Components/PopularCharacters.dart';
import 'package:comic_store/Components/TopCarousel.dart';
import 'package:comic_store/Screens/AddScreen.dart';
import 'package:comic_store/Screens/ListingScreen.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/service/getCharacters.dart';
import 'package:comic_store/service/getComics.dart';
import 'package:comic_store/service/getTopRatedComics.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List screens = [ListingScreen(), ListingScreen(), AddScreen()];
  int tabIndex = 0;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      loading = true;
    });
    List comics = await getComics();
    List characters = await getCharacters();
    List topComics = await getTopRatedComics();

    var provider = Provider.of<Comicprovider>(context,listen: false);
    provider.setComics(comics);
    provider.setCharacters(characters);
    provider.setTopComics(topComics);

    setState(() {
      loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CommonAppbar(title: tabIndex ==0?'Comic Store':'Add Comic'),
      body: loading?const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ):screens[tabIndex],
      bottomNavigationBar: GNav(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        tabs: const [
          GButton(
            icon: Icons.home,
            iconColor: Colors.white,
            text: 'Home',
          ),
          GButton(
            icon: Icons.search,
            iconColor: Colors.white,
            text: 'Search',
          ),
          GButton(
            icon: Icons.add,
            iconColor: Colors.white,
            text: 'Add',
          )
        ],
        activeColor: Colors.blue,
        onTabChange: (value) {
          setState(() {
            tabIndex = value;
          });
        },
        textStyle: heading(),
        haptic: true,
      ),
    );
  }
}
