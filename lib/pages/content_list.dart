import 'package:flutter/material.dart';

class ContentList extends StatefulWidget {
  final String className;

  ContentList(this.className);

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
        title: Text(widget.className),
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
                  text: "Billers",
                ),
                Tab(
                  text: "My Bills",
                ),
              ],
              labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(color: Colors.white),
              unselectedLabelColor: accentColorGrayedOut,
            ),
          ),
          Expanded(
            flex: 3,
            child: TabBarView(
              controller: _tabController,
              children: [
                Billers(),
                MyBills(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
