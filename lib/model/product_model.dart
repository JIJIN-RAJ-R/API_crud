// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
    String id;
    String? name;
    int? age;
    String? colour;
    String? title;
    int? price;
    String? description;
    String? category;
    String? image;

    Welcome({
        required this.id,
        this.name,
        this.age,
        this.colour,
        this.title,
        this.price,
        this.description,
        this.category,
        this.image,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        id: json["_id"],
        name: json["name"],
        age: json["age"],
        colour: json["colour"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        category: json["category"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "age": age,
        "colour": colour,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
    };
}
