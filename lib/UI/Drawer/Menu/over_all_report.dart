// Import packages
import 'package:atts/Reusable/button.dart';
import 'package:atts/Reusable/color.dart';
import 'package:atts/Reusable/customTextfield.dart';
import 'package:atts/Reusable/text_styles.dart';
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

  Future<void> _fetchData(
      {bool isNext = false, bool isPrevious = false}) async {
    setState(() => _isLoading = true);

    Query query = FirebaseFirestore.instance.collection('billing');

    if (_searchController.text.isNotEmpty) {
      String search = _searchController.text.trim().toLowerCase();
      query = query.orderBy('timestamp', descending: !_ascending);
      final snapshot = await query.get();

      final filtered = snapshot.docs.where((doc) {
        final productName = (doc.data() as Map<String, dynamic>)['productName']
                ?.toString()
                .toLowerCase() ??
            '';
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
      backgroundColor: appFirstColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              "Filter by Category",
              style: MyTextStyle.f16(appBottomColor),
            ),
            ...["Gold", "Silver", "Diamond", "Platinum"]
                .map((cat) => CheckboxListTile(
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
            Text("Sort by", style: MyTextStyle.f16(appBottomColor)),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: appBottomColor, width: 1), // border color and width
                borderRadius: BorderRadius.circular(10), // border radius
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _sortBy,
                  items: ["timestamp", "totalAmount"]
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) => setState(() => _sortBy = val!),
                ),
              ),
            ),
            SizedBox(height: 10,),
            SwitchListTile(
              title: Text("Ascending"),
              value: _ascending,
              onChanged: (val) => setState(() => _ascending = val),
            ),
            SizedBox(height: 10),
            Text(
                "Amount Range: ${_amountRange.start.round()} - ${_amountRange.end.round()}"),
            RangeSlider(
              values: _amountRange,
              min: 0,
              activeColor: appBottomColor,
              inactiveColor: appButton2Color,
              max: 100000,
              onChanged: (range) => setState(() => _amountRange = range),
            ),
            SizedBox(
              height: 30,
            ),
            appButton(
                onTap: _applyFilters,
                height: 50,
                width: double.infinity,
                color: whiteColor,
                buttonText: "Apply Filter"),
          ],
        ),
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
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['productName'] ?? '',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${data['username'] ?? 'N/A'}"),
                  Text("Quantity: ${data['quantity'] ?? '0'}"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${data['phone'] ?? 'N/A'}"),
                  Text("Discount: ${data['discount'] ?? '0'}%"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${data['category'] ?? 'N/A'}"),
                  Text(
                      "Rs. ${(double.tryParse(data['totalAmount']?.toString() ?? '0') ?? 0).toStringAsFixed(2)}"),
                ],
              ),
            ],
          ),
        );
        // return ListTile(
        //   title: Text(data['productName'] ?? ''),
        //   subtitle: Text(
        //       "Amount: ${data['totalAmount']}, Category: ${data['category']}"),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appFirstColor,
      appBar: AppBar(
        backgroundColor: appFirstColor,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    alignment: Alignment.topCenter,
                    "assets/arrow.png",
                    width: size.width * 0.1,
                    height: size.height * 0.05,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Billing Report',
              style: MyTextStyle.f24(appBottomColor, weight: FontWeight.bold),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.filter_list,
                color: appBottomColor,
                size: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          )
        ],
      ),
      endDrawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: customInputDecoration("Search Product Name"),
              onSubmitted: (_) => _fetchData(),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(child: _buildBillingList()),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1
                      ? () => _fetchData(isPrevious: true)
                      : null,
                  child: Text("Previous"),
                ),
                Text("Page $_currentPage"),
                ElevatedButton(
                  onPressed: _billingData.length == 10
                      ? () => _fetchData(isNext: true)
                      : null,
                  child: Text("Next"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
