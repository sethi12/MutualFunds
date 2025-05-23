import 'package:flutter/material.dart';
import 'package:mutua_funds/screens/fund_detail.dart';
import 'package:mutua_funds/screens/loginscreen.dart';
import 'package:mutua_funds/services/supabase_service.dart';
import 'package:provider/provider.dart';

import '../services/fund_provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final authservice = AuthService();
  SortOption? _selectedSort;

  void _logout() async {
    await authservice.signout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Loginscreen()));
  }

  @override
  Widget build(BuildContext context) {
    final fundProvider = Provider.of<FundProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mutual Funds Dashboard'),
        actions: [
          PopupMenuButton<SortOption>(
            icon: Icon(Icons.sort),
            onSelected: (option) {
              setState(() {
                _selectedSort = option;
              });
              fundProvider.sortFunds(option);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: SortOption.navAsc, child: Text('Sort by NAV ↑')),
              PopupMenuItem(
                  value: SortOption.navDesc, child: Text('Sort by NAV ↓')),
              PopupMenuItem(
                  value: SortOption.returnsAsc,
                  child: Text('Sort by Returns ↑')),
              PopupMenuItem(
                  value: SortOption.returnsDesc,
                  child: Text('Sort by Returns ↓')),
              PopupMenuItem(
                  value: SortOption.aumAsc, child: Text('Sort by AUM ↑')),
              PopupMenuItem(
                  value: SortOption.aumDesc, child: Text('Sort by AUM ↓')),
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Add your logout logic here
              // For example, call AuthProvider.logout or navigate to login screen
              _logout();
            },
          ),
        ],
      ),
      body: fundProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : fundProvider.error != null
              ? Center(child: Text('Error: ${fundProvider.error}'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search funds...',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          fundProvider.filterFunds(value);
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: fundProvider.funds.length,
                        itemBuilder: (context, index) {
                          final fund = fundProvider.funds[index];
                          final isInWatchlist =
                              fundProvider.watchlist.contains(fund.name);

                          return ListTile(
                            title: Text(fund.name),
                            subtitle: Text(
                                'NAV: ${fund.nav.toStringAsFixed(2)}, Returns: ${fund.return1Y.toStringAsFixed(2)}%'),
                            trailing: IconButton(
                              icon: Icon(
                                isInWatchlist
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isInWatchlist ? Colors.red : null,
                              ),
                              onPressed: () {
                                if (isInWatchlist) {
                                  fundProvider.removeFromWatchlist(fund.name);
                                } else {
                                  fundProvider.addToWatchlist(fund.name);
                                }
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        FundDetailScreen(fund: fund)),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Watchlist',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Expanded(
                      child: fundProvider.watchlistFunds.isEmpty
                          ? Center(child: Text('No funds in watchlist'))
                          : ListView.builder(
                              itemCount: fundProvider.watchlistFunds.length,
                              itemBuilder: (context, index) {
                                final fund = fundProvider.watchlistFunds[index];
                                return Dismissible(
                                  key: Key(fund.name),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  ),
                                  onDismissed: (direction) {
                                    fundProvider.removeFromWatchlist(fund.name);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${fund.name} removed from watchlist')),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(fund.name),
                                    subtitle: Text(
                                        'NAV: ${fund.nav.toStringAsFixed(2)}, Returns: ${fund.return1Y.toStringAsFixed(2)}%'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        fundProvider
                                            .removeFromWatchlist(fund.name);
                                      },
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                FundDetailScreen(fund: fund)),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                ),
    );
  }
}
