import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:AlboomPhotos/src/providers/API.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key key}) : super(key: key);

  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List proofRows = [];
  Map proofDetails = {};
  bool _loadingInProgress;
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

  void initState() {
    super.initState();
    _loadingInProgress = true;
    _getProof("u6QfdC");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Color(0xff202020),
    );
  }

  void _getProof(unique_id) {
    API.getAlbum(unique_id).then((response) {
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
    );
  }

  Widget _buildAlbumLeft() {
    return GestureDetector(
      //onTap: () => _decrIndex(),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.centerRight,
          child: CachedNetworkImage(
            imageUrl:
                "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                    proofRows[_spreadLeftIndex]["file"],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumRight() {
    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details),
      //onTap: () => _incrIndex(),
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.centerLeft,
          child: CachedNetworkImage(
            imageUrl:
                "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                    proofRows[_spreadRightIndex]["file"],
            fit: BoxFit.contain,
            placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation(
                      Color(0xff303030),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumFlipLeft() {
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
              imageUrl:
                  "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                      proofRows[_flipLeftIndex]["file"],
              fit: BoxFit.contain,
              placeholder: (context, url) => Center(
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

  Widget _buildAlbumFlipRight() {
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
              imageUrl:
                  "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                      proofRows[_flipRightIndex]["file"],
              fit: BoxFit.contain,
              placeholder: (context, url) => Center(
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
      if (_index < proofRows.length - 3) {
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
