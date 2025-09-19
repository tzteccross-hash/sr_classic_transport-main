class CargoList
{

  String? id;
  String? code;
  String? question;
  String? store;
  String? s_name;
  String? s_no;
  String? r_name;
  String? r_no;
  String? account;
  String? payed;
  String? to_be;
  String? amount;
  String? date_insert;
  String? status;
  String? symbol;



  CargoList({
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
    this.date_insert,
    this.status,
    this.symbol,

  });

  factory CargoList.fromJson(Map<String, dynamic> json) => CargoList(
    id: json["id"],
    code: json["code"],
    question: json["question"],
    store: json["store"],
    s_name: json["s_name"],
    s_no: json["s_no"],
    r_no: json["r_no"],
    r_name: json["r_name"],
    account: json["account"],
    payed: json["payed"],
    to_be: json["to_be"],
    amount: json["amount"],
    date_insert: json["date_insert"],
    status: json["status"],
    symbol: json["symbol"],



  );


}
