// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class PlaceMarkerPage extends Page {
  PlaceMarkerPage() : super(const Icon(Icons.place), 'Place marker');

  @override
  Widget build(BuildContext context) {
    return const PlaceMarkerBody();
  }
}

class PlaceMarkerBody extends StatefulWidget {
  const PlaceMarkerBody();

  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}

class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  static final LatLng center = const LatLng(-36.8189, -73.0503);

  PlaceMarkerBodyState();

  GoogleMapController controller;
  int _markerCount = 0;
  Marker _selectedMarker;

  

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    controller.onMarkerTapped.add(_onMarkerTapped);
    this._add();
  }
  

  @override
  void dispose() {
    controller?.onMarkerTapped?.remove(_onMarkerTapped);
    super.dispose();
  }


  void _onMarkerTapped(Marker marker) {
    if (_selectedMarker != null) {
      _updateSelectedMarker(
        const MarkerOptions(icon: BitmapDescriptor.defaultMarker),
      );
    }
    setState(() {
      _selectedMarker = marker;
    });
    _updateSelectedMarker(
      MarkerOptions(
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueCyan,
        ),
      ),
    );
  }

  void _updateSelectedMarker(MarkerOptions changes) {
    controller.updateMarker(_selectedMarker, changes);
  }

  void _add() {
    controller.addMarker(MarkerOptions(
      position: LatLng(-36.8189, -73.0503),
      infoWindowText: InfoWindowText('Grúa #${_markerCount + 1}', 'Transportes Telleo'),
    ));
    setState(() {
      _markerCount += 1;
    });
  }

  void _remove() {
    controller.removeMarker(_selectedMarker);
    setState(() {
      _selectedMarker = null;
      _markerCount -= 1;
    });
  }

  void _changePosition() {
    final LatLng current = _selectedMarker.options.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    _updateSelectedMarker(
      MarkerOptions(
        position: LatLng(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      ),
    );
  }

  void _changeAnchor() {
    final Offset currentAnchor = _selectedMarker.options.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    _updateSelectedMarker(MarkerOptions(anchor: newAnchor));
  }

  Future<void> _changeInfoAnchor() async {
    final Offset currentAnchor = _selectedMarker.options.infoWindowAnchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    _updateSelectedMarker(MarkerOptions(infoWindowAnchor: newAnchor));
  }

  Future<void> _toggleDraggable() async {
    _updateSelectedMarker(
      MarkerOptions(draggable: !_selectedMarker.options.draggable),
    );
  }

  Future<void> _toggleFlat() async {
    _updateSelectedMarker(MarkerOptions(flat: !_selectedMarker.options.flat));
  }

  Future<void> _changeInfo() async {
    final InfoWindowText currentInfo = _selectedMarker.options.infoWindowText;
    _updateSelectedMarker(MarkerOptions(
      infoWindowText: InfoWindowText(
        currentInfo.title,
        currentInfo.snippet + '*',
      ),
    ));
  }

  Future<void> _changeAlpha() async {
    final double current = _selectedMarker.options.alpha;
    _updateSelectedMarker(
      MarkerOptions(alpha: current < 0.1 ? 1.0 : current * 0.75),
    );
  }

  Future<void> _changeRotation() async {
    final double current = _selectedMarker.options.rotation;
    _updateSelectedMarker(
      MarkerOptions(rotation: current == 330.0 ? 0.0 : current + 30.0),
    );
  }

  Future<void> _toggleVisible() async {
    _updateSelectedMarker(
      MarkerOptions(visible: !_selectedMarker.options.visible),
    );
  }

  Future<void> _changeZIndex() async {
    final double current = _selectedMarker.options.zIndex;
    _updateSelectedMarker(
      MarkerOptions(zIndex: current == 12.0 ? 0.0 : current + 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  options: GoogleMapOptions(
                    cameraPosition: const CameraPosition(
                      target: LatLng(-36.8189, -73.0503),
                      zoom: 11.0,
                    )
                  )
              ),
            )
          ]
        )
      )
     );    
  }
}