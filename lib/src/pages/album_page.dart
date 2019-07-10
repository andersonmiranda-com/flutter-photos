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

  int _index = -1;
  int _spreadLeftIndex = -1;
  int _spreadRightIndex = 0;
  int _flipLeftIndex = -1;
  int _flipRightIndex = 0;
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
  double imageWidth;
  int maxImageWidth;
  int maxImageHeight;
  Widget _thisImage;
  String _thisImageUrl;

  void initState() {
    super.initState();
//    _getProof("u6QfdC");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _collection = ModalRoute.of(context).settings.arguments;

      maxImageWidth = (MediaQuery.of(context).size.width * 0.45).round();
      maxImageHeight = (MediaQuery.of(context).size.height * 0.83).round();

      if (_collection.diagramation == "pages") {
        imageWidth = (_collection.photos[2].width / _collection.photos[2].height) * maxImageHeight;
      } else {
        imageWidth =
            (_collection.photos[2].width / 2 / _collection.photos[2].height) * maxImageHeight;
      }
    });

    return Scaffold(
      backgroundColor: Color(0xFF5f5e5e),
      body: Stack(
        children: <Widget>[
          _buildAlbumSpread(),
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
    );
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
                    //_buildBackCoverCache(),
                    _buildAlbumCacheLeft(),
                    _buildAlbumLeft(),
                    _showflipLeft ? _buildAlbumFlipLeft() : Container(),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    _buildAlbumCacheRight(),
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

//
//  ---------------------------------------  LEFT PAGE
//
  Widget _buildAlbumLeft() {
    if (_spreadLeftIndex == -1) {
      _thisImage =
          Image.asset("assets/transparent.png", height: maxImageHeight * 1.0, width: imageWidth);
    } else if (_spreadLeftIndex == _collection.photos.length) {
      _thisImage = CachedNetworkImage(
        imageUrl: CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[0].url,
                height: _collection.photos[0].height,
                width: (_collection.photos[1].width / 2).round(),
                mp: 'cl'),
            height: maxImageHeight,
            width: imageWidth.round()),
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    } else {
      //testa se é por pagina ou lamina
      if (_collection.diagramation == "pages") {
        _thisImageUrl = CollectionProvider.getReducedImage(_collection.photos[_spreadLeftIndex].url,
            height: maxImageHeight, width: imageWidth.round());
      } else {
        //se for por lamina, corta em 2
        _thisImageUrl = CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[(_spreadLeftIndex ~/ 2) + 1].url,
                height: _collection.photos[0].height,
                width: _collection.photos[1].width ~/ 2,
                mp: 'cl'),
            height: maxImageHeight,
            width: imageWidth.round());
      }

      _thisImage = CachedNetworkImage(
        imageUrl: _thisImageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    }

    return GestureDetector(
      //onTap: () => _decrIndex(),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.centerRight,
          child: _thisImage,
        ),
      ),
    );
  }

//
//  ---------------------------------------  RIGHT PAGE
//

  Widget _buildAlbumRight() {
    if (_spreadRightIndex == 0) {
      _thisImage = CachedNetworkImage(
        imageUrl: CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[0].url,
                height: _collection.photos[0].height, width: _collection.photos[1].width, mp: 'cr'),
            height: maxImageHeight,
            width: imageWidth.round()),
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    } else if (_spreadRightIndex >= _collection.photos.length) {
      _thisImage =
          Image.asset("assets/transparent.png", height: maxImageHeight * 1.0, width: imageWidth);
    } else {
      //testa se é por pagina ou lamina
      if (_collection.diagramation == "pages") {
        _thisImageUrl = CollectionProvider.getReducedImage(
            _collection.photos[_spreadRightIndex].url,
            height: maxImageHeight,
            width: imageWidth.round());
      } else {
        //se for por lamina, corta em 2
        _thisImageUrl = CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[(_spreadRightIndex ~/ 2)].url,
                height: _collection.photos[0].height,
                width: (_collection.photos[1].width ~/ 2),
                mp: 'cr'),
            height: maxImageHeight,
            width: imageWidth.round());
      }

      _thisImage = CachedNetworkImage(
        imageUrl: _thisImageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    }

    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details),
      //onTap: () => _incrIndex(),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.centerLeft,
          child: _thisImage,
        ),
      ),
    );
  }

//
//  ---------------------------------------  LEFT FLIP PAGE
//

  Widget _buildAlbumFlipLeft() {
    if (_flipLeftIndex == -1) {
      _thisImage =
          Image.asset("assets/transparent.png", height: maxImageHeight * 1.0, width: imageWidth);
    } else if (_flipLeftIndex >= _collection.photos.length) {
      _thisImage = CachedNetworkImage(
        imageUrl: CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[0].url,
                height: _collection.photos[0].height, width: _collection.photos[1].width, mp: 'cl'),
            height: maxImageHeight,
            width: imageWidth.round()),
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    } else {
      //testa se é por pagina ou lamina
      if (_collection.diagramation == "pages") {
        _thisImageUrl = CollectionProvider.getReducedImage(_collection.photos[_flipLeftIndex].url,
            height: maxImageHeight, width: imageWidth.round());
      } else {
        //se for por lamina, corta em 2
        _thisImageUrl = CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[_flipLeftIndex ~/ 2 + 1].url,
                height: _collection.photos[0].height,
                width: _collection.photos[1].width ~/ 2,
                mp: 'cl'),
            height: maxImageHeight,
            width: imageWidth.round());
      }

      _thisImage = CachedNetworkImage(
        imageUrl: _thisImageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    }

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
            child: _thisImage,
          ),
        ),
      ),
    );
  }

