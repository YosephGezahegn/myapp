import 'package:json_annotation/json_annotation.dart';

part 'word_category.g.dart';

@JsonSerializable()
class WordCategory {
  final String category;
  final List<String> words;

  WordCategory({
    required this.category,
    required this.words,
  });

  factory WordCategory.fromJson(Map<String, dynamic> json) =>
      _$WordCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$WordCategoryToJson(this);
}