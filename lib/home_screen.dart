import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController shareText = TextEditingController();
  String Url =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Gull_portrait_ca_usa.jpg/1280px-Gull_portrait_ca_usa.jpg";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              //Text
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: shareText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Message",
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (shareText.text.isNotEmpty) {
                    await Share.share(shareText.text);
                  }
                },
                child: Text("Share this Message"),
              ),

              //Image
              Image.network(Url),
              ElevatedButton(
                onPressed: () async {
                  final res = await http.get(Uri.parse(Url));
                  final bytes = res.bodyBytes;
                  final temp = await getTemporaryDirectory();
                  final path = "${temp.path}/image.jpg";
                  File(path).writeAsBytesSync(bytes);

                  await Share.shareFiles([path]);
                },
                child: Text("Share this Image"),
              ),

              //File
              ElevatedButton(
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();

                  List<String>? files =
                      result?.files.map((e) => e.path).cast<String>().toList();
                  if (files == null) {
                    return;
                  }
                  await Share.shareFiles(files);
                },
                child: Text("Share File"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
