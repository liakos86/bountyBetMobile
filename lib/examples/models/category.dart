import 'dart:ui';

class Category{
  String name;
  String icon;
  String imgName;
  Color color;
  List<Category> subCategories;

  Category({
    required this.color,
    required this.icon,
    required this.name,
    required this.imgName,
    required this.subCategories
  });

}