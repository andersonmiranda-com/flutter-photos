import "package:flutter/material.dart";

class PhotoPage extends StatelessWidget {
  final String imageUrl;
  final String filename;
  final int index;

  PhotoPage(this.imageUrl, this.index, this.filename);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return Scaffold(
            backgroundColor: Colors.black54,
        appBar:
            AppBar(title: Text(filename), backgroundColor: Colors.black54),
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ])));
  }
}
