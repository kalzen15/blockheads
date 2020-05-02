import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shapeup/pages/chapter_list.dart';
import 'package:url_launcher/url_launcher.dart';


class ContentList extends StatefulWidget {
  final String subject_dir;

  ContentList(this.subject_dir);

  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resources"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.grey[300],
            height: 60,
            child: TabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  text: "Books",
                ),
                Tab(
                  text: "Videos",
                ),
              ],
              labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(color: Colors.blueAccent),
              unselectedLabelColor: Color(0xFF3b497a),
            ),
          ),
          Expanded(
            flex: 3,
            child: TabBarView(
              controller: _tabController,
              children: [
                Books(widget.subject_dir + '/Books'),
                Videos(widget.subject_dir),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Books extends StatelessWidget {
  final String subject_dir;

  Books(this.subject_dir);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(subject_dir).snapshots(),
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
                              builder: (_) => ChapterList(
                                  subject_dir + '/' + document.documentID)))),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class Videos extends StatefulWidget {
  final String subject_dir;

  Videos(this.subject_dir);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  DocumentReference ref;
  final Firestore _fireStore = Firestore.instance;
  List videos = [];

  _getVideos(DocumentSnapshot ds) {
    for (int i = 0; i < ds.data['videos'].length; i++) {
      videos.add(ds.data['videos'][i]);
    }
    setState(() {});
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    ref = _fireStore.document(widget.subject_dir);
    ref.get().then((ds) {
      _getVideos(ds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {
      return Card(
        child: ListTile(
          leading: Icon(
            Icons.videocam,
          ),
          title: Text(videos[index]),
          onTap: () {
            _launchURL(videos[index]);
          },
        ),
      );
    },itemCount: videos.length,);
  }
}
