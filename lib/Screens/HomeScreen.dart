import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/Components/CommonAppbar.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Screens/AddScreen.dart';
import 'package:comic_store/Screens/FavouritesScreen.dart';
import 'package:comic_store/Screens/ListingScreen.dart';
import 'package:comic_store/Screens/SearchScreen.dart';
import 'package:comic_store/provider/AuthProvider.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:comic_store/service/LocalStorage.dart';
import 'package:comic_store/service/getCharacters.dart';
import 'package:comic_store/service/getComics.dart';
import 'package:comic_store/service/getTopRatedComics.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List screens = [
    const ListingScreen(),
    const SearchScreen(),
    const FavouritesScreen(),
  ];
  List screenTitle = [
    'Comic Store',
    'Search Comics',
    'Favourites',
    'Add Comic'
  ];
  int tabIndex = 0;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    checkUser();

  }

  void checkUser() async{
    if (auth.currentUser != null) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.setEmail(auth.currentUser!.email!);
      final val = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      provider.setIsAdmin(val['role']=='admin');
    }

  }

  bool isAdmin = false;

  void fetchData() async {
    setState(() {
      loading = true;
    });
    List comics = await getComics();
    List characters = await getCharacters();
    List topComics = await getTopRatedComics();
    List? list = LocalStorage.retrieveList('favourites');

    var provider = Provider.of<Comicprovider>(context, listen: false);
    provider.setComics(comics);
    provider.setCharacters(characters);
    provider.setTopComics(topComics);
    provider.setFavourites(list ?? []);

    setState(() {
      loading = false;
    });
  }

  List<GButton> getTabs(isAdmin) {
    List<GButton> list = [
      const GButton(
        icon: Icons.home,
        iconColor: Colors.white,
        text: 'Home',
      ),
      const GButton(
        icon: Icons.search,
        iconColor: Colors.white,
        text: 'Search',
      ),
      GButton(
        icon: tabIndex == 2 ? Icons.favorite_outlined : Icons.favorite_outline,
        iconColor: Colors.white,
        text: 'Favourite',
      )
    ];

    if (isAdmin) {
      list.add(const GButton(
        icon: Icons.add,
        iconColor: Colors.white,
        text: 'Add',
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    final isAdmin = provider.isAdmin;
    if (isAdmin) {
      screens.add(const AddScreen());
    }

    void logout() {
      FirebaseAuth.instance.signOut();
      provider.setEmail('');
      provider.setIsAdmin(false);
      Navigator.pushReplacementNamed(context, '/loginScreen');
    }

    Future showLogoutAlert(){
      return showDialog(context: context, builder: (context){
        return AlertDialog(
            title: Text('Are you sure! You want to logout ?',style: heading(color: Colors.black),),
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
                    Navigator.pop(context);
                    logout();
                  },
                  child: Text(
                    'Logout',
                    style: heading(size: 12, color: Colors.red),
                  )),
            ],
            actionsAlignment: MainAxisAlignment.end,
            actionsPadding: const EdgeInsets.only(right: 10));
      });
    }

    return Scaffold(
      appBar: CommonAppbar(
        title: screenTitle[tabIndex],
      ),
      backgroundColor: Colors.black,
      drawer: tabIndex == 0
          ? Drawer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              provider.email,
                              style: heading(),
                            ),
                            const SizedBox(height: 10),
                          ],
                        )),
                    const Divider(
                      height: 2,
                      color: Colors.white,
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              CustomButton(
                                onTap: () {
                                  showLogoutAlert();
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Logout',
                                      style: heading(),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )
          : null,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : screens[tabIndex],
      bottomNavigationBar: GNav(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        tabs: getTabs(isAdmin),
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
