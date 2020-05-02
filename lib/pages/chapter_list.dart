import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shapeup/pages/pdf_viewer.dart';

class ChapterList extends StatefulWidget {
  final String docPath;

  ChapterList(this.docPath);

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  final Firestore _fireStore = Firestore.instance;
  DocumentReference ref;
  List<String> chapters = [];

  _getChapters(DocumentSnapshot x) {
    int i = 1;
    while (true) {
      if (x.data.containsKey('Chapter ' + i.toString())) {
        chapters.add(x['Chapter ' + i.toString()]);
        i++;
      } else {
        break;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ref = _fireStore.document(widget.docPath);
    ref.get().then((ds) {
      _getChapters(ds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a chpater"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.note),
              title: Text('Chapter ' + (index + 1).toString()),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PdfViewer(chapters[index]))),
            ),
          );
        },
        physics: BouncingScrollPhysics(),
        itemCount: chapters.length,
      ),
    );
  }
}
