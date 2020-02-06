import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'package:synchronized/synchronized.dart';

import 'button_dashboard.dart';

// import 'package:sns_app/home_page.dart';
class UserInput extends StatefulWidget {
  @override
  _UserInputState createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String folderName = 'Smartify';
  String fileName = 'smartify_Shutter.txt';
  String msg = '';
  final color = const Color(0xffb74093);

  String location = '';
  String unique_number = '';
  String buttonStatus;
  File ourMainFile;
  String text;
  String mainFileLocation = '';
  @override
  void initState() {
    super.initState();
    checkValueExist();
    createDirectory(folderName);
  }

  checkValueExist() async {
    final Directory _appDocDir = await getExternalStorageDirectory();
    final Directory _appFile =
        Directory('${_appDocDir.path}/$folderName/$fileName');
    if (await File(_appFile.path).exists()) {
    
     
     File ourTempFile = File(_appFile.path);
      //text = await ourTempFile.readAsString();
       List<String> switchCommendList = ['', '', '', '', '', ''];
      switchCommendList = await ourTempFile.readAsLines();
        unique_number = switchCommendList[1];
      if (unique_number == '' || unique_number == null) {
        return;
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ButtonDashboard(),
          ),
        );
      }
    }
  }

  createDirectory(String foldername) async {
    final Directory _appDocDir = await getExternalStorageDirectory();
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$foldername/');
    if (!await _appDocDirFolder.exists()) {
      await _appDocDirFolder.create(recursive: true);
    }
  }

  createFileFunction({String filename, String fileData}) async {
    final Directory _appDocDir = await getExternalStorageDirectory();
    ourMainFile = File("${_appDocDir.path}/$folderName/$filename");
    mainFileLocation = ourMainFile.path;
    ourMainFile.writeAsString(fileData);
    // text = await ourMainFile.readAsString();
  }

  setAllData() async {
    if (location != null ||
        location != '' && unique_number != null ||
        unique_number != '') {
      createFileFunction(
          filename: fileName,
          fileData: location +
              '\n' +
              unique_number +
              '\n' +
              '101110101110101111001000' +
              '\n' +
              '101110101110101111000001' +
              '\n' +
              '101110101110101111000001' +
              '\n' +
              '101110101110101111000010' +
              '\n');
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        // builder: (context) => ButtonDashboard(mainFileLocation:mainFileLocation),
        builder: (context) => ButtonDashboard(),
      ),
    );
  }

  //@@@@@@@@@@@@@@@@@@@@@@ using for txt and folsers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                //  logo,
                SizedBox(height: 48.0),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Center(
                    child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            location = value;
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            location = value;
                          });
                        },
                        controller: user,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Enter Location',
                          hintText: 'my home',
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.blue[400],
                          ),
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        )),
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.number,

                  autofocus: false,
                  // initialValue: 'sad',
                  //obscureText: true,
                  //  controller: pass,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      unique_number = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      unique_number = value;
                    });
                  },

                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.blue[200],
                    ),
                    labelText: 'Unique Number',
                    hintText: '',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(height: 24.0),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(24),
                        ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setAllData();
                      }
                    },
                    // padding: EdgeInsets.all(12),
                    color: Colors.lightBlue[200],
                    child:
                        Text('Submit', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
