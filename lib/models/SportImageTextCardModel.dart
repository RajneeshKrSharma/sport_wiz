import 'dart:convert';

// Define the data model class
class SportInfo {
  final int sportItemId;
  final String sportImage;
  final String sportName;
  final String sportCategory;

  SportInfo({
    required this.sportItemId,
    required this.sportImage,
    required this.sportName,
    required this.sportCategory,
  });

  // Convert a JSON map to a Sport object
  factory SportInfo.fromJson(Map<String, dynamic> json) {
    return SportInfo(
      sportItemId: json['sportItemId'] as int,
      sportImage: json['sportImage'] as String,
      sportName: json['sportName'] as String,
      sportCategory: json['sport category'] as String,
    );
  }

  // Convert a Sport object to JSON
  Map<String, dynamic> toJson() {
    return {
      'sportItemId': sportItemId,
      'sportImage': sportImage,
      'sportName': sportName,
      'sport category': sportCategory,
    };
  }
}
