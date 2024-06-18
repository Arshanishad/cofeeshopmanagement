
import 'package:coffee_shop_management/features/Home/screens/navigation_screen.dart';
import 'package:coffee_shop_management/features/product/repository/product_repository.dart';
import 'package:coffee_shop_management/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/storage_repository.dart';



final productControllerProvider = StateNotifierProvider<ProductController, bool>(
        (ref) => ProductController(
        productRepository: ref.read(productRepositoryProvider), ref: ref, storageRepository:ref.read(storageRepositoryProvider)));
final productDisplayStreamProvider=StreamProvider.family((ref,String search) =>ref.read(productControllerProvider.notifier).productDisplay(search));

class ProductController extends StateNotifier<bool> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  ProductController( {
    required ProductRepository productRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })
      : _productRepository = productRepository,
        _storageRepository=storageRepository,
        _ref = ref,
        super(false);
        addProduct({required String name, required BuildContext context,required String categoryId,required String description,
          required String image,
         required double tax,required double mrp,
         })
        async {
          state =true;
          final category=await _productRepository.addProduct(name: name,category: categoryId,description: description,
              tax: tax,mrp: mrp,
            image:image,
          );
          state=false;
          category.fold((l) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add Product')),
          ), (r) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product added successfully!')),
            );
            Navigator.push(context, MaterialPageRoute(builder:(context)=>NavigationScreen()));
          }
          );
          Navigator.pop(context);
        }
  editProduct({ required BuildContext context,required String categoryId,required String description, required double tax,
    required String name,required double mrp,required ProductModel productModel})
  async {
    state =true;
    final category=await _productRepository.editProduct(categoryId: categoryId,description: description,
       tax: tax,productModel: productModel,
        mrp: mrp,name: name,);
    state=false;
    category.fold((l) =>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Product')),
        ),
            (r) =>    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product added successfully!')),
            ));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen()));
  }



  Stream<List<ProductModel>> productDisplay(String search) {
    return _productRepository.productDisplay(search);
  }

  void deleteProduct(String id) {
    _productRepository.deleteProduct(id);
  }
}



