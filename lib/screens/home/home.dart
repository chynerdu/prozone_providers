import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider/provider.dart';
import 'package:prozone/screens/form/add-provider.dart';
import 'package:prozone/services/main-service.dart';
import 'package:prozone/utils/theme-data.dart';
import '../../utils/class_builder.dart';

class ProviderHome extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ProviderHome();
  }
}

class _ProviderHome extends State<ProviderHome> with CustomThemeData {
  KFDrawerController _drawerController;
  KFDrawerController controller;

  bool _menuOpened = false;
  @override
  initState() {
    final provider = Provider.of<MainAppProvider>(context, listen: false);
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('ProviderListings'),
      items: [
        KFDrawerItem.initWithPage(
            text: Text('Add New Provider',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            icon: Icon(Icons.person_add, color: Colors.white),
            // page: ClassBuilder.fromString('AuthPageState'),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => AddProvider(provider)));
              // Navigator.pushReplacementNamed(context, '/select-options');
            }),
      ],
    );
  }

  @override
  Widget buildProfileInfo() {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            width: 250,
            padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/account');
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  'assets/avatar_icon.png',
                                ),
                              ))),
                      // CircleAvatar(
                      //   backgroundImage: AssetImage('assets/avatar_icon.png',),
                      // ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Text('Wale Wisdom', style: KontactTheme.title2),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text('Prozone Admin ',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white)),
                              ),

                              SizedBox(height: 2),

                              // ${provider.profile.walletCode}
                            ],
                          ))
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: Colors.white38,
                ),
              ],
            )));
  }

  customBoxDecoration() {
    return BoxDecoration(
      border: Border(
          left: BorderSide(color: Colors.black54, width: 2.0),
          bottom: BorderSide(color: Colors.black54, width: 2.0),
          top: BorderSide(color: Colors.black54, width: 2.0),
          right: BorderSide(color: Colors.black54, width: 2.0)),
      borderRadius: const BorderRadius.all(
        Radius.circular(50.0),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: KFDrawer(
//        borderRadius: 0.0,
//        shadowBorderRadius: 0.0,
        menuPadding: EdgeInsets.only(top: 40, bottom: 0),
//        scrollable: true,
        controller: _drawerController,
        header: buildProfileInfo(),

        footer: KFDrawerItem(
          text: Text(
            'Prozone',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1,
                fontWeight: FontWeight.w700),
          ),
          // icon: Icon(
          //   Icons.exit_to_app,
          //   color: Colors.white,
          // ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: drawerColors,
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
