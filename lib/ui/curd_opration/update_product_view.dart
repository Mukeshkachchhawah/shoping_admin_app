import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shoping_app_admin/utils/ui_helper.dart'; // Add this import

class UpdateProductView extends StatefulWidget {
  String productId;
  String productName;
  String productDesc;
  String amount;
  String imgpath;

  UpdateProductView(
      {super.key,
      required this.productId,
      required this.productName,
      required this.productDesc,
      required this.amount,
      required this.imgpath});

  @override
  State<UpdateProductView> createState() => _UpdateProductViewState();
}

class _UpdateProductViewState extends State<UpdateProductView> {
  late FirebaseFirestore db;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  XFile? _image; // Initialize to null

  final storageRef = FirebaseStorage.instance.ref();
  String imgPath = '';
  bool isUploading = false;
  String? errorMessage;
  //String? productId; // To store the product id if we are updating

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance; // Firebase initialize

    titleController.text = widget.productName;
    descController.text = widget.productDesc;
    amountController.text = widget.amount;
    imgPath = widget.imgpath;
    // Initialize with existing product data if available
    /*    if (widget.product != null) {
      var product = widget.product!;
      titleController.text = product['name'];
      descController.text = product['description'];
      amountController.text = product['amount'].toString();
      imgPath = product['image'];
      productId = product.id; // Get the document ID
    } */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Product"),
      ),
      body: userAdminPenal(),
    );
  }

  Widget userAdminPenal() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              hSpace(mHight: 40),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Product Name",
                    labelText: "Product Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              hSpace(),
              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Product Description",
                    labelText: "Product Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product description';
                  }
                  return null;
                },
              ),
              hSpace(),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter Amount"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product amount';
                  }
                  return null;
                },
              ),
              hSpace(),
              InkWell(
                onTap: () {
                  _showPicker();
                },
                child: imgPath != ""
                    ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _image != null
                                ? FileImage(File(_image!.path))
                                : NetworkImage(imgPath) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                        ),
                      ),
              ),
              hSpace(),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          (imgPath != "" || _image != null)) {
                        setState(() {
                          isUploading = true;
                        });

                        try {
                          String downloadUrl = imgPath;
                          if (_image != null) {
                            var timeMills =
                                DateTime.now().millisecondsSinceEpoch;
                            var uploadRef = storageRef.child(
                                'images/img_$timeMills.jpg'); // image path in firebase

                            // Uploading the image file
                            var uploadTask =
                                await uploadRef.putFile(File(_image!.path));
                            debugPrint("Upload Task $uploadTask");
                            downloadUrl = await uploadRef.getDownloadURL();
                            debugPrint(
                                "File uploaded successfully. Download URL: $downloadUrl ");
                          }

                          // Updating the product details in Firestore
                          await db
                              .collection('product')
                              .doc(widget.productId)
                              .update({
                            'name': titleController.text,
                            'description': descController.text,
                            'amount': amountController.text,
                            'image': downloadUrl,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Product Updated Successfully')),
                          );
                          Navigator.pop(context);
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to update product: $error')),
                          );
                        } finally {
                          setState(() {
                            isUploading = false;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please fill out all fields and select an image')),
                        );
                      }
                    },
                    child: isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Update"),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                hSpace(),
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _imgFromCamera() async {
    try {
      var imgXFile = await ImagePicker().pickImage(source: ImageSource.camera);

      if (imgXFile != null) {
        setState(() {
          _image = imgXFile;
          imgPath = imgXFile.path;
        });
      }
    } catch (e) {
      print('Error picking image from camera: $e');
    }
  }

  _imgFromGallery() async {
    try {
      var imgXFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imgXFile != null) {
        setState(() {
          _image = imgXFile;
          imgPath = imgXFile.path;
        });
      }
    } catch (e) {
      print('Error picking image from gallery: $e');
    }
  }
}
