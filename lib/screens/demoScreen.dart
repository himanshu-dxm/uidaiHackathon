import 'package:aadharupdater/screens/home.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(100))),
        backgroundColor: Colors.black,
        title: Text('Customer List'),
      ),
      body: Center(
          child: Container(
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(3),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(1),
              child: Row(
                children: [
                  DropdownButton<String>(
                    items: <String>['A', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                  InkWell(
                    child: Container(child: Text("UID")),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
