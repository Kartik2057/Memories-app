import 'dart:io';
import 'package:flutter_complete_guide/models/place.dart';
import 'package:flutter_complete_guide/providers/great_places.dart';
import '../widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/location_input.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/add-place"; 
  
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation ;

  void _selectImage(File pickedImage)
  {
    // print("_selectImage");
     _pickedImage = pickedImage;
  }

  void _savePlace() {
    // print("save place 1");
    // print(_pickedImage==null);

     if(_titleController.text.isEmpty ||  
     _pickedImage == null){
       return;
     }
     Provider.of<GreatPlaces>(context,listen: false).addPlace(
      _titleController.text, _pickedImage, _pickedLocation);
      // print("save place");
     Navigator.of(context).pop();
  }
  

  void _selectPlace(double lat, double lng)
  {
     _pickedLocation = PlaceLocation("", lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    print("In the build of add");
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new Place"
        ),
      ),
      body: Column( 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                   TextField(
                    decoration: InputDecoration(
                      labelText: 'Title',  
                      ),
                      controller: _titleController,
                   ),
                   SizedBox(height: 10),
                   ImageInput(_selectImage),
                   SizedBox(
                    height: 10,
                   ),
                   LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          // Text("User Inputs ..."),
           ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text("Add Place"),
            onPressed: () => _savePlace(),
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: MaterialStateProperty.all(Theme.of(context).accentColor),
              ),
            )
        ],
      ),
    );
  }
}