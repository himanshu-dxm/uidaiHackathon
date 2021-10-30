import 'package:flutter/material.dart';

import 'home.dart';


class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  Widget build(BuildContext context) {
    return AmithHomePage(title: 'Aadhaar Address Update ');
  }
}

List<String> contenter = ['Address', 'Verify'];
List<IconData> iconer = [
  Icons.perm_identity,
  Icons.domain_verification,
  // Icons.add
];

class Register {
  final String title;
  List<String> contents = [];
  final List<IconData> icon;

  Register(this.title, this.contents, this.icon);
}

class AmithHomePage extends StatefulWidget {
  const AmithHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AmithHomePage> createState() => _AmithHomePageState();
}

class _AmithHomePageState extends State<AmithHomePage> {
  int _counter = 0;
  List<Register> registers = [
    new Register('Haneesh\'s UID', contenter, iconer),
    new Register('Himanshu Behl\'s UID', contenter, iconer),
    new Register('Amith Shubhan\'s UID', contenter, iconer)
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Client's List")),
      ),
      body: Container(
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.all(1),
        child: Column(
          children: [
            SizedBox(height: 8,),
            Container(
              width: double.infinity,
              // decoration: BoxDecoration(border: Border.all(width: 1)),
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              child: GestureDetector(child: Text('Enter manually',
                style: new TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
                ),
                onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
              },),
            ),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: SizedBox(
                width: double.infinity,
              ),
            ),
            Expanded(
              child: new ListView.builder(
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
                          children: _buildExpandableContent(registers[i],context),
                        ),
                      ],
                      leading: new Icon(Icons.account_circle));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_buildExpandableContent(Register register,BuildContext context) {
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
        onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()))
        },
      ),
    );
    i++;
  }

  return columnContent;
}
