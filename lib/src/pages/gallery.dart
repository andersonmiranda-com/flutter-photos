import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:AlboomProof/src/providers/API.dart';
import 'package:AlboomProof/src/pages/photo.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List proofRows = [];
  Map proofDetails = {};
  bool _loadingInProgress;

  void initState() {
    super.initState();
    _loadingInProgress = true;
    _getProof("k78si6");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Color(0xff202020),
    );
  }

  void _getProof(unique_id) {
    API.getProof(unique_id).then((response) {
      var proofData = json.decode(response.body);
      setState(() {
        proofDetails = proofData["proof"];
        proofRows = proofData["rows"];
        _loadingInProgress = false;
      });
      print(proofDetails);
      print(proofRows);
    });
  }

  void _setSelected(int i, String state) {
    setState(() {
      proofRows[i]["taken"] = state;
    });
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return new Center(
        child: new CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation(Color(0xff404040)),
        ),
      );
    } else {
      return new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.black54,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text(proofDetails["name"] != null ? proofDetails["name"] : ""),
                  background: proofDetails["name"] != null
                      ? Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/723/" +
                                        proofDetails["cover"],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Color(0x00000000),
                                        Color(0x00000000),
                                        Color(0x20000000),
                                        Color(0x90000000),
                                      ],
                                      stops: [
                                        0.0,
                                        0.5,
                                        0.7,
                                        1.0
                                      ])),
                            )
                          ],
                        )
                      : Container(),
                  centerTitle: false),
            ),
          ];
        },
        body: Center(child: _buildProofGrid()),
      );
    }
  }

  Widget _buildProofGrid() {
    Widget proofGrid;
    if (proofRows.length > 0) {
      proofGrid = OrientationBuilder(builder: (context, orientation) {
        int columnCount = (orientation == Orientation.portrait) ? 4 : 8;
        return GridView.builder(
            padding: EdgeInsets.only(top: 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columnCount),
            itemBuilder: _buildProofItem,
            itemCount: proofRows.length);
      });
    } else {
      proofGrid = Container();
    }
    return proofGrid;
  }

  Widget _buildProofItem(BuildContext context, int index) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PhotoPage(
                      proofRows,
                      index,
                      "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/723/",
                      _setSelected),
                ));
          },
          onDoubleTap: () => {
                setState(() {
                  if (proofRows[index]["taken"] == "1") {
                    proofRows[index]["taken"] = "0";
                  } else {
                    proofRows[index]["taken"] = "1";
                  }
                })
              },
          child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.all(1.0),
            child: CachedNetworkImage(
              imageUrl:
                  "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/thumbnails/proofs/723/" +
                      proofRows[index]["file"],
              fit: BoxFit.cover,
              // placeholder: (context, url) => Center(
              //         child: CircularProgressIndicator(
              //       valueColor: new AlwaysStoppedAnimation(Color(0xff303030)),
              //     )),
              //errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3.0),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => {
                    setState(() {
                      if (proofRows[index]["taken"] == "1") {
                        proofRows[index]["taken"] = "0";
                      } else {
                        proofRows[index]["taken"] = "1";
                      }
                    })
                  },
              child: proofRows[index]["taken"] == "1"
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.amber,
                      size: 20.0,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      color: Color(0x00000000),
                      size: 20.0,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

// link descrição da prova:
// GET https://andersonmiranda.clicster.com/api/proofs/get_by_unique_id/k78si6/published/S

//LINK imagens:
// POST https://andersonmiranda.clicster.com/api/proofs/select_view
// body:
// {
//  "count": 100,
//  "offset": 0,
//  "unique_id": "k78si6"
// }

//LINK Imagem:
// https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/723/292-0005.jpg
