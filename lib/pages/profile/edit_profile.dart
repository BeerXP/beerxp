import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:beerxp/pages/profile/profile.dart';
import 'package:beerxp/services/repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final String photoUrl, email, bio, name, phone;

  EditProfileScreen(
      {this.photoUrl, this.email, this.bio, this.name, this.phone});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _repository = Repository();
  FirebaseUser currentUser;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    analytics.setCurrentScreen(screenName: "Edit Profile");
    
    _nameController.text = widget.name;
    _bioController.text = widget.bio;
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _repository.getCurrentUser().then((user) {
      setState(() {
        currentUser = user;
        // _name = user.displayName;
        // _email = user.email;
      });
    });
    
  }

  File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xffff9800),
        elevation: 1,
        title: Text('Edit Profile'),
        leading: GestureDetector(
          child: Icon(Icons.close, color: Colors.black),
          onTap: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.done, color: Colors.blue),
            ),
            onTap: () {
              _repository
                  .updateDetails(
                      currentUser.uid,
                      _nameController.text,
                      _bioController.text,
                      _emailController.text,
                      _phoneController.text)
                  .then((v) {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: ((context) => ProfileScreen())
                ));
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                        width: 200.0,
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          image: DecorationImage(
                              image: widget.photoUrl.isEmpty
                                  ? AssetImage('assets/images/no_image.png')
                                  : NetworkImage(widget.photoUrl),
                              fit: BoxFit.cover),
                        )),
                  ),
                  onTap: _showImageDialog),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text('Change Photo',
                      style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),
                onTap: _showImageDialog,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  onSubmitted: (value) => _nameController.text = value.trim(),
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    labelText: 'Nome',
                  ),
                  // onChanged: ((value) {
                  //   setState(() {
                  //     _nameController.text = value;
                  //   });
                  // }),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  onSubmitted: (value) => _bioController.text = value.trim(),
                  controller: _bioController,
                  maxLines: 3,
                  decoration:
                      InputDecoration(hintText: 'Bio', labelText: 'Bio'),
                  // onChanged: ((value) {
                  //   setState(() {
                  //     _bioController.text = value;
                  //   });
                  // }),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Private Information',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  onSubmitted: (value) => _emailController.text = value.trim(),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Email address', labelText: 'Email address'),
                  // onChanged: ((value) {
                  //   setState(() {
                  //     _emailController.text = value;
                  //   });
                  // }),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: TextField(
                  onSubmitted: (value) => _phoneController.text = value.trim(),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: 'Phone Number', labelText: 'Phone Number'),
                  // onChanged: ((value) {
                  //   setState(() {
                  //     _phoneController.text = value;
                  //   });
                  // }),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _repository.uploadProfileImageToStorage(currentUser.uid, imageFile).then((url) {
                      _repository.updatePhoto(url, currentUser.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    compressImage();
                    _repository.uploadProfileImageToStorage(currentUser.uid, imageFile).then((url) {
                      _repository.updatePhoto(url, currentUser.uid).then((v) {
                        Navigator.pop(context);
                      });
                    });
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }
}