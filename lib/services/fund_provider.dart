import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mutua_funds/main.dart';
import '../models/fund.dart';

enum SortOption { navAsc, navDesc, returnsAsc, returnsDesc, aumAsc, aumDesc }

class FundProvider extends ChangeNotifier {
  List<MutualFund> _funds = [];
  List<MutualFund> get funds => _filteredFunds;
  List<MutualFund> _filteredFunds = [];

  bool isLoading = false;
  String? error;

  // Watchlist: list of fund names (could use IDs if available)
  List<String> _watchlist = [];
  List<String> get watchlist => _watchlist;

  SortOption? _currentSortOption;

  FundProvider() {
    _init();
  }

  Future<void> _init() async {
    isLoading = true;
    notifyListeners();

    try {
      // For demo: load from local JSON string or assets
      String data = await DefaultAssetBundle.of(navigatorKey.currentContext!)
          .loadString('assets/data/funds.json');

      final List<dynamic> jsonList = json.decode(data);

      _funds = jsonList
          .map((e) => MutualFund.fromJson(e as Map<String, dynamic>))
          .toList();

      _filteredFunds = List.from(_funds);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void addToWatchlist(String fundName) {
    if (!_watchlist.contains(fundName)) {
      _watchlist.add(fundName);
      notifyListeners();
    }
  }

  void removeFromWatchlist(String fundName) {
    _watchlist.remove(fundName);
    notifyListeners();
  }

  List<MutualFund> get watchlistFunds =>
      _funds.where((fund) => _watchlist.contains(fund.name)).toList();

  // Filtering and sorting for watchlist/funds
  void sortFunds(SortOption option) {
    _currentSortOption = option;

    switch (option) {
      case SortOption.navAsc:
        _filteredFunds.sort((a, b) => a.nav.compareTo(b.nav));
        break;
      case SortOption.navDesc:
        _filteredFunds.sort((a, b) => b.nav.compareTo(a.nav));
        break;
      case SortOption.returnsAsc:
        _filteredFunds.sort((a, b) => a.return1Y.compareTo(b.return1Y));
        break;
      case SortOption.returnsDesc:
        _filteredFunds.sort((a, b) => b.return1Y.compareTo(a.return1Y));
        break;
      case SortOption.aumAsc:
        _filteredFunds.sort((a, b) => a.aum.compareTo(b.aum));
        break;
      case SortOption.aumDesc:
        _filteredFunds.sort((a, b) => b.aum.compareTo(a.aum));
        break;
    }

    notifyListeners();
  }

  void filterFunds(String query) {
    if (query.isEmpty) {
      _filteredFunds = List.from(_funds);
    } else {
      _filteredFunds = _funds
          .where((f) => f.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    if (_currentSortOption != null) {
      sortFunds(_currentSortOption!);
    } else {
      notifyListeners();
    }
  }
}
