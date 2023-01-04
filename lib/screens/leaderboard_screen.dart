import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:localstore/localstore.dart';
import 'package:moto/widgets/appbar_widget.dart';
import 'package:moto/widgets/text_widget.dart';

class LeaderBoardScreen extends StatefulWidget {
  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  final box = GetStorage();

  final db = Localstore.instance;

  List<String> names = [];

  List<String> numbers = [];

  List<int> scores = [];

  var hasLoaded = false;

  getData() async {
    final items = await db.collection(box.read('categ')).get();

    if (items != null) {
      List<dynamic> values1 = items.values.toList();

      values1.sort((a, b) => a['score'].compareTo(b['score']));

      for (var element in values1.reversed) {
        names.add(element['name']);
        numbers.add(element['number']);
        scores.add(element['score']);
      }
    }

    setState(() {
      hasLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(
          box.read('categ') == 'ama'
              ? 'Leaderboard for Amature Category'
              : box.read('categ') == 'beg'
                  ? 'Leaderboard for Beginner Category'
                  : 'Leaderboard for Pro Category',
          context),
      body: hasLoaded
          ? Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  opacity: 0.25,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/back.jpg',
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DataTable(columns: [
                      DataColumn(
                        label: TextRegular(
                            text: 'Name', fontSize: 18, color: Colors.black),
                      ),
                      DataColumn(
                        label: TextRegular(
                            text: 'Number', fontSize: 18, color: Colors.black),
                      ),
                      DataColumn(
                        label: TextRegular(
                            text: 'Score', fontSize: 18, color: Colors.black),
                      ),
                      DataColumn(
                        label: TextRegular(
                            text: '', fontSize: 18, color: Colors.black),
                      ),
                    ], rows: [
                      for (int i = 0; i < names.length; i++)
                        DataRow(cells: [
                          DataCell(
                            TextRegular(
                                text: names[i],
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          DataCell(
                            TextRegular(
                                text: numbers[i],
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          DataCell(
                            TextRegular(
                                text: '${scores[i]}pts',
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          DataCell(
                            TextRegular(
                                text: '', fontSize: 14, color: Colors.black),
                          ),
                        ]),
                    ]),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
