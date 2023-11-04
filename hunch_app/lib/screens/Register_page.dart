import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunch_app/emailverification.dart';

class SignUP extends StatefulWidget {
  const SignUP({super.key});

  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final passwordContoller = TextEditingController();
  final emailController = TextEditingController();

  final confirmPasswordController = TextEditingController();
  final key = GlobalKey();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



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
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordContoller.text,
        );

        if (userCredential.user != null) {
          // Add user data to Firestore after successful registration
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
    await _firestore.collection('user').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      // Add more user information as needed
    });
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
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Signup Page"),
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/computer.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Center(
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
                                    height: 20,
                                  ),
                                  TextFormField(
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return 'Please enter your password';
                                    //   } else if (value.length < 6) {
                                    //     return 'Password must be at least 6 characters!';
                                    //   }
                                    //   return null;
                                    // },

                                    validator: validatePassword,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: passwordContoller,

                                    obscureText: _obscureText,

                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurpleAccent),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurpleAccent),
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                                    Icons
                                                        .remove_red_eye_rounded,
                                                  )
                                                : Icon(Icons
                                                    .remove_red_eye_outlined))),
                                  ),
                                  const SizedBox(
                                    height: 20,
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurpleAccent),
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                                    Icons
                                                        .remove_red_eye_rounded,
                                                  )
                                                : Icon(Icons
                                                    .remove_red_eye_outlined))),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            )),
                        ElevatedButton.icon(
                          onPressed: () {
                            _submitForm();
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