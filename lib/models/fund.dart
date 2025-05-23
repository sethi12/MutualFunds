// lib/models/fund.dart
class MutualFund {
  final String name;
  final double nav;
  final double return1Y;
  final double aum;
  final List<double> navHistory;
  final Map<String, double> monthlyReturns;

  MutualFund({
    required this.name,
    required this.nav,
    required this.return1Y,
    required this.aum,
    required this.navHistory,
    required this.monthlyReturns,
  });

  factory MutualFund.fromJson(Map<String, dynamic> json) {
    return MutualFund(
      name: json['name'],
      nav: (json['nav'] as num).toDouble(),
      return1Y: (json['return1Y'] as num).toDouble(),
      aum: (json['aum'] as num).toDouble(),
      navHistory: (json['navHistory'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      monthlyReturns: Map<String, double>.from(
        (json['monthlyReturns'] as Map)
            .map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "nav": nav,
        "return1Y": return1Y,
        "aum": aum,
        "navHistory": navHistory,
        "monthlyReturns": monthlyReturns,
      };
}

class Watchlist {
  String name;
  List<MutualFund> funds;

  Watchlist({required this.name, required this.funds});

  Map<String, dynamic> toJson() => {
        'name': name,
        'funds': funds.map((f) => f.toJson()).toList(),
      };

  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      name: json['name'],
      funds: (json['funds'] as List)
          .map((f) => MutualFund.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }
}
