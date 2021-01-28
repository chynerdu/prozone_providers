import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:prozone/data-models/provider-model.dart';
import 'package:prozone/utils/url.dart';

class ImageUpload extends StatefulWidget {
  final ProviderModel providerInfo;
  ImageUpload(this.providerInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ImageuploadState();
  }
}

class ImageuploadState extends State<ImageUpload> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File _image;
  final picker = ImagePicker();
  bool isLoading = false;

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      var uri = Uri.parse("${Url.baseUrl}/upload");

      print("Uri is:" + uri.toString());
      var request = http.MultipartRequest("POST", uri);
      request.headers["authorization"] = Url.authHeaders;
      request.fields['ref'] = 'provider';
      request.fields['refId'] = '${widget.providerInfo.id}';
      request.fields['field'] = '${widget.providerInfo.id}';
      request.files
          .add(await http.MultipartFile.fromPath('files', _image.path));

      http.StreamedResponse response = await request.send();
      print('response ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        final snackBar = SnackBar(
            backgroundColor: Colors.green[700],
            content: Text('Image uploaded'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        Timer(Duration(seconds: 2), () {
          Navigator.pop(context, true);
        });
      } else {
        displaySnackBar('Upload failed');
      }
    } catch (error) {
      displaySnackBar('Error occured');
      setState(() {
        isLoading = false;
      });
    }
  }

  displaySnackBar(message) {
    final snackBar =
        SnackBar(backgroundColor: Colors.red, content: Text('Error: $message'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Add image to ${widget.providerInfo.name}',
                    style: TextStyle(color: Colors.black87))),
            body: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  SizedBox(height: 20),
                  _image == null
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/avatar_icon.png"),
                                fit: BoxFit.contain),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 200,
                          child: Image.file(_image)),
                  SizedBox(height: 20),
                  _image == null
                      ? MaterialButton(
                          onPressed: () {
                            _getImage();
                          },
                          child: Text('Select Image',
                              style: TextStyle(color: Colors.white)),
                          minWidth: 100,
                          color: Colors.blue[700],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                submit();
                              },
                              child: Text('Submit',
                                  style: TextStyle(color: Colors.white)),
                              minWidth: 100,
                              color: Colors.green[700],
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  child: Text('Cancel',
                                      style: TextStyle(color: Colors.white)),
                                  minWidth: 100,
                                  color: Colors.red[700],
                                ))
                          ],
                        )
                ]))),
        inAsyncCall: isLoading,
        opacity: 0.6,
        color: Colors.black87,
        progressIndicator: SpinKitWanderingCubes(
          color: Colors.white,
          size: 50.0,
        ));
  }
}
