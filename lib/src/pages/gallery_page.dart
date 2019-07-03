import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:AlboomPhotos/src/models/collection_model.dart';
import 'package:AlboomPhotos/src/providers/collections_provider.dart';
import 'package:AlboomPhotos/src/pages/photo_page.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Collection _collection;
  bool _loadingInProgress;

  void initState() {
    super.initState();
//    _loadingInProgress = true;
//    _getCollection("se1e085");
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _collection = ModalRoute.of(context).settings.arguments;
    });
    //print(_collection.photos);

    return Scaffold(
      body: _buildBody(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  void _setSelected(int i, String state) {
    setState(() {
      //proofRows[i]["taken"] = state;
    });
  }

  Widget _buildBody() {
    return new NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _buildAppBar(),
        ];
      },
      body: Center(child: _buildProofGrid()),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      backgroundColor: Colors.black54,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          _collection.name != null ? _collection.name : "",
          style: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
        background: _collection.name != null
            ? Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: CollectionProvider.getReducedImage(_collection.cover,
                          height: 300, width: 500),
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
      ),
    );
  }

  Widget _buildProofGrid() {
    Widget proofGrid;
    if (_collection.photos != null && _collection.photos.length > 0) {
      proofGrid = OrientationBuilder(builder: (context, orientation) {
        int columnCount = (orientation == Orientation.portrait) ? 4 : 8;
        return GridView.builder(
          padding: EdgeInsets.only(top: 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columnCount),
          itemBuilder: _buildProofItem,
          itemCount: _collection.photos.length,
        );
      });
    } else {
      proofGrid = Container();
    }
    return proofGrid;
  }

  Widget _buildProofItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PhotoPage(_collection, index, _setSelected),
            ));
      },
      child: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(1.0),
        //child: Text(Uri.encodeFull(_collection.photos[index].url)),
        child: CachedNetworkImage(
          imageUrl: CollectionProvider.getReducedImage(_collection.photos[index].url),
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Stack(
              children: <Widget>[
                Center(
                  child: Image.asset("assets/loading.png"),
                ),
                Text(
                  '${index + 1}',
                  style: TextStyle(color: Colors.black12),
                ),
              ],
            );
          },
          //errorWidget: (context, url, error) => new Icon(Icons.error),
        ),
      ),
    );
  }
}
