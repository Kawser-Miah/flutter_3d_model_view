import '../generated/assets.dart';

class CategoryModel {
  final int id;
  final String title;
  final String assets;

  CategoryModel({required this.id, required this.title, required this.assets});
}

class Utils{
  static List<CategoryModel> category =[
    CategoryModel(id: 0, title: "Human", assets: Assets.threeDHuman),
    CategoryModel(id: 1, title: "Helmet", assets: Assets.threeDDamagedHelmet),
    CategoryModel(id: 2, title: "SubSan", assets: Assets.threeDSub),
    CategoryModel(id: 3, title: "Man", assets: Assets.threeDUn)
  ];
}