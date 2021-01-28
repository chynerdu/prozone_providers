import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:prozone/data-models/meta-data-model.dart';
import 'package:prozone/screens/components/button.dart';
import 'package:prozone/screens/home/home.dart';
import 'package:prozone/services/main-service.dart';
import 'package:prozone/utils/theme-data.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AddProvider extends StatefulWidget {
  final dynamic provider;
  AddProvider(this.provider);

  State<StatefulWidget> createState() {
    return _AddProvider();
  }
}

class _AddProvider extends State<AddProvider> with CustomThemeData {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  dynamic selectedValue;
  dynamic selectedReason;
  double initialRating = 1.0;
  // List<GenderModel> gender;

  // declare global keys for reusable widgets

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'name': null,
    'description': null,
    'rating': null,
    'address': null,
    'provider_type': null,
    'state': null,
  };
  bool isLoading = false;
  dynamic initialState;
  dynamic initialProviderType;

  var tempItem = {};

  int _keyboardVisibilitySubscriberId;

  @override
  void initState() {
    initialState = widget.provider.allStates[0].label;
    initialProviderType = widget.provider.allProviderTypes[0].label;
    //  KeyboardVisibilityNotification().addNewListener(
    //   onHide: () {
    //     print('keyboard hidden');
    //      FocusScope.of(context).unfocus();
    //   },
    // );
    super.initState();
  }

  next() {
    submit();
  }

  Future submit() async {
    // validate each widgets
    final provider = Provider.of<MainAppProvider>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      print('validation failed');
      return;
    }
    print('validated');
    setState(() {
      isLoading = true;
    });
    await _formKey.currentState.save();

    // submit basic info
    provider
        .addProvider(
      name: _formData['name'],
      description: _formData['description'],
      rating: initialRating,
      address: _formData['address'],
      providerType: initialProviderType,
      state: initialState,
    )
        .then((Map<String, dynamic> success) {
      setState(() {
        isLoading = false;
      });
      if (success['success']) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ProviderHome()));
      } else {
        final snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error: ${success['message']}'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }

  // build Intro
  Widget buildIntro() {
    return Container(
        padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(
                      bottom: 20,
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text('Add A New Provider', style: tile_title)),
                Container(
                  child: IconButton(
                    padding: EdgeInsets.only(top: 0),
                    icon: Icon(
                      Icons.cancel,
                      size: 27,
                      color: Colors.red[700],
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => ProviderHome()));
                    },
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                      'Make sure all information is correct before submitting.'),
                )
              ],
            )
          ],
        ));
  }

  selectGender() {
    print('selected');
  }

  Widget buildStateDropDown(context) {
    final provider = Provider.of<MainAppProvider>(context, listen: false);
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          // FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            child: Form(
                // key: genderKey,
                // height: 45,
                child: Container(
                    // padding: const EdgeInsets.only(left: 16, right: 16),
                    child: new Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: Color(0xffeeeeee)),
                        child: new DropdownButtonFormField<dynamic>(
                          // underline: Container(color:Colors.black38, height:1.0),
                          value: provider.allStates[0],
                          disabledHint: Text('Select a state'),
                          // validator: (value) =>
                          //     value == 'Select Gender' ? 'Select state' : null,
                          onChanged: (dynamic value) {
                            print('selected value ${value.label}');
                            setState(() {
                              initialState = value.label;
                              _formData['state'] = value.label;
                            });
                          },

                          // style: TextStyle(height: -5),
                          items: provider.allStates.map((StateModel value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text('${value.label}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )),
                            );
                          }).toList(),
                          isExpanded: true,
                          elevation: 15,
                          icon: Icon(Icons.keyboard_arrow_down),
                        ))))));
  }

  Widget buildRatings() {
    return Container(
        child: SmoothStarRating(
            allowHalfRating: false,
            onRated: (v) {
              setState(() {
                initialRating = v;
              });
            },
            starCount: 5,
            rating: initialRating,
            size: 40.0,
            isReadOnly: false,
            // fullRatedIconData: Icons.blur_off,
            // halfRatedIconData: Icons.blur_on,
            color: Colors.yellow[700],
            borderColor: Colors.yellow[700],
            spacing: 0.0));
  }

  Widget buildProviderTypeDropDown(context) {
    final provider = Provider.of<MainAppProvider>(context, listen: false);
    return new GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          // FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
            child: Form(
                // key: genderKey,
                // height: 45,
                child: Container(
                    // padding: const EdgeInsets.only(left: 16, right: 16),
                    child: new Theme(
                        data: Theme.of(context)
                            .copyWith(canvasColor: Color(0xffeeeeee)),
                        child: new DropdownButtonFormField<dynamic>(
                          value: provider.allProviderTypes[0],
                          disabledHint: Text('Select a provider types'),
                          onChanged: (dynamic value) {
                            print('selected value ${value.label}');
                            setState(() {
                              initialProviderType = value.label;
                              _formData['provider_type'] = value.label;
                            });
                          },
                          items: provider.allProviderTypes.map((dynamic value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text('${value.label}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  )),
                            );
                          }).toList(),
                          isExpanded: true,
                          elevation: 15,
                          icon: Icon(Icons.keyboard_arrow_down),
                        ))))));
  }

  buildFormBody() {
    return Container(
        padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Form(
            key: _formKey,
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // name
                  TextFormField(
                    style: TextStyle(
                      decoration: TextDecoration.none,
                    ),
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "field can't be empty";
                      }
                    },
                    onSaved: (String value) {
                      _formData['name'] = value;
                    },
                  ),
                  // description

                  TextFormField(
                    style: TextStyle(
                      decoration: TextDecoration.none,
                    ),
                    decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "field can't be empty";
                      }
                    },
                    onSaved: (String value) {
                      _formData['description'] = value;
                    },
                  ),
                  // address
                  TextFormField(
                    style: TextStyle(
                      decoration: TextDecoration.none,
                    ),
                    decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "field can't be empty";
                      }
                    },
                    onSaved: (String value) {
                      _formData['address'] = value;
                    },
                  ),
                  buildStateDropDown(context),
                  SizedBox(height: 10),
                  buildProviderTypeDropDown(context),
                  SizedBox(height: 40),
                  Text('Rate Provider',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 5),
                  buildRatings(),
                  SizedBox(height: 40),
                  FirstButton(next, 'Create'),
                  SizedBox(height: 15),
                ])));
  }

  Widget buildBody() {
    return Column(
      children: <Widget>[buildIntro(), SizedBox(height: 20), buildFormBody()],
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: new GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  // FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: ModalProgressHUD(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 50),
                          Container(
                              child: Column(
                            children: <Widget>[Container(child: buildBody())],
                          )),
                        ],
                      ),
                    ),
                    inAsyncCall: isLoading,
                    opacity: 0.6,
                    color: Colors.black87,
                    progressIndicator: SpinKitWanderingCubes(
                      color: Colors.white,
                      size: 50.0,
                    )))));
  }
}
