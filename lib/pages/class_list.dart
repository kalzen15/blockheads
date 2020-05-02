import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shapeup/pages/content_list.dart';
import 'package:shapeup/pages/subject_list.dart';
import 'package:shapeup/pages/welcome_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassList extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  static const String id = 'classes';

  _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, WelcomeScreen.id);
  }

  _launchURL() async {
    const String url='http://suyashchandra.tech/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class List "),
      ),
      drawer: Drawer(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.launch),
              title: Text("Forum"),
              onTap:  _launchURL,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                _signOut(context);
              },
            )
          ],
        ),
      ),
      body: StaggeredGridView.countBuilder(
        physics: BouncingScrollPhysics(),
        crossAxisCount: 4,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubjectList("Class ${index + 1}"),
            ),
          ),
          child: new Container(
            child: Center(
                child: Text(
              "Class ${index + 1}",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
            )),
            decoration: BoxDecoration(
                color: Color(0xFFf8fbf8),
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[300],
                      offset: Offset(10.0, 10.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-10.0, -10.0),
                      blurRadius: 8.0,
                      spreadRadius: 2.0)
                ]),
          ),
        ),
        staggeredTileBuilder: (int index) =>
            new StaggeredTile.count(2, index.isEven ? 2 : 1),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}
