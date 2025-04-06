// Import packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OverAllReport extends StatefulWidget {
  @override
  _OverAllReportState createState() => _OverAllReportState();
}

class _OverAllReportState extends State<OverAllReport> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _selectedCategories = [];
  DateTimeRange? _dateRange;
  RangeValues _amountRange = RangeValues(0, 100000);
  String _sortBy = 'timestamp';
  bool _ascending = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentPage = 1;
  DocumentSnapshot? _lastDoc;
  List<DocumentSnapshot> _pages = [];

  List<DocumentSnapshot> _billingData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  Future<void> _fetchData({bool isNext = false, bool isPrevious = false}) async {
    setState(() => _isLoading = true);

    Query query = FirebaseFirestore.instance.collection('billing');

    if (_searchController.text.isNotEmpty) {
      String search = _searchController.text.trim().toLowerCase();
      query = query.orderBy('timestamp', descending: !_ascending);
      final snapshot = await query.get();

      final filtered = snapshot.docs.where((doc) {
        final productName = (doc.data() as Map<String, dynamic>)['productName']?.toString().toLowerCase() ?? '';
        return productName.contains(search);
      }).toList();

      setState(() {
        _billingData = filtered;
        _isLoading = false;
      });
      return;
    }

    if (_selectedCategories.isNotEmpty) {
      query = query.where('category', whereIn: _selectedCategories);
    }

    if (_dateRange != null) {
      query = query
          .where('timestamp', isGreaterThanOrEqualTo: _dateRange!.start)
          .where('timestamp', isLessThanOrEqualTo: _dateRange!.end);
    }

    // Always order by a unique field like timestamp + id (to ensure consistent pagination)
    query = query
        .orderBy(_sortBy, descending: !_ascending)
        .orderBy(FieldPath.documentId)
        .limit(10);

    // For pagination, ensure startAfter is used with the same fields you ordered by
    if (isNext && _lastDoc != null) {
      final data = _lastDoc!.data() as Map<String, dynamic>;
      query = query.startAfter([data[_sortBy], _lastDoc!.id]);
    } else if (isPrevious && _currentPage > 1) {
      _pages.removeLast();
      _lastDoc = _pages.isNotEmpty ? _pages.last : null;
      _currentPage--;
      await _fetchData();
      return;
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDoc = snapshot.docs.last;
      if (!isPrevious) _pages.add(_lastDoc!);
    }

    setState(() {
      _billingData = snapshot.docs;
      if (isNext) _currentPage++;
      _isLoading = false;
    });
  }

  // Future<void> _fetchData({bool isNext = false, bool isPrevious = false}) async {
  //   setState(() => _isLoading = true);
  //
  //   Query query = FirebaseFirestore.instance.collection('billing');
  //
  //   if (_searchController.text.isNotEmpty) {
  //     String search = _searchController.text.trim();
  //     query = query
  //         .where('productName', isGreaterThanOrEqualTo: search)
  //         .where('productName', isLessThanOrEqualTo: search + '\uf8ff');
  //   }
  //
  //   if (_selectedCategories.isNotEmpty) {
  //     query = query.where('category', whereIn: _selectedCategories);
  //   }
  //
  //   if (_dateRange != null) {
  //     query = query
  //         .where('timestamp', isGreaterThanOrEqualTo: _dateRange!.start)
  //         .where('timestamp', isLessThanOrEqualTo: _dateRange!.end);
  //   }
  //
  //   query = query
  //       .where('totalAmount', isGreaterThanOrEqualTo: _amountRange.start)
  //       .where('totalAmount', isLessThanOrEqualTo: _amountRange.end)
  //       .orderBy(_sortBy, descending: !_ascending)
  //       .limit(10);
  //
  //   if (isNext && _lastDoc != null) {
  //     final data = _lastDoc!.data() as Map<String, dynamic>;
  //     if (data.containsKey(_sortBy)) {
  //       query = query.startAfter([data[_sortBy]]);
  //     }
  //   }
  //
  //   else if (isPrevious && _currentPage > 1) {
  //     _pages.removeLast();
  //     _lastDoc = _pages.isNotEmpty ? _pages.last : null;
  //     _currentPage--;
  //     await _fetchData();
  //     return;
  //   }
  //
  //   final snapshot = await query.get();
  //   if (snapshot.docs.isNotEmpty) {
  //     _lastDoc = snapshot.docs.last;
  //     if (!isPrevious) _pages.add(_lastDoc!);
  //   }
  //
  //   setState(() {
  //     _billingData = snapshot.docs;
  //     if (isNext) _currentPage++;
  //     _isLoading = false;
  //   });
  // }

  void _openFilterDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();

  }

  // void _applyFilters() {
  //   Navigator.pop(context);
  //   _lastDoc = null;
  //   _pages.clear();
  //   _currentPage = 1;
  //   _fetchData();
  // }
  void _applyFilters() {
    Navigator.pop(context);
    _lastDoc = null;
    _pages.clear();
    _currentPage = 1;
    _fetchData();
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text("Filter by Category"),
          ...["Gold", "Silver", "Diamond", "Platinum"].map((cat) => CheckboxListTile(
            title: Text(cat),
            value: _selectedCategories.contains(cat),
            onChanged: (val) {
              setState(() {
                if (val!) {
                  _selectedCategories.add(cat);
                } else {
                  _selectedCategories.remove(cat);
                }
              });
            },
          )),
          SizedBox(height: 20),
          Text("Sort by"),
          DropdownButton<String>(
            value: _sortBy,
            items: ["timestamp", "totalAmount"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (val) => setState(() => _sortBy = val!),
          ),
          SwitchListTile(
            title: Text("Ascending"),
            value: _ascending,
            onChanged: (val) => setState(() => _ascending = val),
          ),
          SizedBox(height: 10),
          Text("Amount Range: ${_amountRange.start.round()} - ${_amountRange.end.round()}"),
          RangeSlider(
            values: _amountRange,
            min: 0,
            max: 100000,
            onChanged: (range) => setState(() => _amountRange = range),
          ),
          ElevatedButton(onPressed: _applyFilters, child: Text("Apply Filters")),
        ],
      ),
    );
  }

  Widget _buildBillingList() {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    if (_billingData.isEmpty) return Center(child: Text("No records found"));
    return ListView.builder(
      itemCount: _billingData.length,
      itemBuilder: (ctx, i) {
        final data = _billingData[i].data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['productName'] ?? ''),
          subtitle: Text("Amount: ${data['totalAmount']}, Category: ${data['category']}"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(hintText: 'Search Product Name'),
          onSubmitted: (_) => _fetchData(),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          )
        ],

      ),
      endDrawer: _buildDrawer(),
      body: Column(
        children: [
          Expanded(child: _buildBillingList()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _currentPage > 1 ? () => _fetchData(isPrevious: true) : null,
                child: Text("Previous"),
              ),
              Text("Page $_currentPage"),
              ElevatedButton(
                onPressed: _billingData.length == 10 ? () => _fetchData(isNext: true) : null,
                child: Text("Next"),
              ),
            ],
          )
        ],
      ),
    );
  }
}