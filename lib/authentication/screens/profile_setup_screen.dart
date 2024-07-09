import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mega_app_project/authentication/repository/auth_repository.dart';
import 'package:mega_app_project/utils.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref.read(AuthRepositoryProvider).profileSetup(
          image , name , context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(21, 0, 31, 1),
              Color.fromRGBO(66, 1, 51, 1),
              Color.fromRGBO(32, 1, 47, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 0.75, 0.9],
          ),
        ),
        child: SafeArea(
          child: Center(
              child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 64,
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(Icons.add_a_photo)))
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Enter Your UserName'),
                    ),
                  ),
                  IconButton(onPressed: storeUserData, icon: Icon(Icons.done))
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
