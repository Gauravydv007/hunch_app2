import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hunch_app/screens/emailverification.dart';
import 'package:image_picker/image_picker.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final passwordContoller = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  final key = GlobalKey();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Image_add');

  String imageUrl = '';

  bool _obscureText = true;
  bool _obs = true;
  // ignore: unused_field

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      if (passwordContoller.text == confirmPasswordController.text) {
        // Passwords match, proceed with signup
        signUserUp();
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => EmailVerificationScreen(),
        //   ),
        // );
      } else {
        // Passwords do not match, show an error message in a dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Passwords don't match"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }

  String? _validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(value) {
    if (value!.isEmpty) {
      return "Enter Password";
    } else if (value.length < 6) {
      return "Password length should be more than 6 letters";
    } else if (value != confirmPasswordController.text) {
      return "Passwords don't match";
    }
    return null;
  }

  String? validatePassword(value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //   try {
    //     if (passwordContoller.text == confirmPasswordController.text) {
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //         email: emailController.text,
    //         password: passwordContoller.text,
    //       );
    //     } else {
    //       showErrorMessage("Password dont't match");
    //     }
    //   } on FirebaseAuthException catch (e) {
    //     Navigator.pop(context);

    //     showErrorMessage(e.code);
    //   }
    // }

    // void showErrorMessage(String message) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //             title: Center(
    //           child: Text(
    //             message,
    //             style: const TextStyle(color: Colors.black),
    //           ),
    //         ));
    //       });
    // }

    try {
      if (passwordContoller.text == confirmPasswordController.text) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordContoller.text,
        );

        if (userCredential.user != null) {
          // Add user data to Firestore after successful registration

          print('Username: ${usernameController.text}');

          addUserToFirestore(userCredential.user!);

          // Navigate to the email verification screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerificationScreen(),
            ),
          );
        } else {
          showErrorMessage("User registration failed");
        }
      } else {
        showErrorMessage("Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  void addUserToFirestore(User user) async {
    await _firestore.collection('user').doc(user.uid).set(
      {
        'uid': user.uid,
        'email': user.email,
        'username': usernameController.text,
        'image': imageUrl,
        // Add more user information as needed
      },
    );
    //  _reference.add(dataToSend);
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   title: const Text("Signup Page"),
          // ),
          body: Container(
        alignment: Alignment.bottomCenter,
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Untitled.png"),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Form(
                        key: _formkey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'UserName',
                                  labelText: " UserName",
                                  labelStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                validator: _validateEmail,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: emailController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepPurpleAccent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  hintText: 'Email',
                                  labelText: " Email",
                                  labelStyle: TextStyle(
                                    color: Colors.black54,
                                  ),
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                validator: validatePassword,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: passwordContoller,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: 'Password',
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    suffixIconConstraints: BoxConstraints(
                                      minHeight: 10,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: _toggle,
                                        icon: _obscureText
                                            ? Icon(
                                                Icons.remove_red_eye_rounded,
                                              )
                                            : Icon(Icons
                                                .remove_red_eye_outlined))),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                // validator: (value) {
                                //   if (value!.isEmpty) {
                                //     return "Enter Password";
                                //   } else if (passwordContoller.text.length <
                                //       6) {
                                //     return "Password length should be more than 6 Letters";
                                //   }
                                // },

                                validator: _validatePassword,

                                controller: confirmPasswordController,
                                obscureText: _obs,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepPurpleAccent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: ' Password',
                                    labelText: " Re-enter Password",
                                    labelStyle: TextStyle(
                                      color: Colors.black54,
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                    suffixIconConstraints: BoxConstraints(
                                      minHeight: 10,
                                    ),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obs = !_obs;
                                          });
                                        },
                                        icon: _obs
                                            ? Icon(
                                                Icons.remove_red_eye_rounded,
                                              )
                                            : Icon(Icons
                                                .remove_red_eye_outlined))),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          print('${file?.path}');
                          if (file == null) return;

                          // String uniqueFileName = DateTime.now().fromMillisecondsSinceEpoch.toString();
                          String uniqueFileName =
                              DateTime.now().millisecondsSinceEpoch.toString();

                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              referenceRoot.child('images');

                          //create a reference for the image to stored
                          Reference referenceImageToUpload =
                              referenceDirImages.child(uniqueFileName);

                          try {
                            await referenceImageToUpload
                                .putFile(File(file!.path));
                            // get down. url
                            imageUrl =
                                await referenceImageToUpload.getDownloadURL();
                          } catch (error) {
                            //some error occur
                          }

                          //store file
                          referenceImageToUpload.putFile(File(file!.path));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 8),
                          width: 200,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 173, 157, 204),
                        ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [

                              Image.asset(
                                "assets/images/icons8-camera-64 (1).png",
                                height: 40,
                              ),
                              
                              Text('Add Image',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),)
                            ],
                          ),

                        ),
                        
                        ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (imageUrl.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please add image'),
                          )
                          );
                        } else {
                          _submitForm();
                        }
                      },
                      icon: Icon(Icons.keyboard_arrow_right_sharp),
                      label: Text("Signup"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
