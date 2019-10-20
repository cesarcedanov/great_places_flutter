import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  Future<void> _openPhotoLibrary() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return null;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image',
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.photo_camera),
                label: Text('Take a Picture'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _takePicture,
              ),
              FlatButton.icon(
                icon: Icon(Icons.photo_library),
                label: Text('Opeh Photo Library'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _openPhotoLibrary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
