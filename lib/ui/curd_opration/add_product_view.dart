import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoping_app_admin/utils/ui_helper.dart';

final _formKey = GlobalKey<FormState>();

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  late FirebaseFirestore db;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  XFile? _image;
  final storageRef = FirebaseStorage.instance.ref();
  String imgPath = '';
  bool isUploading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance; // Initialize Firestore
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed.
    titleController.dispose();
    descController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: _buildProductForm(),
    );
  }

  Widget _buildProductForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              hSpace(mHight: 40),
              _buildTextField(
                controller: titleController,
                hintText: "Product Name",
                labelText: "Product Name",
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter name' : null,
              ),
              hSpace(),
              _buildTextField(
                controller: descController,
                hintText: "Product Description",
                labelText: "Product Description",
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter product desc...'
                    : null,
              ),
              hSpace(),
              _buildTextField(
                controller: amountController,
                hintText: "Enter Amount",
                labelText: "Amount",
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter product amount'
                    : null,
              ),
              hSpace(),
              _buildImagePicker(),
              hSpace(),
              _buildAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hintText,
        labelText: labelText,
      ),
      validator: validator,
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _showPicker,
      child: imgPath.isNotEmpty
          ? Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(imgPath)),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Select Image",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _addProduct,
        child: isUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Add"),
      ),
    );
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate() && _image != null) {
      setState(() => isUploading = true);

      try {
        var timeMills = DateTime.now().millisecondsSinceEpoch;
        var uploadRef = storageRef.child('images/img_$timeMills.jpg');

        // Uploading the image file
        var uploadTask = await uploadRef.putFile(File(_image!.path));
        var downloadUrl = await uploadRef.getDownloadURL();

        // Adding the product details to Firestore
        await db.collection('product').add({
          'name': titleController.text,
          'description': descController.text,
          'amount': amountController.text,
          'image': downloadUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Added Successfully')),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product: $error')),
        );
      } finally {
        setState(() => isUploading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill out all fields and select an image')),
      );
    }
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
                },
              ),
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
      },
    );
  }

  Future<void> _imgFromCamera() async {
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

  Future<void> _imgFromGallery() async {
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
