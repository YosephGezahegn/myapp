// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordCategory _$WordCategoryFromJson(Map<String, dynamic> json) => WordCategory(
  category: json['category'] as String,
  words: (json['words'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$WordCategoryToJson(WordCategory instance) =>
    <String, dynamic>{'category': instance.category, 'words': instance.words};
