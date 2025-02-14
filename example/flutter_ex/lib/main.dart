import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart' as epub;
import 'package:flutter/services.dart';

void main() => runApp(EpubWidget());

class EpubWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EpubState();
}

class EpubState extends State<EpubWidget> {
  Future<epub.EpubBookRef>? book;

  void onSelectBook(String filename) {
    setState(() {
      book = fetchBook(filename);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetch Epub Example",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Material(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 16.0)),
                  ElevatedButton(
                    child: Text("Sample1"),
                    onPressed: () => onSelectBook('sample'),
                  ),
                  ElevatedButton(
                    child: Text("Sample2"),
                    onPressed: () => onSelectBook('sample2'),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.0)),
                  Center(
                    child: FutureBuilder<epub.EpubBookRef>(
                      future: book,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Material(
                            color: Colors.white,
                            child: buildEpubWidget(snapshot.data!),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        // By default, show a loading spinner
                        // return CircularProgressIndicator();

                        // By default, show just empty.
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildEpubWidget(epub.EpubBookRef book) {
  var chapters = book.getChapters();
  var cover = book.readCover();
  return Container(
      child: Column(
    children: <Widget>[
      Text(
        "Title",
        style: TextStyle(fontSize: 20.0),
      ),
      Text(
        book.Title!,
        style: TextStyle(fontSize: 15.0),
      ),
      Padding(
        padding: EdgeInsets.only(top: 15.0),
      ),
      Text(
        "Author",
        style: TextStyle(fontSize: 20.0),
      ),
      Text(
        book.Author!,
        style: TextStyle(fontSize: 15.0),
      ),
      Padding(
        padding: EdgeInsets.only(top: 15.0),
      ),
      FutureBuilder<List<epub.EpubChapterRef>>(
          future: chapters,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Text("Chapters", style: TextStyle(fontSize: 20.0)),
                  Text(
                    snapshot.data!.length.toString(),
                    style: TextStyle(fontSize: 15.0),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Container();
          }),
      Padding(
        padding: EdgeInsets.only(top: 15.0),
      ),
      FutureBuilder<Uint8List?>(
        future: cover,
        builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Text("Cover", style: TextStyle(fontSize: 20.0)),
                Image.memory(snapshot.data!),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Container();
        },
      ),
    ],
  ));
}

Future<epub.EpubBookRef> fetchBook(String filename) async {
  // // Hard coded to Alice Adventures In Wonderland in Project Gutenberb
  // final response = await http.get(Uri.parse(url));

  // if (response.statusCode == 200) {
  //   // If server returns an OK response, parse the EPUB
  //   return epub.EpubReader.openBook(response.bodyBytes);
  // } else {
  //   // If that response was not OK, throw an error.
  //   throw Exception('Failed to load epub');
  // }

  final bundle = await rootBundle.load('assets/$filename.epub');
  return epub.EpubReader.openBook(bundle.buffer.asUint8List());
}
