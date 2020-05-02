import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfViewer extends StatefulWidget {
  static const String id = 'pdf';
  final url;

  PdfViewer(this.url);

  @override
  PdfViewerState createState() {
    return new PdfViewerState();
  }
}

class PdfViewerState extends State<PdfViewer> {
  String imgUrl;

  bool downloading = false;
  var progressString = "";
  String _openResult = 'Unknown';

  Future<void> openFile() async {
    var dir = await getApplicationDocumentsDirectory();
    final filename = imgUrl.substring(imgUrl.lastIndexOf("/") + 1);
    final filePath = '${dir.path}/' + filename;

    final result = await OpenFile.open(filePath);

    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  @override
  void initState() {
    super.initState();
    imgUrl = widget.url;
    setState(() {
      downloading = true;
    });
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();
      final filename = imgUrl.substring(imgUrl.lastIndexOf("/") + 1);

      await dio.download(imgUrl, "${dir.path}/" + filename,
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Center(
        child: downloading
            ? Container(
                height: 120.0,
                width: 200.0,
                child: Card(
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Downloading File: $progressString",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : RaisedButton(
                child: Text('Tap to open file'),
                onPressed: openFile,
              ),
      ),
    );
  }
}
