import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  bool showSpinner = false;

  final postRef = FirebaseDatabase.instance.reference().child('Posts');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  File? _image ;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImageGallery()async{
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(PickedFile != null){
        _image = File(PickedFile.path);
      }
      else{
        print('no image select');
      }
      
    });

  }

  Future getCameraImage()async{
    final PickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(PickedFile != null){
        _image = File(PickedFile.path);
      }
      else{
        print('no image select');
      }
      
    });

  }

  void dialog(context){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          content: Container(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    getCameraImage();
                    Navigator.pop(context);

                  },
                  child: ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                
                  ),
                ),

                InkWell(
                  onTap: (){
                    getImageGallery();

                    
                    Navigator.pop(context);
                    
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                
                  ),
                )

              ],
            ),
          ),

        );
      }
      );
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('upload post'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    dialog(context);
    
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height* 0.2,
                      width: MediaQuery.of(context).size.width * 1,
                        
                      child: _image != null ? ClipRRect(
                        child: Image.file(
                          _image!.absolute,
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                        
                        ),
                      )
                      : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        width: 100,
                        height: 100,
                        child: 
                        Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                        ),
                        
                        
                      )
                    ),
                  ),
                ),
                SizedBox( height: 30,),
                Form(
                  child: Column(
                    children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text ,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter post title',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.grey , fontWeight: FontWeight.normal),
                        labelStyle:  TextStyle(color: Colors.grey , fontWeight: FontWeight.normal),
                      ),
    
                    ),
                    SizedBox(height: 30,),
    
                     TextFormField(
                      controller: descriptionController,
    
                      keyboardType: TextInputType.text ,
                      minLines: 1,
                      maxLength: 5,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter post description',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.grey , fontWeight: FontWeight.normal),
                        labelStyle:  TextStyle(color: Colors.grey , fontWeight: FontWeight.normal),
                      ),
    
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      onTap: () async{
                        setState(() {
                          showSpinner = true;
                        });

                        try{

                          int date = DateTime.now().microsecondsSinceEpoch;

                          firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/blogapp$date');
                          UploadTask uploadTask = ref.putFile(_image!.absolute);
                          await Future.value(uploadTask);
                          var newUrl = await ref.getDownloadURL();

                          postRef.child('Post List').child(date.toString()).set({

                          }).then((value){
                            // toastMessage('Post Published');
                            setState(() {
                              showSpinner = false;
                            });

                          }).onError((error, stackTrace){
                            // toastMessage(error.toString());
                            setState(() {
                              showSpinner = false;
                            });

                          });



                        }catch(e){
                          setState(() {
                            showSpinner = false;
                          });


                        }

    
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
                                
                                Text('Upload',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                                )
                              ],
                            ),
    
                          ),
                    )
                    
    
                  ],
                  )
                )
                  
                  
                  ],
                  
                ),
          ),
            
        )
          ),
    );
      

    
  }
}


// void toastMessage(String message){

//   Fluttertoast.showToast(
//     msg: message.toString(),
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.SNACKBAR,
//     timeInSecForIosWeb: 1,
//     backgroundColor: Colors.white,
//     textColor: Colors.black,
//     fontSize: 16


//   );
// }