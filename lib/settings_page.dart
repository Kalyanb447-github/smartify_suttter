import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'button_dashboard.dart';
import 'databasehelper/data_operation.dart';

class SettingsPage extends StatefulWidget {
  List<String> switchCommendList;
  SettingsPage({this.switchCommendList});
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String buttonValue1;
  String buttonValue2;
  String buttonValue3;
  String buttonValue4;
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
                            widget.switchCommendList[2] = value;
                          });
                        },
                        onSaved: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              widget.switchCommendList[2] = value;
                            });
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        initialValue: widget.switchCommendList[2],
                        decoration: InputDecoration(
                          labelText: 'Open',
                          hintText: 'Open',
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
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            widget.switchCommendList[3] = value;
                          });
                        },
                        onSaved: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              widget.switchCommendList[3] = value;
                            });
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        initialValue: widget.switchCommendList[3],
                        decoration: InputDecoration(
                          labelText: 'Close',
                          hintText: 'Close',
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
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            widget.switchCommendList[4] = value;
                          });
                        },
                        onSaved: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              widget.switchCommendList[4] = value;
                            });
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        initialValue: widget.switchCommendList[4],
                        decoration: InputDecoration(
                          labelText: 'Stop',
                          hintText: 'Stop',
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
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            widget.switchCommendList[5] = value;
                          });
                        },
                        onSaved: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              widget.switchCommendList[5] = value;
                            });
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        initialValue: widget.switchCommendList[5],
                        decoration: InputDecoration(
                          labelText: 'Lock',
                          hintText: 'Lock',
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
                SizedBox(height: 24.0),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        // borderRadius: BorderRadius.circular(24),
                        ),
                    onPressed: () {
                      // setAllData();

                      AppUtil().storeAllButtonData(
                          data: widget.switchCommendList[0].toString() +
                              '\n' +
                              widget.switchCommendList[1].toString() +
                              '\n' +
                              widget.switchCommendList[2].toString() +
                              '\n' +
                              widget.switchCommendList[3].toString() +
                              '\n' +
                              widget.switchCommendList[4].toString() +
                              '\n' +
                              widget.switchCommendList[5].toString());
                      String temp_word =
                          widget.switchCommendList[0].toString() +
                              ',' +
                              widget.switchCommendList[1].toString() +
                              ',' +
                              widget.switchCommendList[2].toString() +
                              ',' +
                              widget.switchCommendList[3].toString() +
                              ',' +
                              widget.switchCommendList[4].toString() +
                              ',' +
                              widget.switchCommendList[5].toString();

                              Clipboard.setData( ClipboardData(text: temp_word));
                     
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          // builder: (context) => ButtonDashboard(mainFileLocation:mainFileLocation),
                          builder: (context) => ButtonDashboard(),
                        ),
                      );
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
