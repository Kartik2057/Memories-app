import 'package:flutter/material.dart';
import '../screens/map_screen.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocationInput extends StatefulWidget {
  // const LocationInput({Key key}) : super(key: key);
  final Function onselectPlace;
  LocationInput(this.onselectPlace);
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  

  void _showPreview(double lat, double lng){
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(lat, lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }


  Future<void> _selectOnMap() async {
  final LatLng selectedLocation = await Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(
        isSelecting: true,
      )
    ),
    );
  if(selectedLocation == null){
    return;
  }  
  print(selectedLocation.latitude);
  widget.onselectPlace(
    selectedLocation.latitude,
    selectedLocation.longitude
    );
}
  
  Future <void> _getCurrentUserLocation() async{
    try {
    final locData = await Location().getLocation();
    _showPreview(
      locData.latitude, 
      locData.longitude
      );
    widget.onselectPlace(locData.latitude,locData.longitude);
    } catch (e) {
      return;
    }
    // print(locData.latitude);
    // print(locData.longitude);
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1, 
              color: Colors.grey
              ),
          ),
          child: _previewImageUrl == null ? Text("No Location Chosen",
          textAlign: TextAlign.center)
          :Image.network(_previewImageUrl, 
          fit: BoxFit.cover,
          width: double.infinity,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              onPressed: _getCurrentUserLocation, 
              icon: Icon(Icons.location_on), 
              label: Text("Current Location"),
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor), 
                  ),
              ),
              TextButton.icon(
                onPressed: _selectOnMap, 
                icon: Icon(Icons.map), 
                label: Text("Select on Map"),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor), 
                  ),
                )
          ],
        )
      ],
    );
  }
}



