import 'dart:math';
import 'package:flutter/material.dart';

import 'package:AlboomPhotos/src/models/collection_model.dart';
import 'package:AlboomPhotos/src/providers/collections_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key key}) : super(key: key);

  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  Collection _collection;

  bool _loadingInProgress = false;
  int _index = 1;
  int _spreadLeftIndex = 1;
  int _spreadRightIndex = 2;
  int _flipLeftIndex = 1;
  int _flipRightIndex = 2;
  Offset _offset = Offset(0.0, 0.0);
  double _flipAngleDeg = 0.0;
  double _flipAngleDegLeft = 0.0;
  double _flipAngleDegRight = 0.0;
  bool _showflipLeft = false;
  bool _showflipRight = false;
  bool _directionLeft = false;
  bool _isMoving = false;
  bool _pageChanged = false;
  int flipDuration = 0;
  int maxImageWidth;
  int maxImageHeight;

  void initState() {
    super.initState();
//    _loadingInProgress = true;
//    _getProof("u6QfdC");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      maxImageWidth = (MediaQuery.of(context).size.width * 0.45).round();
      maxImageHeight = (MediaQuery.of(context).size.height * 0.8).round();

      _collection = ModalRoute.of(context).settings.arguments;
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBody(),
          Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    child: BackButton(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.grey,
    );
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return new Center(
        child: new CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation(Color(0xff404040)),
        ),
      );
    } else {
      return _buildAlbumSpread();
    }
  }

  Widget _buildAlbumSpread() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: GestureDetector(
          onHorizontalDragStart: (details) => _onPanStart(details),
          onHorizontalDragEnd: (details) => _onPanEnd(details),
          onHorizontalDragCancel: () => _onPanEnd('cancel'),
          onHorizontalDragUpdate: (details) => _updateOffset(details),
          //onTap: () => _incrIndex(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    _buildAlbumLeft(),
                    _showflipLeft ? _buildAlbumFlipLeft() : Container(),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    _buildAlbumRight(),
                    _showflipRight ? _buildAlbumFlipRight() : Container(),
                  ],
                ),
              ),
              //_buildAlbumRight(context, index);            //_buildAlbumRight(context, index);
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumLeft() {
    final imageWidth =
        (_collection.photos[_spreadLeftIndex].width / _collection.photos[_spreadLeftIndex].height) *
            maxImageHeight;

    return GestureDetector(
      //onTap: () => _decrIndex(),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.centerRight,
          child: CachedNetworkImage(
            imageUrl: CollectionProvider.getReducedImage(_collection.photos[_spreadLeftIndex].url,
                height: maxImageHeight, width: imageWidth.round()),
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(
                  width: imageWidth,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(
                        Color(0xff303030),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumRight() {
    final imageWidth =
        (_collection.photos[_spreadLeftIndex].width / _collection.photos[_spreadLeftIndex].height) *
            maxImageHeight;

    print('imageWidth');
    print(imageWidth);

    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details),
      //onTap: () => _incrIndex(),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.centerLeft,
          child: CachedNetworkImage(
            imageUrl: CollectionProvider.getReducedImage(_collection.photos[_spreadRightIndex].url,
                height: maxImageHeight, width: imageWidth.round()),
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(
                  width: imageWidth,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation(
                        Color(0xff303030),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumFlipLeft() {
    final imageWidth =
        (_collection.photos[_spreadLeftIndex].width / _collection.photos[_spreadLeftIndex].height) *
            maxImageHeight;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0008) // perspective
        ..rotateY(_flipAngleDegLeft / 180 * pi),
      alignment: FractionalOffset.centerRight,
      child: GestureDetector(
        //onTap: () => _decrIndex(),
        child: SizedBox.expand(
          child: Align(
            alignment: Alignment.centerRight,
            child: CachedNetworkImage(
              imageUrl: CollectionProvider.getReducedImage(_collection.photos[_flipLeftIndex].url,
                  height: maxImageHeight, width: imageWidth.round()),
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                    width: imageWidth,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation(
                          Color(0xff303030),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumFlipRight() {
    final imageWidth =
        (_collection.photos[_spreadLeftIndex].width / _collection.photos[_spreadLeftIndex].height) *
            maxImageHeight;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0008) // perspective
        ..rotateY(_flipAngleDegRight / 180 * pi),
      alignment: FractionalOffset.centerLeft,
      child: GestureDetector(
        //onTap: () => _incrIndex(),
        child: SizedBox.expand(
          child: Align(
            alignment: Alignment.centerLeft,
            child: CachedNetworkImage(
              imageUrl: CollectionProvider.getReducedImage(_collection.photos[_flipRightIndex].url,
                  height: maxImageHeight, width: imageWidth.round()),
              fit: BoxFit.contain,
              placeholder: (context, url) => Container(
                    width: imageWidth,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation(
                          Color(0xff303030),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  void _decrIndex() {
    setState(() {
      if (_index >= 3) {
        _index = _index - 2;
        _updateIndexes();
      }
    });
  }

  void _incrIndex() {
    setState(() {
      if (_index < _collection.photos.length - 3) {
        _index = _index + 2;
        _updateIndexes();
      }
    });
  }

  void _updateIndexes() {
    setState(() {
      _spreadLeftIndex = _index;
      _spreadRightIndex = _index + 1;
      _flipLeftIndex = _index;
      _flipRightIndex = _index + 1;
      _offset = Offset(0.0, 0.0);
      _flipAngleDeg = 0;
      _showflipLeft = false;
      _showflipRight = false;
      _pageChanged = false;
    });
  }

  void _updateOffset(DragUpdateDetails details) {
    //  print('details.delta');
    //  print(details.delta);

    _offset += details.delta;

    if (!_isMoving) {
      if (details.delta.dx < 0) {
        _directionLeft = true;
      } else {
        _directionLeft = false;
      }
      _isMoving = true;
    }

    print('_directionLeft');
    print(_directionLeft);

    //   print('offset dx');
    print('_isMoving');
    print(_isMoving);

    //   print('offset dx');
    //   print(_offset.dx);

    if (_directionLeft || _index > 2) {
      _flipAngleDeg = _offset.dx / (MediaQuery.of(context).size.width / 1.5) * -1 * 180;

      if (!_directionLeft) {
        _flipAngleDeg = 180 + _flipAngleDeg;
      }
    }

    _updateAngles();
  }

  void _updateAngles() {
    if (_flipAngleDeg < 0) {
      _flipAngleDeg = 0;
      //_offset = Offset(0.0, 0.0);
    }

    if (_flipAngleDeg > 180) {
      _flipAngleDeg = 180;
      //_offset = Offset(0.0, 0.0);
    }

    setState(() {
      //final de movimento
      print('_flipAngleDeg');
      print(_flipAngleDeg);

      //decide que lamina girar
      if (_flipAngleDeg >= 0 && _flipAngleDeg <= 90) {
        _flipAngleDegRight = _flipAngleDeg;
        _showflipLeft = false;
        _showflipRight = true;
        if (!_pageChanged && _directionLeft) {
          _spreadRightIndex = _spreadRightIndex + 2;
          _flipLeftIndex = _flipLeftIndex + 2;
          _pageChanged = true;
        }
      } else {
        _flipAngleDegLeft = _flipAngleDeg - 180;
        _showflipLeft = true;
        _showflipRight = false;

        if (!_pageChanged && !_directionLeft && _index > 2) {
          _spreadLeftIndex = _spreadLeftIndex - 2;
          _flipRightIndex = _flipRightIndex - 2;
          _pageChanged = true;
        }
      }
    });
  }

  void _onPanStart(details) {
    print('________________________onPanStart');
    print(details);
    _pageChanged = false;
    _isMoving = false;
  }

  void _onPanEnd(details) {
    print('________________________onPanEnd');
    print(details);

    _pageChanged = false;
    _isMoving = false;

    if (_flipAngleDeg >= 0 && _flipAngleDeg <= 90) {
      if (!_directionLeft && _index > 2) {
        _index = _index - 2;
      }
    } else {
      if (_directionLeft) {
        _index = _index + 2;
      }
    }

    _offset = Offset(0.0, 0.0);
    _flipAngleDeg = _offset.dx / (MediaQuery.of(context).size.width / 1.5) * -1 * 180;

    _updateIndexes();
  }
}
