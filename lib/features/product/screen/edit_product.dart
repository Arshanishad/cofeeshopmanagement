import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_management/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/common/globals.dart';
import '../../../core/pallete/theme.dart';
import '../../../core/widget/alertbox.dart';
import '../../../core/widget/rounded_loading_button.dart';
import '../../../core/widget/textformfield.dart';
import '../../../model/settings_model.dart';
import '../controller/product_controller.dart';
import '../repository/storage_repository.dart';

class ProductEdit extends ConsumerStatefulWidget {
  ProductModel data;
   ProductEdit({super.key, required this. data});

  @override
  ConsumerState<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends ConsumerState<ProductEdit> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  TextEditingController _nameController=TextEditingController();
  TextEditingController _descriptionController=TextEditingController();
  TextEditingController _priceController=TextEditingController();
  TextEditingController _categoryController=TextEditingController();
  TextEditingController _mrpController=TextEditingController();
  TextEditingController _taxController=TextEditingController();


  final _formKey = GlobalKey<FormState>();
  final imageProvider = StateProvider<File?>((ref) => null);
  final picker = ImagePicker();
  late ScaffoldMessengerState scaffoldMessenger;
  @override
  void initState() {
    _nameController=TextEditingController(text: widget.data.productName);
     _descriptionController=TextEditingController(text: widget.data.description);
     _priceController=TextEditingController(text: widget.data.mrp.toString());
     _categoryController=TextEditingController(text: widget.data.category);
     _mrpController=TextEditingController(text: widget.data.mrp.toString());
     _taxController=TextEditingController(text: widget.data.tax.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }
  @override


  @override

  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }


  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref
          .watch(imageProvider.notifier)
          .update((state) => File(pickedFile.path));
    }
    if(mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      ref
          .watch(imageProvider.notifier)
          .update((state) => File(pickedFile.path));
    }
    if(mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an option"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: _getImageFromGallery,
                  child: const Text("Gallery"),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _getImageFromCamera,
                  child: const Text("Camera"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SettingsModel? settingsModel;

  Future<void> _addProduct(BuildContext context, Function(String) onUploadSuccess, Function(String) onError,) async {
    File? imageFile = ref.read(imageProvider);
    if (imageFile != null) {
      try {
        String imageUrl = await ref
            .read(storageRepositoryProvider)
            .storeFile(path: 'product_images/${DateTime.now().millisecondsSinceEpoch}.png', file: imageFile);




        // Call productAdd method
        ref
            .read(productControllerProvider.notifier).editProduct(context: context, categoryId: widget.data.category,
            description: widget.data.description, tax: widget.data.tax, name: widget.data.productName, mrp: widget.data.mrp,
            productModel: widget.data);


        // Clear text controllers
        _nameController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _categoryController.clear();
        _mrpController.clear();
        _taxController.clear();
        _categoryController.clear();

        onUploadSuccess('Product added successfully!');
      } catch (e) {
        onError('Error uploading image: $e');
      }
    } else {
      onError('No image selected.');
    }
  }

  void confirmAlert() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            onConfirmed: () {
              _addProduct(context, (p0) => null, (p0) => null,);
              // _addProduct(context, (message) {
              //   scaffoldMessenger.showSnackBar(
              //     SnackBar(content: Text(message)),
              //   );
              //   Navigator.pop(context); // Close the confirmation dialog
              // }, (errorMessage) {
              //   scaffoldMessenger.showSnackBar(
              //     SnackBar(content: Text(errorMessage)),
              //   );
              // });
            },
            onCancel: () {
              Navigator.pop(context);
            },
            message: 'Are you sure you want to add this product?',
          );
        },
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Edit'),
        backgroundColor: Palette.redLightColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer(builder: (context, ref, child) {
                  final imageFile = ref.watch(imageProvider);
                  return InkWell(
                    onTap: () async {
                      _showImagePickerDialog();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Palette.containerBorderColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: imageFile != null
                          ? Image.file(imageFile, fit: BoxFit.cover)
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/uploadIcon.svg"),
                            const SizedBox(height: 8),
                            const Text("Upload Image"),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20),
                CustomTextInput(
                  controller:_nameController ,
                  label: 'product Name',
                  prefixIcon:Icons.production_quantity_limits,
                  width: 0.5, height: 0.1,
                ),
                SizedBox(width: 4,),
                CustomTextInput(
                  controller:_descriptionController ,
                  label: 'Description',
                  prefixIcon:Icons.description,
                  width: 0.7, height: 0.1,
                ),
                SizedBox(height: 10,),

                CustomTextInput(
                  controller:_categoryController ,
                  label: 'Category',
                  prefixIcon:Icons.category,
                  width: 0.4, height: 0.1,
                ),

                SizedBox(height: 10,),
                Row(
                  children: [
                    CustomTextInput(
                      keyboardType:
                      const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                      ],
                      controller:_mrpController ,
                      label: 'Mrp',
                      prefixIcon:Icons.monitor_weight,
                      width: 0.4, height: 0.1,
                    ),
                    SizedBox(width: 5,),
                    CustomTextInput(
                      keyboardType:
                      const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                      ],
                      controller:_taxController ,
                      label: 'Tax',
                      prefixIcon:Icons.monitor_weight,
                      width: 0.4, height: 0.1,
                    )
                  ],
                ),


                SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: _addProduct,
                //   child: Text('Add Product'),
                // ),
                Consumer(
                    builder: (context,ref,child) {
                      return SizedBox(
                        width: w*0.7,
                        height: h*0.05,
                        child: RoundedLoadingButton(icon: false,
                          backgroundColor:Palette.redLightColor,
                          TextColor: Colors.white,
                          text: 'Edit Product',
                          isLoading: false, onPressed: (){
                            confirmAlert();
                          },),
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
