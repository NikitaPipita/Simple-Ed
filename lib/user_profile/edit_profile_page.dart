import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final _userFirstNameController;
  final _userLastNameController;
  final _userDescriptionController;

  EditProfilePage(
      this._userFirstNameController,
      this._userLastNameController,
      this._userDescriptionController);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  File _image;
  getPhotoFileFromTheChild(File value) => _image = value;

  GlobalKey<FormState> _userProfileFormKey;

  @override
  void initState() {
    super.initState();
    _userProfileFormKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              //TODO: Implement profile delete and alert dialog.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePhoto(getPhotoFileFromTheChild),
              SizedBox(
                height: 15.0,
              ),
              ProfileInfoTextForm(
                _userProfileFormKey,
                widget._userFirstNameController,
                widget._userLastNameController,
                widget._userDescriptionController,
              ),
              SizedBox(
                height: 15.0,
              ),
              profileEditButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileEditButton() {
    return RaisedButton(
      child: Text('EDIT'),
      onPressed: () {
        if(_userProfileFormKey.currentState.validate()) {
          Navigator.pop(
            context,
            'update',
          );
        }
      },
    );
  }
}


class ProfilePhoto extends StatefulWidget {
  final Function sendPhotoFileToTheParent;

  ProfilePhoto(this.sendPhotoFileToTheParent);

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
  File _image;
  final picker = ImagePicker();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        widget.sendPhotoFileToTheParent(_image);
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: _image == null
          ? NetworkImage('https://w1.pngwing.com/pngs/743/500/png-transparent-circle-silhouette-logo-user-user-profile-green-facial-expression-nose-cartoon.png')
          : Image.file(_image).image,
      radius: 150.0,
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: getImage,
        ),
      ),
    );
  }
}



class ProfileInfoTextForm extends StatefulWidget {
  final _userProfileFormKey;
  final _userFirstNameController;
  final _userLastNameController;
  final _userDescriptionController;

  ProfileInfoTextForm(
      this._userProfileFormKey,
      this._userFirstNameController,
      this._userLastNameController,
      this._userDescriptionController);

  @override
  _ProfileInfoTextFormState createState() => _ProfileInfoTextFormState();
}

class _ProfileInfoTextFormState extends State<ProfileInfoTextForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._userProfileFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: widget._userFirstNameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your new name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field must not be empty";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._userLastNameController,
            decoration: InputDecoration(
              labelText: 'Surname',
              hintText: 'Enter your new surname',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "This field must not be empty";
              }
              return null;
            },
          ),
          TextFormField(
            controller: widget._userDescriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Profile Description',
              hintText: 'Write a short description about yourself',
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
