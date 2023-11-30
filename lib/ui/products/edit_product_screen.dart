//
import 'package:flutter/material.dart';
import 'package:snackstore/models/product.dart';
import 'package:provider/provider.dart';
import 'package:snackstore/models/product_category.dart';
import 'package:snackstore/services/categories_service.dart';
import 'package:snackstore/ui/categories/categories_manager.dart';

//import '../shared/dialog_utils.dart';

import 'products_manager.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  EditProductScreen(
    Product? product, {
    super.key,
  }) {
    if (product == null) {
      this.product = Product(
        id: null,
        title: '',
        price: 0,
        description: '',
        imageUrl: '',
        category: '',
      );
    } else {
      this.product = product;
    }
  }

  late final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _editForm = GlobalKey<FormState>();
  late Product _editedProduct;
  var _isLoading = false;
  List<ProductCategory> _categories = [];
  late CategoriesManager categoriesManager;

  bool _isValidImageUrl(String value) {
    return (value.startsWith('http') || value.startsWith('https'));
    // (value.endsWith('.png') ||
    // value.endsWith('.jpg') ||
    // value.endsWith('.jpeg'));
  }

  @override
  void initState() {
    super.initState();

    // Lắng nghe sự thay đổi của _imageUrlFocusNode để cập nhật trạng thái
    _imageUrlFocusNode.addListener(() {
      if (!_imageUrlFocusNode.hasFocus) {
        if (!_isValidImageUrl(_imageUrlController.text)) {
          return;
        }
        setState(() {});
      }
    });

    // Khởi tạo _editedProduct từ widget.product
    _editedProduct = widget.product;

    // Thiết lập giá trị của _imageUrlController từ _editedProduct.imageUrl
    _imageUrlController.text = _editedProduct.imageUrl;

    categoriesManager = Provider.of<CategoriesManager>(context, listen: false);
    fetchCategoriesFromService();
  }

  Future<void> fetchCategoriesFromService() async {
    try {
      await categoriesManager.fetchCategories(false);
      setState(() {
        _categories = categoriesManager.items;
      });
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _editForm,
                child: ListView(
                  children: <Widget>[
                    buildTitleField(),
                    const SizedBox(
                      height: 10,
                    ),
                    buildPriceField(),
                    const SizedBox(
                      height: 10,
                    ),
                    buildDescriptionField(),
                    const SizedBox(
                      height: 10,
                    ),
                    buildProductPreview(),
                    const SizedBox(
                      height: 15,
                    ),
                    buildCategoryDropdown(),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedProduct.title,
      decoration: const InputDecoration(labelText: 'Title'),
      textInputAction: TextInputAction.next,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(title: value);
      },
    );
  }

  TextFormField buildPriceField() {
    return TextFormField(
      initialValue: _editedProduct.price.toString(),
      decoration: const InputDecoration(labelText: 'Price'),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a price.';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number.';
        }
        if (double.parse(value) <= 0) {
          return 'Please enter a number greater than zero.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(price: double.parse(value!));
      },
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      initialValue: _editedProduct.description,
      decoration: const InputDecoration(labelText: 'Description'),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description.';
        }
        if (value.length < 10) {
          return 'Should be at least 10 characters long.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(description: value);
      },
    );
  }

  Widget buildProductPreview() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(
            top: 8,
            right: 10,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _imageUrlController.text.isEmpty
              ? const Text('Enter a URL')
              : FittedBox(
                  child: Image.network(
                    _imageUrlController.text,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        Expanded(
          child: buildImageURLField(),
        ),
      ],
    );
  }

  TextFormField buildImageURLField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Image URL'),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
      controller: _imageUrlController,
      focusNode: _imageUrlFocusNode,
      onFieldSubmitted: (value) => _saveForm(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an image URL.';
        }
        if (!_isValidImageUrl(value)) {
          return 'Please enter a valid image URL.';
        }
        return null;
      },
      onSaved: (value) {
        _editedProduct = _editedProduct.copyWith(imageUrl: value);
      },
    );
  }

  Future<void> _saveForm() async {
    // Kiểm tra tính hợp lệ trước khi lưu
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }

    // Lưu các giá trị đã nhập trong form
    _editForm.currentState!.save();

    // Hiển thị loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy ra instance của ProductsManager từ Provider
      final productsManager = context.read<ProductsManager>();

      // Cập nhật giá trị category trong _editedProduct dựa trên giá trị đã chọn từ dropdown
      _editedProduct =
          _editedProduct.copyWith(category: _editedProduct.category);

      // Nếu sản phẩm có id (đã tồn tại), cập nhật sản phẩm
      if (_editedProduct.id != null) {
        // Gọi phương thức updateProduct với _editedProduct đã được cập nhật category
        await productsManager.updateProduct(_editedProduct);
        await fetchCategoriesFromService();
      } else {
        // Ngược lại, thêm sản phẩm mới
        // Gọi phương thức addProduct với _editedProduct đã được cập nhật category
        await productsManager.addProduct(_editedProduct);
        await fetchCategoriesFromService();
      }
    } catch (error) {
      // Hiển thị thông báo lỗi nếu có lỗi xảy ra
      if (mounted) {
        await showErrorDialog(context, 'Something went wrong.');
      }
    }

    // Tắt loading indicator sau khi lưu hoặc xử lý xong lỗi
    setState(() {
      _isLoading = false;
    });

    // Đóng màn hình chỉnh sửa sản phẩm
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  DropdownButtonFormField<String> buildCategoryDropdown() {
    // if (_categories.isEmpty) {
    //   // Nếu danh sách categories chưa được fetch, hiển thị tiện ích tạm thời
    //   return DropdownButtonFormField<String>(
    //     value: null,
    //     decoration: InputDecoration(
    //       labelText: 'Category',
    //       border: OutlineInputBorder(
    //         borderRadius: BorderRadius.circular(10.0),
    //       ),
    //       contentPadding: const EdgeInsets.symmetric(
    //         horizontal: 16.0,
    //         vertical: 16.0,
    //       ),
    //     ),
    //     items: const [
    //       DropdownMenuItem<String>(
    //         value: null,
    //         child: Text('Loading categories...'),
    //       ),
    //     ],
    //     onChanged: (value) {
    //       // Do nothing as categories are still loading
    //     },
    //   );
    // } else {
    // Nếu danh sách categories đã được fetch, hiển thị DropdownButtonFormField
    return DropdownButtonFormField<String>(
      value: _editedProduct.category,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
      ),
      items: [
        ..._categories.map((category) {
          return DropdownMenuItem<String>(
            value: category.name,
            child: Text(category.name),
          );
        }).toList(),
        if (!_categories
            .any((category) => category.name == _editedProduct.category))
          DropdownMenuItem<String>(
            value: _editedProduct.category,
            child: Text(_editedProduct.category),
          ),
      ],
      onChanged: (value) {
        setState(() {
          _editedProduct = _editedProduct.copyWith(category: value!);
        });
      },
    );
  }

  Future<void> showErrorDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Ocurred!'),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                )
              ],
            ));
  }
}
