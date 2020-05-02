import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shapeup/pages/content_list.dart';

class SubjectList extends StatelessWidget {
  final String className;

  SubjectList(this.className);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Subject"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(className).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return Card(
                    child: new ListTile(
                      title: new Text(document.documentID),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ContentList(
                                  className + '/' + document.documentID))),
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
