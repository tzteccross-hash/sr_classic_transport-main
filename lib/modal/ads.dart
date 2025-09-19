class ads
{

  String? image;
  String? title;
  String? description;
  String? status;


  ads({
    this.image,
    this.title,
    this.description,
    this.status,

  });

  factory ads.fromJson(Map<String, dynamic> json) => ads(

    image: json["image"],
    title: json["title"],
    description: json["description"],
    status: json["status"],

  );
}