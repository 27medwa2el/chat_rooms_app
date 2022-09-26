class Room{
  static const String COLLECTION_NAME="room";
  String id;
  String name;
  String description;
  String category;
  Room(
      {
        required this.id,
        required this.category,
        required this.name,
        required this.description
      }
      );
  Room.fromJson(Map<String,Object?>json):this(
      id: json['id']! as String,
      name: json['userName']! as String,
      description: json['description']! as String,
      category: json['category']! as String
  );
  Map<String,Object> toJson(){
    return {
      'id': id,
      'userName': name,
      'description': description,
      'category' : category
    };
  }
}