class Menu{
  int idx;
  String storeId;
  String menuName;
  int menuPrice;


  Menu(this.idx, this.storeId, this.menuName,  this.menuPrice);

  factory Menu.fromJson(Map<String,dynamic> json) => Menu(
    int.parse(json['idx']),
    json['storeId'] as String,
    json['menuName'] as String,
    int.parse(json['menuPrice']),
  );

  Map<String, dynamic> toJson() =>{
    'idx' : idx.toString(),
    'storeId' : storeId,
    'menuName' : menuName,
    'menuPrice' : menuPrice.toString()
  };
}