class PostModel {
  String? name;
  String? uId;
  String? image;
  String? postImage;
  String? date;
  String? text;

  PostModel({
    this.name,
    this.text,
    this.uId,
    this.date,
    this.image,
    this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    date = json['date'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'postImage': postImage,
      'text': text,
      'image': image,
      'date': date,
    };
  }
}
