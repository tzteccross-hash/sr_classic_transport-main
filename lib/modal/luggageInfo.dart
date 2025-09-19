class luggageInfo{
  int id;
  String code;
  int question;
  String store;
  String s_name;
  String s_no;
  String r_name;
  String r_no;
  String account;
  String payed;
  String to_be;
  String amount;
  String status;
  String date_insert;
  String symbol;
  luggageInfo(
      this.id,
      this.code,
      this.question,
      this.store,
      this.s_name,
      this.s_no,
      this.r_name,
      this.r_no,
      this.account,
      this.payed,
      this.to_be,
      this.amount,
      this.status,
      this.date_insert,
      this.symbol,
      );

  factory luggageInfo.fromJson(Map<String, dynamic> json) => luggageInfo(
    int.parse(json["id"]),
    json["code"],
    int.parse(json["question"]),
    json["store"],
    json["s_name"],
    json["s_no"],
    json["r_name"],
    json["r_no"],
    json["account"],
    json["payed"],
    json["to_be"],
    json["amount"],
    json["status"],
    json["date_insert"],
    json["symbol"],


  );

  Map<String, dynamic> toJson()=>{

    'id': id.toString(),
    'code': code.toString(),
    'question': question.toString(),
    'store': store.toString(),
    's_name': s_name.toString(),
    's_no': s_no.toString(),
    'r_name': r_name.toString(),
    'r_no': r_no.toString(),
    'account': account.toString(),
    'payed': payed.toString(),
    'to_be': to_be.toString(),
    'amount': amount.toString(),
    'status': status.toString(),
    'date_insert': date_insert.toString(),
    'symbol': symbol.toString(),
  };
}
