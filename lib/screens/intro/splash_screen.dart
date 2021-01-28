/*

This UI is created for the screen size of iPhone X
(375 x 812 px).

Note that it is not made responsive. If you are seeing it
on any other screen, please change the values respectively.

Don't forget to add dependency for flutter_svg:

dependencies:
  flutter_svg: ^0.17.0

All the required assets are available in the assets
folder.

Created by Flutter Master.
https://www.instagram.com/flutter.master/

 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:prozone/screens/error/init-error.dart';
import 'package:prozone/screens/home/home.dart';
import 'package:prozone/services/main-service.dart';
// import 'package:testing/personal_finance/constants.dart';
// import 'package:testing/personal_finance/finance_screen/finance_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SplashScreenDesign(),
      ),
    );
  }
}

/// Design of Splash Screen
class SplashScreenDesign extends StatefulWidget {
  @override
  _SplashScreenDesignState createState() => _SplashScreenDesignState();
}

class _SplashScreenDesignState extends State<SplashScreenDesign>
    with SingleTickerProviderStateMixin {
  // controller for rotation animations
  AnimationController _controller;
  // reverse rotation animation
  Animation<double> _reverseRotation;

  Color kWhiteColor = const Color(0xFFFFFFFF);
  Color kBlackColor = const Color(0xFF000000);

  Color kPurpleColor = const Color(0xFF602FDA);
  Color kOrangeColor = const Color(0xFFd96f0d);
  Color kBlueColor = const Color(0xFF2ECEE0);

  Color kPrimaryTextColor = const Color(0xFF0D1333);

  @override
  void initState() {
    super.initState();
    // initialising the controller
    _controller = AnimationController(
      vsync: this,
      // long duration for slow motion
      duration: const Duration(seconds: 20),
    );

    // initialising reverse animation
    _reverseRotation = Tween<double>(
      begin: 0.0,
      end: -1.0,
    ).animate(_controller);

    // play animation
    _playAnimation();
    initApp();
  }

  initApp() async {
    final provider = Provider.of<MainAppProvider>(context, listen: false);
    await provider.getStates();
    Map<String, dynamic> result = await provider.getProviderTypes();
    if (result['success']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProviderHome(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InitError(),
        ),
      );
    }
  }

  // will play animation after some delay
  void _playAnimation() async {
    // delay
    // await Future.delayed(const Duration(milliseconds: 500));
    // playing animation
    _controller.forward();
    // more delay

    // await Future.delayed(const Duration(seconds: 3));
    // // navigating to next screen
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => ProviderHome(),
    //   ),
    // );
  }

  @override
  void dispose() {
    // disposing controller when
    // not in use
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // background
        Container(
          width: double.infinity,
          height: double.infinity,
        ),
        // custom paint
        CustomPaint(
          painter: SplashScreenCustomPainter(),
          child: Container(),
        ),
        // blue plus
        Positioned(
          left: 40.0,
          top: 90.0,
          child: RotationTransition(
            turns: _reverseRotation,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/splash/blue_plus.svg',
            ),
          ),
        ),
        // left dots
        Positioned(
          left: -5.0,
          top: 200.0,
          child: SvgPicture.asset(
            'assets/splash/dots.svg',
          ),
        ),
        // purple plus
        Positioned(
          right: 145.0,
          top: 180.0,
          child: RotationTransition(
            turns: Tween<double>(
              begin: 0.0,
              end: 0.5,
            ).animate(_controller),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/splash/purple_plus.svg',
            ),
          ),
        ),
        // purple triangle
        // Positioned(
        //   left: 105.0,
        //   top: 325.0,
        //   child: RotationTransition(
        //     turns: Tween<double>(
        //       begin: 0.0,
        //       end: -0.5,
        //     ).animate(_controller),
        //     alignment: Alignment.center,
        //     child: SvgPicture.asset(
        //       'assets/splash/purple_triangle.svg',
        //     ),
        //   ),
        // ),
        // blue triangle
        // Positioned(
        //   right: 80.0,
        //   top: 400.0,
        //   child: RotationTransition(
        //     turns: Tween<double>(
        //       begin: 0.0,
        //       end: 0.5,
        //     ).animate(_controller),
        //     alignment: Alignment.center,
        //     child: SvgPicture.asset(
        //       'assets/splash/blue_triangle.svg',
        //     ),
        //   ),
        // ),
        // Personal
        Positioned(
          left: 40.0,
          bottom: 140.0,
          child: Text(
            'ProZone',
            style: TextStyle(
              color: const Color(0xFFccccff),
              fontSize: 50.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        // Finance
        Positioned(
          left: 40.0,
          bottom: 82.0,
          child: Text(
            'Getting your app ready... 😏',
            style: TextStyle(
              color: kWhiteColor,
              fontSize: 17.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Painter class for painting the background
class SplashScreenCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double _width = size.width;
    final double _height = size.height;
    Color kPazaBlue = const Color(0xff0000cc);
    Color kPurpleColor = const Color(0xFF602FDA);
    Color kOrangeColor = const Color(0xFFe3740d);
    Color kBlueColor = const Color(0xFF2ECEE0);

    Paint _paint = Paint()..color = kPazaBlue;
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, _width, _height), _paint);

    _paint.color = kOrangeColor;
    canvas.drawCircle(
      Offset(0, _height / 1.9),
      80.0,
      _paint,
    );

    // _paint.style = PaintingStyle.stroke;
    // _paint.strokeWidth = 6.0;
    // canvas.drawCircle(
    //   Offset(_width / 2.3, _height / 1.45),
    //   25.0,
    //   _paint,
    // );

    // _paint.strokeWidth = 10.0;
    // canvas.drawCircle(
    //   Offset(_width / 2.1, _height / 50),
    //   85.0,
    //   _paint,
    // );

    // _paint.color = kBlueColor;
    // _paint.strokeWidth = 13.0;
    // canvas.drawCircle(
    //   Offset(_width * 1.05, _height / 3),
    //   125.0,
    //   _paint,
    // );

    _paint.color = const Color(0xFF4d4dff);
    _paint.strokeWidth = 10.0;
    canvas.drawCircle(
      Offset(_width * 1, _height / 1.3),
      62.0,
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
