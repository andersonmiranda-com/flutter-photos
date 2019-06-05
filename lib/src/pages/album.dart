import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:AlboomProof/src/providers/API.dart';
import 'package:AlboomProof/src/pages/photo.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key key}) : super(key: key);

  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List proofRows = [];
  Map proofDetails = {};
  bool _loadingInProgress;
  int _index = 1;
  int _flipIndex = 1;
  Offset _offset = Offset(0.0, 0.0);
  double _flipAngleDeg = 0.0;
  double _flipAngleDegLeft = 0.0;
  double _flipAngleDegRight = 0.0;
  bool _showflipLeft = false;
  bool _showflipRight = false;

  void initState() {
    super.initState();
    _loadingInProgress = true;
    _getProof("u6QfdC");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
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
      return _buildProofGrid();
    }
  }

  Widget _buildProofGrid() {
    return SafeArea(
      child: GestureDetector(
        onPanUpdate: (details) => _updateOffset(details),
        onTap: () => _incrIndex(),
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
      onTap: () => _decrIndex(),
      child: SizedBox.expand(
        child: CachedNetworkImage(
          imageUrl:
              "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                  proofRows[_index]["file"],
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildAlbumRight() {
    return GestureDetector(
      onPanUpdate: (details) => _updateOffset(details),
      onTap: () => _incrIndex(),
      child: SizedBox.expand(
        child: CachedNetworkImage(
          imageUrl:
              "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                  proofRows[_index + 1]["file"],
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildAlbumFlipLeft() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateY(_flipAngleDegLeft / 180 * pi),
      alignment: FractionalOffset.centerRight,
      child: GestureDetector(
        onTap: () => _decrIndex(),
        child: SizedBox.expand(
          child: CachedNetworkImage(
            imageUrl:
                "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                    proofRows[_flipIndex]["file"],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumFlipRight() {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001) // perspective
        ..rotateY(_flipAngleDegRight / 180 * pi),
      alignment: FractionalOffset.centerLeft,
      child: GestureDetector(
        onTap: () => _incrIndex(),
        child: SizedBox.expand(
          child: CachedNetworkImage(
            imageUrl:
                "https://photomanager-sp.s3.amazonaws.com/ups/andersonmiranda/files/proofs/582/" +
                    proofRows[_flipIndex + 1]["file"],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  void _decrIndex() {
    setState(() {
      if (_index >= 3) {
        _index = _index - 2;
        _flipIndex = _flipIndex - 2;
        _offset = Offset(0.0, 0.0);
        _flipAngleDeg = 0;
        _showflipLeft = false;
        _showflipRight = false;
      }
    });
  }

  void _incrIndex() {
    setState(() {
      if (_index < proofRows.length - 2) {
        _index = _index + 2;
        _flipIndex = _flipIndex + 2;
        _offset = Offset(0.0, 0.0);
        _flipAngleDeg = 0;
        _showflipLeft = false;
        _showflipRight = false;
      }
    });
  }

  void _updateOffset(DragUpdateDetails details) {
    setState(() {
      print(details.delta);
      _offset += details.delta;
      _flipAngleDeg = _offset.dx / (MediaQuery.of(context).size.width - 100) * -1 * 180;


      //percebe o movimento: avançando ou voltando página


      //final de movimento


      if (_flipAngleDeg < 0) _flipAngleDeg = 0;
      if (_flipAngleDeg > 180) _flipAngleDeg = 180;

      print(_flipAngleDeg);

      //decide que lamina girar
      if (_flipAngleDeg >= 0 && _flipAngleDeg <= 90) {
        _flipAngleDegRight = _flipAngleDeg;
        _showflipLeft = false;
        _showflipRight = true;
      } else {
        _flipAngleDegLeft = _flipAngleDeg - 180;
        _showflipLeft = true;
        _showflipRight = false;
      }
    });
  }
}
