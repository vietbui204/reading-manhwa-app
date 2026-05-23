import 'package:flutter/material.dart';
import '../../domain/entities/explore_category.dart';

class ExploreCategoryModel extends ExploreCategory {
  ExploreCategoryModel({
    required super.id,
    required super.title,
    required super.icon,
    required super.color,
  });

  // Since icons and colors are usually defined on client-side for these grids,
  // we might map a string ID from JSON to specific IconData/Color
  factory ExploreCategoryModel.fromDefinition(String id, String title, IconData icon, Color color) {
    return ExploreCategoryModel(id: id, title: title, icon: icon, color: color);
  }
}
