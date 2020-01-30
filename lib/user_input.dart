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
  String folderName='Smartify';
  String fileName='smartify_Shutter.txt';
  String msg = '';
  final color = const Color(0xffb74093);

  String location = null;
  String unique_number = null;
  String buttonStatus;
  File ourMainFile;
    String text;
    String mainFileLocation='';
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
 Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ButtonDashboard(),
      ),
    );
 }
  //  List<String> valueOfLile = await ourTempFile.readAsLines();
    // text = await ourTempFile.readAsString();
    // if (await ourTempFile.exists()) {
    //   setState(() {
    //     location = valueOfLile[0];
    //     location = valueOfLile[1];
    //     buttonStatus = valueOfLile[2];
    //   });
    // }
   
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
    mainFileLocation=ourMainFile.path;
    ourMainFile.writeAsString(fileData);
    // text = await ourMainFile.readAsString();
  }

  setAllData() async {
    if (location != null && unique_number != null) {
      createFileFunction(
          filename: fileName,
          fileData: location +
              '\n' +
              unique_number +
              '\n' +
              '12345678901234567890' +
              '\n' +
              '12345678901234567890' +
              '\n' +
              '12345678901234567890' +
              '\n' +
              '12345678901234567890' +
              '\n');
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        // builder: (context) => ButtonDashboard(mainFileLocation:mainFileLocation),
                builder: (context) => ButtonDashboard(),

      ),
    );
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => UserInput(),
    //   ),
    // );
  }

  //@@@@@@@@@@@@@@@@@@@@@@ using for txt and folsers



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
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
                      setAllData();
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

//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

// class CreateDirectory extends StatefulWidget {
//   @override
//   _CreateDirectoryState createState() => _CreateDirectoryState();
// }

// class _CreateDirectoryState extends State<CreateDirectory> {
//   String rootDirectory;
//   static Future<String> createFolderInAppDocDir(String folderName) async {
//     //Get this App Document Directory
//     final Directory _appDocDir = await getExternalStorageDirectory();
//     //App Document Directory + folder name
//     final Directory _appDocDirFolder =
//         Directory('${_appDocDir.path}/$folderName/');
//     // rootDirectory= _appDocDirFolder.path;
//     if (await _appDocDirFolder.exists()) {
//       //if folder already exists return path
//       return _appDocDirFolder.path;
//     } else {
//       //if folder not exists create folder and then return its path
//       final Directory _appDocDirNewFolder =
//           await _appDocDirFolder.create(recursive: true);
//       return _appDocDirNewFolder.path;
//     }
//   }

//   createDirecoreyFunction(String foldername) async {
//     String folderInAppDocDir = await createFolderInAppDocDir(foldername);
//   }

//   String testContent = 'press the button below';
//   _buttonPressed() async {
//     //  Directo
//   }
//   String text = '';

//   createFileFunction({String filename, String fileData}) async {
//     //  final directory = await getApplicationDocumentsDirectory();
//     final directory = await getExternalStorageDirectory();

//     // final directory = await getExternalStorageDirectory();
//     final appDocDir = directory.path;
//     File ourFile = File("$appDocDir/Smartify/$filename");

//     if (await ourFile.exists()) {
//       //if folder already exists return path
//       // return _appDocDirFolder.path;
//     } else {
//       //if folder not exists create folder and then return its path
//       // final Directory _appDocDirNewFolder =
//       //     await _appDocDirFolder.create(recursive: true);
//       // return _appDocDirNewFolder.path;
//     }
//     ourFile.writeAsString(fileData);
//     ourFile.openWrite();
//     print(ourFile.path);
//     text = await ourFile.readAsString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       child: Center(
//         child: Column(
//           children: <Widget>[
//             SizedBox(height: 150),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Text(text),
//                 RaisedButton(
//                   onPressed: () {
//                     createFileFunction(filename: "sample.txt", fileData: '');
//                   },
//                   child: Text('click'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 50),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: <Widget>[
//                 Text(text),
//                 RaisedButton(
//                   onPressed: () {
//                     createDirecoreyFunction("Smartify");
//                   },
//                   child: Text('create new folder'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }

// class AppUtil {
//   static Future<String> createFolderInAppDocDir(String folderName) async {
//     //Get this App Document Directory
//     final Directory _appDocDir = await getExternalStorageDirectory();
//     //App Document Directory + folder name
//     final Directory _appDocDirFolder =
//         Directory('${_appDocDir.path}/$folderName/');
//     //rootDirectory= _appDocDirFolder.path;
//     if (await _appDocDirFolder.exists()) {
//       //if folder already exists return path
//       return _appDocDirFolder.path;
//     } else {
//       //if folder not exists create folder and then return its path
//       final Directory _appDocDirNewFolder =
//           await _appDocDirFolder.create(recursive: true);
//       return _appDocDirNewFolder.path;
//     }
//   }
// }

class Lager {
  static final _lock = Lock(); // uses the “synchronized” package
  static File _logFile;

  static Future initializeLogging(String canonicalLogFileName) async {
    _logFile = _createLogFile(canonicalLogFileName);
    final text = '${new DateTime.now()}: LOGGING STARTED\n';

    /// per its documentation, `writeAsString` “Opens the file, writes
    /// the string in the given encoding, and closes the file”
    return _logFile.writeAsString(text, mode: FileMode.write, flush: true);
  }

  static Future log(String s) async {
    final text = '${new DateTime.now()}: $s\n';
    return _lock.synchronized(() async {
      await _logFile.writeAsString(text, mode: FileMode.append, flush: true);
    });
  }

  static File _createLogFile(canonicalLogFileName) =>
      File(canonicalLogFileName);
}
