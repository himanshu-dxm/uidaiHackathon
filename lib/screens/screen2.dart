import 'package:flutter/material.dart';


class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

List<String> contenter = ['UID', 'Verify', 'Add'];
List<IconData> iconer = [
  Icons.perm_identity,
  Icons.domain_verification,
  Icons.add
];

class Register {
  final String title;
  List<String> contents = [];
  final List<IconData> icon;

  Register(this.title, this.contents, this.icon);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Register> registers = [
    new Register('Haneesh', contenter, iconer),
    new Register('Himanshu Behl', contenter, iconer),
    new Register('Amith Shubhan', contenter, iconer)
  ];

//  var myList = [{'contents' :"Haneesh"},"Himanshu Bhel","Amith Shubhan"];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: new ListView.builder(
        itemCount: registers.length,
        itemBuilder: (context, i) {
          return new ExpansionTile(
              tilePadding: EdgeInsets.all(10),
              title: new Text(
                registers[i].title,
                style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
              children: <Widget>[
                new Column(
                  children: _buildExpandableContent(registers[i]),
                ),
              ],
              leading: new Icon(Icons.account_circle));
        },
      ),
    );
  }
}

_buildExpandableContent(Register register) {
  List<Widget> columnContent = [];
  var i = 0;
  for (String content in register.contents) {
    columnContent.add(
      new ListTile(
        title: new Text(
          content,
          style: const TextStyle(fontSize: 18.0),
        ),
        leading: new Icon(iconer[i]),
        trailing: Icon(
          Icons.arrow_forward_ios,
        ),
        onTap: () => print("on tap"),
      ),
    );
  }

  return columnContent;
}
