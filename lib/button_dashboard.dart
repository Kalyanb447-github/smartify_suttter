import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'dart:math';

import 'settings_page.dart';

class ButtonDashboard extends StatefulWidget {
  // String  mainFileLocation='';
  // ButtonDashboard({this.mainFileLocation});
  @override
  // _ButtonDashboardState createState() => _ButtonDashboardState(mainFileLocation:mainFileLocation);
  _ButtonDashboardState createState() => _ButtonDashboardState();
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'logout', icon: Icons.home),
  CustomPopupMenu(title: 'Bookmarks', icon: Icons.bookmark),
  CustomPopupMenu(title: 'Settings', icon: Icons.settings),
];

class _ButtonDashboardState extends State<ButtonDashboard> {
  //static String  mainFileLocation;
  // _ButtonDashboardState({String mainFileLocation});

  File ourTempFile;

  String messageToPublish;
  String location;
  String folderName = 'Smartify';
  String fileName = 'smartify_Shutter.txt';
  static String unique_number;
  static String tempUniqueNumber = '';
  List<String> listOfButtonStatusFromShared = [];
  CustomPopupMenu _selectedChoices = choices[0];

  List<String> switchCommendList = ['', '', '', '','',''];

  String buttonOneValue;
  String text;

  String buttonValue1;
  String buttonValue2;
  String buttonValue3;
  String buttonValue4;
  var internetStatus;
  @override
  void initState() {
    super.initState();
    internetStatus = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result.index == 2) {
        // _showDialog(result.index.toString(), result.toString());
        _showDialog('Sorry', 'No internet Connection');
      }
    });
    checkValueExist();
    _connect();
  }

  dispose() {
    super.dispose();

    internetStatus.cancel();
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  checkValueExist() async {
    final Directory _appDocDir = await getExternalStorageDirectory();
    final Directory _appFile =
        Directory('${_appDocDir.path}/$folderName/$fileName');
    if (await File(_appFile.path).exists()) {
      ourTempFile = File(_appFile.path);
      text = await ourTempFile.readAsString();
      switchCommendList = await ourTempFile.readAsLines();
    }
  }

  // CustomPopupMenu _selectedChoices = choices[0];

  sendMqttpRequest() {}

  void _select(CustomPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });
    if (_selectedChoices.title == 'logout') {
      _disconnect();
      // _removeSharedValue();
    }
      if (_selectedChoices.title == 'Settings') {
      Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(switchCommendList: switchCommendList),
      ),
    );
      // _removeSharedValue();
    }
  }

  //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  String titleBar = 'MQTT';
  String broker = '68.183.246.170';
  int port = 1883;
  String username = 'zxcvnm!';
  String passwd = 'Servestack@123';
  int _qosValue = 0;
  bool _retainValue = false;
  static Random random = new Random();
  static int randomNumber = random.nextInt(100000); // from 0 upto 9999 included

  static String deviceIdentifier = '${randomNumber}/device';
  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  double _temp = 20;
  String con = '';
  StreamSubscription subscription;

  void _connect() async {
    client = mqtt.MqttClient(broker, '');
    client.port = port;
    client.logging(on: true);

    client.keepAlivePeriod = 3000;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('${deviceIdentifier}')
        .startClean() // Non persistent session for testing
        .keepAliveFor(3000)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    print('[MQTT client] MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect(username, passwd);
    } catch (e) {
      print(e);
      _disconnect();
    }

    /// Check if we are connected
    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] connected');
      setState(() {
        connectionState = client.connectionState;
        con = connectionState.toString();
      });
    } else {
      print('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client.connectionState}');
      _disconnect();
    }

    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    subscription = client.updates.listen(_onMessage);

    _subscribeToTopic('${unique_number}/client');
  }

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    //_removeSharedValue();
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      connectionState = client.connectionState;
      client = null;
      subscription.cancel();
      subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('[MQTT client] Subscribing to ${topic.trim()}');
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    //

    //
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    // final String message =
    //     mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    setState(() {
      // txtReceive = mqtt.MqttPublishPayload.bytesToStringAsString(
      //     recMess.payload.message);
    });

    // if (txtReceive != null || txtReceive != '') {
    //   processTxtReceive(txtReceive);
    // }
  }

  void _sendMessage({int buttonNo, int buttonVale, String all}) {
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();
    // client.publishMessage(event[0].topic,recMess.payload.header.qos, event[0].payload);

    // builder.addString(_messageContent);
    // builder.addString('[5586826]alloff');
    //   messageToPublish = "[5586826]5-0";
    // messageToPublish = "[5586826]${buttonNo}-${buttonVale}";
    messageToPublish = "[${unique_number}]RC-${all}";
    builder.addString(messageToPublish);
    // builder.addString('[5586826]1-1');
    client.publishMessage(
      // _topicContent,
      '${unique_number}/device',
      mqtt.MqttQos.values[_qosValue],
      builder.payload,
      retain: _retainValue,
    );
    // Navigator.pop(context);
  }

  sendButtonValue({int buttonNo, int buttonValue}) async {
    switch (buttonNo) {
      case 1:
        {
          _sendMessage(buttonNo: buttonNo, buttonVale: buttonValue);
        }
        // do something
        break;
      case 2:
        {
          _sendMessage(buttonNo: buttonNo, buttonVale: buttonValue);
        }
        break;
      case 3:
        {
          _sendMessage(buttonNo: buttonNo, buttonVale: buttonValue);
        }
        break;
      case 4:
        {
          _sendMessage(buttonNo: buttonNo, buttonVale: buttonValue);
        }

      // do something else

    }
  }

  @override
  Widget build(BuildContext context) {
    //  final width = MediaQuery.of(context).size.width;
    //  final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        // color: Color(0xFF1C6BB0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0D325E),
              const Color(0xFF1C6BB0),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
          ),
        ),

        child: ListView(
          children: <Widget>[
            // AppbarWidget(),
            AppBar(
              elevation: 0,
              title: Text(
                'Smartify',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Center(
                    child: Text(
                      con != '' ? 'Connect' : 'Disconnect',
                      style: TextStyle(
                        color: con != '' ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                PopupMenuButton<CustomPopupMenu>(
                  elevation: 3.2,
                  // initialValue: choices[1],
                  onCanceled: () {
                    print('You have not chossed anything');
                  },
                  tooltip: 'This is tooltip',
                  onSelected: _select,
                  itemBuilder: (BuildContext context) {
                    return choices.map((CustomPopupMenu choice) {
                      return PopupMenuItem<CustomPopupMenu>(
                        value: choice,
                        child: Text(
                          choice.title,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),

            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          //'$location',
                          switchCommendList[0].toString(),
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        Text(
                         // '$unique_number',
                          switchCommendList[1].toString(),
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (switchCommendList[2] != null ||
                            switchCommendList[2] != '') {
                          _sendMessage(buttonNo: 1, all: switchCommendList[2]);
                        }
                      },
                      child: Cardelement(
                        image: 'assets/available.png',
                        text: 'Open',
                        //  requestValue: listOfButtonStatusFromShared[0],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (switchCommendList[3] != null ||
                            switchCommendList[3] != '') {
                          _sendMessage(buttonNo: 2, all: switchCommendList[3]);
                        }
                      },
                      child: Cardelement(
                        image: 'assets/available.png',
                        text: 'close',
                        //   requestValue: listOfButtonStatusFromShared[1],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        //       sendButtonValue(
                        //    buttonNo: 1,
                        //    buttonValue: int.parse(switchCommendList[2])
                        //  );
                        if (switchCommendList[4] != null ||
                            switchCommendList[4] != '') {
                          _sendMessage(buttonNo: 3, all: switchCommendList[4]);
                        }
                      },
                      child: Cardelement(
                        image: 'assets/available.png',
                        text: 'stop',
                        //  requestValue: listOfButtonStatusFromShared[2],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                             if (switchCommendList[5] != null ||
                            switchCommendList[5] != '') {
                          _sendMessage(buttonNo: 4, all: switchCommendList[5]);
                        }
                      },
                      child: Cardelement(
                        image: 'assets/available.png',
                        text: 'Lock',
                        // requestValue: listOfButtonStatusFromShared[3],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Cardelement extends StatefulWidget {
  String text;
  String image;
  Function function;
  int status;
  String requestValue;
  int buttonNo;
  Cardelement({
    this.text,
    this.image,
    this.function,
    this.status,
    this.requestValue,
    this.buttonNo,
  });

  @override
  _CardelementState createState() => _CardelementState();
}

class _CardelementState extends State<Cardelement> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.function,
      child: Container(
        decoration: BoxDecoration(
          //  color: Color(0XFF0D325E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.blue[400],
            width: 2,
          ),
        ),
        height: 150,
        width: 150,
        child: Card(
          color: Color(0XFF0D325E),
          //color:Colors.red,
          elevation: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    height: 60,
                    width: 60,
                    image: AssetImage(widget.image),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.text,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        // color: Color(0xFF5458A7),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}
