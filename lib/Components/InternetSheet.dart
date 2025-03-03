import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/provider/ConnectivityProvider.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InternetSheet extends StatefulWidget {
  final Widget child;
  const InternetSheet({super.key, required this.child});

  @override
  State<InternetSheet> createState() => _InternetSheetState();
}

class _InternetSheetState extends State<InternetSheet> {
  bool _isBottomSheetShown = false;
  late ConnectivityProvider connectivityProvider;
  late VoidCallback listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listener = () {
      final isConnected = connectivityProvider.isInternetConnected;
      if (!isConnected && !_isBottomSheetShown) {
        _showInternetSheet();
        _isBottomSheetShown = true;
      } else if (isConnected && _isBottomSheetShown) {
        _hideInternetSheet();
        _isBottomSheetShown = false;
      }
    };
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    connectivityProvider = Provider.of<ConnectivityProvider>(context);
    connectivityProvider.addListener(listener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    connectivityProvider.removeListener(listener);
  }

  void _showInternetSheet() {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        elevation: 10,
        builder: (context) {
          return Container(
            height: 230,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Internet Disconnected',
                        style: heading(size: 20, weight: FontWeight.bold)),
                    const SizedBox(
                      height: 20,
                    ),
                    const Icon(
                      Icons.wifi_off_sharp,
                      color: Colors.white,
                      size: 40,
                    )
                  ],
                ),
                CustomButton(
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue),
                      child: Center(child: Text('Retry',style: heading(weight: FontWeight.bold,size: 14),)),
                    ),
                    onTap: () {})
              ],
            ),
          );
        }).whenComplete(() {
      setState(() {
        _isBottomSheetShown = false;
      });
    });
  }

  void _hideInternetSheet() {
    setState(() {
      _isBottomSheetShown = false;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
