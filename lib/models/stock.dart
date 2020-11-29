//Do NOT touch this file as it is complete.
class Stock {
  Stock({this.symbol, this.name, this.price});

  final int symbol;
  final String name;
  final int price;

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'name': name,
      'price': price,
    };
  }
}
