import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class shoppingPage extends StatefulWidget {
  @override
  _shoppingPage createState() => _shoppingPage();
}

class _shoppingPage extends State<shoppingPage> {
  Map<String, dynamic> finalResult = {};
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchFinalResult();
  }

  Future<void> fetchFinalResult() async {
    final url = Uri.parse(
        "http://iphone.us2guntur.com/SubcatResponseNewV15?catid=10008");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final result = jsonData["finalresult"];

      setState(() {
        finalResult = result;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Birthday Gifts'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : finalResult.isNotEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                finalResult["related_subcatslist"].length,
                                (index) {
                                  final subcategory =
                                      finalResult["related_subcatslist"][index];
                                  final price = subcategory["price"];

                                  if (price != null) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        child: Column(
                                          children: <Widget>[
                                            Image.network(
                                              subcategory["image_path"],
                                              width: 100,
                                              height: 100,
                                            ),
                                            Text(subcategory["subcatname"]),
                                            Text('Price: \$${price}'),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                                // ignore: unnecessary_null_comparison
                              ).where((widget) => widget != null).toList(),
                            )
                          ],
                        ),
                      )
                    : const Center(
                        child: Text('No data available'),
                      ),
          ),
        ],
      ),
    );
  }
}
