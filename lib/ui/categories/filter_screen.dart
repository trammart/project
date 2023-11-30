import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snackstore/models/product_category.dart';
import 'package:snackstore/ui/categories/categories_manager.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<String> selectedCategories = [];
  List<ProductCategory> _categories = [];
  late CategoriesManager categoriesManager;

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
        title: const Text(
          "Filters",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getLabel("Categories"),
            const SizedBox(height: 15),
            ..._categories.map((category) {
              return Column(
                children: [
                  OptionItem(
                    text: category.name,
                    isChecked: selectedCategories.contains(category.name),
                    onChecked: (isChecked) {
                      updateCategorySelection(category.name, isChecked);
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }).toList(),
            OptionItem(
              text: "All",
              isChecked: selectedCategories.isEmpty,
              onChecked: (isChecked) {
                updateCategorySelection("", isChecked);
              },
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, selectedCategories);
                },
                child: const Text(
                  "Apply Filter",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget getLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void updateCategorySelection(String category, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedCategories.add(category);
      } else {
        selectedCategories.remove(category);
      }
    });
  }
}

class OptionItem extends StatefulWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool>? onChecked;

  const OptionItem({
    Key? key,
    required this.text,
    this.isChecked = false,
    this.onChecked,
  }) : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChecked?.call(!widget.isChecked);
      },
      child: Container(
        child: Row(
          children: [
            getCheckBox(),
            const SizedBox(
              width: 12,
            ),
            getTextWidget(),
          ],
        ),
      ),
    );
  }

  Widget getTextWidget() {
    return Text(
      widget.text,
      style: TextStyle(
        color: widget.isChecked ? Colors.black : Colors.grey,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget getCheckBox() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: SizedBox(
        width: 25,
        height: 25,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: widget.isChecked ? 0 : 1.5,
              color: const Color(0xffB1B1B1),
            ),
            borderRadius: BorderRadius.circular(8),
            color: widget.isChecked ? Colors.blue : Colors.transparent,
          ),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Checkbox(
              value: widget.isChecked,
              onChanged: (state) {
                widget.onChecked?.call(!widget.isChecked);
              },
              activeColor: Colors.transparent,
              checkColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          ),
        ),
      ),
    );
  }
}
