import "package:flutter/material.dart";

class PhotoPage extends StatelessWidget {
  final String imageUrl;
  final int index;

  PhotoPage(this.imageUrl, this.index);

  @override
  Widget build(BuildContext context) {
    print(imageUrl);
    return Scaffold(
        appBar: AppBar(title: Text("Photo Detail")),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Hero(
            tag: "photo_$index",
            child: Image.network(imageUrl),
          )
        ]));
  }
}
