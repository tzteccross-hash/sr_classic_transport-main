class contactInfo
{

  String? status;
  String? location;
  String? country;
  String? map;
  String? phone_no;
  String? phone_no2;
  String? description;


  contactInfo({
    this.status,
    this.location,
    this.country,
    this.map,
    this.phone_no,
    this.phone_no2,
    this.description,

  });

  factory contactInfo.fromJson(Map<String, dynamic> json) => contactInfo(
    status: json["status"],
    location: json["location"],
    country: json["country"],
    map: json["map"],
    phone_no: json["phone_no"],
    phone_no2: json["phone_no2"],
    description: json["description"],



  );


}