//
//  ---------------------------------------  RIGHT FLIP PAGE
//

  Widget _buildAlbumFlipRight() {
    if (_flipRightIndex == 0) {
      _thisImage = CachedNetworkImage(
        imageUrl: CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[0].url,
                height: _collection.photos[0].height, width: _collection.photos[1].width, mp: 'cr'),
            height: maxImageHeight,
            width: imageWidth.round()),
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    } else if (_flipRightIndex >= _collection.photos.length) {
      _thisImage =
          Image.asset("assets/transparent.png", height: maxImageHeight * 1.0, width: imageWidth);
    } else {
      //testa se é por pagina ou lamina
      if (_collection.diagramation == "pages") {
        _thisImageUrl = CollectionProvider.getReducedImage(_collection.photos[_flipRightIndex].url,
            height: maxImageHeight, width: imageWidth.round());
      } else {
        //se for por lamina, corta em 2
        _thisImageUrl = CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(
                _collection.photos[(_flipRightIndex / 2).round()].url,
                height: _collection.photos[0].height,
                width: (_collection.photos[1].width / 2).round(),
                mp: 'cr'),
            height: maxImageHeight,
            width: imageWidth.round());
      }

      _thisImage = CachedNetworkImage(
        imageUrl: _thisImageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
              width: imageWidth,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(
                    Color(0x80303030),
                  ),
                ),
              ),
            ),
      );
    }

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
            child: _thisImage,
          ),
        ),
      ),
    );
  }

//
//  ---------------------------------------  CACHE PAGES
//

  Widget _buildAlbumCacheLeft() {
    if (_spreadLeftIndex < 1 || _spreadLeftIndex > _collection.photos.length - 1) {
      return Container();
    }

    final _preCache1 = (_spreadLeftIndex < _collection.photos.length - 2)
        ? _spreadLeftIndex + 2
        : _spreadLeftIndex;
    final _preCache2 = (_spreadLeftIndex < _collection.photos.length - 4)
        ? _spreadLeftIndex + 4
        : _spreadLeftIndex;

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.0,
          child: CachedNetworkImage(
            imageUrl: CollectionProvider.getReducedImage(_collection.photos[_preCache2].url,
                height: maxImageHeight, width: imageWidth.round()),
            fit: BoxFit.contain,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: CachedNetworkImage(
            imageUrl: CollectionProvider.getReducedImage(_collection.photos[_preCache1].url,
                height: maxImageHeight, width: imageWidth.round()),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildBackCoverCache() {
    return Opacity(
      opacity: 0.0,
      child: CachedNetworkImage(
        imageUrl: CollectionProvider.getReducedImage(
            CollectionProvider.getCroppedImage(_collection.photos[0].url,
                height: _collection.photos[0].height, width: _collection.photos[1].width, mp: 'cl'),
            height: maxImageHeight,
            width: imageWidth.round()),
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAlbumCacheRight() {
    if (_spreadRightIndex < 2 || _spreadRightIndex > _collection.photos.length - 2)
      return Container();
    final _preCache1 = (_spreadRightIndex < _collection.photos.length - 2)
        ? _spreadRightIndex + 2
        : _spreadRightIndex;
    final _preCache2 = (_spreadRightIndex < _collection.photos.length - 4)
        ? _spreadRightIndex + 4
        : _spreadRightIndex;

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.0,
          child: CachedNetworkImage(
            imageUrl: CollectionProvider.getReducedImage(_collection.photos[_preCache2].url,
                height: maxImageHeight, width: imageWidth.round()),
            fit: BoxFit.contain,
          ),
        ),
        Opacity(
          opacity: 0.0,
          child: CachedNetworkImage(
            imageUrl: CollectionProvider.getReducedImage(_collection.photos[_preCache1].url,
                height: maxImageHeight, width: imageWidth.round()),
            fit: BoxFit.contain,
          ),
        ),
      ],
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

    print('fliping');
    print(_index);

    if ((_directionLeft && _index < _collection.photos.length) || (!_directionLeft && _index > 0)) {
      _flipAngleDeg = _offset.dx / (MediaQuery.of(context).size.width / 2) * -1 * 180;

      if (!_directionLeft) {
        _flipAngleDeg = 180 + _flipAngleDeg;
      }

      _updateAngles();
    }
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

        if (!_pageChanged && _directionLeft && _index < _collection.photos.length) {
          _spreadRightIndex = _spreadRightIndex + 2;
          _flipLeftIndex = _flipLeftIndex + 2;
          _pageChanged = true;
        }
      } else {
        _flipAngleDegLeft = _flipAngleDeg - 180;
        _showflipLeft = true;
        _showflipRight = false;

        if (!_pageChanged && !_directionLeft && _index > 0) {
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
      if (!_directionLeft && _index > 0) {
        _index = _index - 2;
      }
    } else {
      if (_directionLeft && _index < _collection.photos.length) {
        _index = _index + 2;
        print(_index);
        print(_collection.photos.length);
      }
    }

    //_offset = Offset(0.0, 0.0);
    //_flipAngleDeg = _offset.dx / (MediaQuery.of(context).size.width / 1.5) * -1 * 180;

    _updateIndexes();
  }
}
