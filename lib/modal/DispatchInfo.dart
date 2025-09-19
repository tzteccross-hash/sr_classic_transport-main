class DispatchInfo
{

  String? date;
  String? arraival;
  String? status;
  String? q_left;
  String? amount;
  String? short_response;


  DispatchInfo({
    this.date,
    this.arraival,
    this.status,
    this.q_left,
    this.amount,
    this.short_response,

  });

  factory DispatchInfo.fromJson(Map<String, dynamic> json) => DispatchInfo(
    date: json["date"],
    arraival: json["arraival"],
    status: json["status"],
    q_left: json["q_left"],
    amount: json["amount"],
    short_response: json["short_response"],



  );


}
