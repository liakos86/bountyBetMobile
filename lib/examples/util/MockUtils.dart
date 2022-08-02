import 'package:flutter_app/examples/models/category.dart';
import 'package:flutter_app/examples/util/AppColors.dart';
import 'package:flutter_app/examples/util/IconFontHelper.dart';

class MockUtils{
  
  static List<Category> mockCategories(){
    return [

      Category(color: AppColors.MEATS, icon: IconFontHelper.MEATS, name: "Carnes", imgName: "cat1", subCategories: []),
      Category(color: AppColors.FRUITS, icon: IconFontHelper.FRUITS, name: "Fruits", imgName: "cat2", subCategories: []),
      Category(color: AppColors.VEGS, icon: IconFontHelper.VEGS, name: "Vegs", imgName: "cat3", subCategories: []),
      Category(color: AppColors.SEEDS, icon: IconFontHelper.SEEDS, name: "Seeds", imgName: "cat4", subCategories: []),
      Category(color: AppColors.PASTRIES, icon: IconFontHelper.PASTRIES, name: "Pastries", imgName: "cat5", subCategories: []),

    ];
  }
  
}