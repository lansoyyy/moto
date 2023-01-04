import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:localstore/localstore.dart';
import 'package:moto/screens/leaderboard_screen.dart';
import 'package:moto/widgets/appbar_widget.dart';
import 'package:moto/widgets/button_widget.dart';
import 'package:moto/widgets/text_widget.dart';

class CategScreen extends StatefulWidget {
  @override
  State<CategScreen> createState() => _CategScreenState();
}

class _CategScreenState extends State<CategScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  late String name;

  late String score;

  late String number;

  final box = GetStorage();

  final db = Localstore.instance;

  List<String> names = [];
  List<String> numbers = [];
  List<int> scores = [];

  var hasLoaded = false;

  getData() async {
    final items = await db.collection(box.read('categ')).get();

    if (items != null) {
      List<dynamic> values = items.values.toList();

      values.sort((a, b) => a['score'].compareTo(b['score']));
      items.forEach((key, value) {
        names.add(value['name']);
        numbers.add(value['number']);
        scores.add(value['score']);

        print(values);
      });
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
              ? 'Amature Category'
              : box.read('categ') == 'beg'
                  ? 'Beginner Category'
                  : 'Pro Category',
          context),
      body: hasLoaded
          ? Container(
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: SizedBox(
                    child: DataTable(columns: [
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
                    ], rows: [
                      for (int i = 0; i < names.length; i++)
                        DataRow(
                          cells: [
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
                          ],
                        ),
                    ]),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  height: 40,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minWidth: 130,
                                  color: Colors.black,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: SizedBox(
                                              height: 320,
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextBold(
                                                        text: 'Adding Entry',
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 5, 20, 5),
                                                      child: TextFormField(
                                                        onChanged: (input) {
                                                          name = input;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Name: '),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 5, 20, 5),
                                                      child: TextFormField(
                                                        onChanged: (input) {
                                                          number = input;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Number: '),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 5, 20, 5),
                                                      child: TextFormField(
                                                        onChanged: (input) {
                                                          score = input;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Score: '),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    ButtonWidget(
                                                        onPressed: () async {
                                                          final id = db
                                                              .collection(
                                                                  box.read(
                                                                      'categ'))
                                                              .doc()
                                                              .id;

                                                          db
                                                              .collection(
                                                                  box.read(
                                                                      'categ'))
                                                              .doc(id)
                                                              .set({
                                                            'name': name,
                                                            'number': number,
                                                            'score': int.parse(
                                                                score),
                                                          });

                                                          final items = await db
                                                              .collection(
                                                                  box.read(
                                                                      'categ'))
                                                              .get();

                                                          print(items);
                                                          // final List<String>
                                                          //     jsonList =
                                                          //     box.read('users');

                                                          // print(jsonList);

                                                          // final List<UserModel>
                                                          //     users = jsonList
                                                          //         .map((json) =>
                                                          //             UserModel.fromJson(
                                                          //                 jsonDecode(
                                                          //                     json)))
                                                          //         .toList();

                                                          // for (UserModel user
                                                          //     in users) {
                                                          //   print(user.name);
                                                          //   print(user.score);
                                                          //   print(user.number);
                                                          // }
//                                                     final UserModel user =
//                                                         UserModel(
//                                                             name: name,
//                                                             score: int.parse(
//                                                                 score),
//                                                             number: number);

// // Retrieve the list of JSON strings from storage
//                                                     final List<String>
//                                                         jsonList =
//                                                         box.read('users');

// // Deserialize the JSON strings to a list of UserModel objects
//                                                     final List<UserModel>
//                                                         users = jsonList
//                                                             .map((json) =>
//                                                                 UserModel.fromJson(
//                                                                     jsonDecode(
//                                                                         json)))
//                                                             .toList();

// // Add the new user to the list
//                                                     users.add(user);

// // Serialize the updated list of users to a list of JSON strings
//                                                     final List<String>
//                                                         updatedJsonList = users
//                                                             .map((u) =>
//                                                                 jsonEncode(u))
//                                                             .toList();

// // Store the updated JSON string list in storage under the key "users"
//                                                     box.write('users',
//                                                         updatedJsonList);
//                                                     final List<UserModel>
//                                                         users = [
//                                                       UserModel(
//                                                           name: 'John',
//                                                           score: 10,
//                                                           number: '123'),
//                                                       UserModel(
//                                                           name: 'Jane',
//                                                           score: 20,
//                                                           number: '456'),
//                                                       UserModel(
//                                                           name: 'Bob',
//                                                           score: 30,
//                                                           number: '789'),
//                                                     ];

//                                                     print(users);

// // Serialize the users to a list of JSON strings
//                                                     final List<String>
//                                                         jsonList = users
//                                                             .map((u) =>
//                                                                 jsonEncode(u))
//                                                             .toList();

// // Store the JSON string list in storage under the key "users"
//                                                     try {
//                                                       box.write(
//                                                           'users', jsonList);
//                                                     } catch (e) {
//                                                       print('error');
//                                                     }

                                                          // final List<UserModel> list =
                                                          //     box.read('data');

                                                          // list.add(UserModel(
                                                          //     name: name,
                                                          //     number: number,
                                                          //     score:
                                                          //         int.parse(score)));

                                                          // box.write('data', list);

                                                          // final UserModel user =
                                                          //     UserModel(
                                                          //         name: name,
                                                          //         score: int.parse(
                                                          //             score),
                                                          //         number: number);
                                                          // final String json =
                                                          //     jsonEncode(user);
                                                          // box.write('data', [json]);

                                                          // box.write(
                                                          //     'data',
                                                          //     UserModel(
                                                          //         name: name,
                                                          //         number: number,
                                                          //         score: int.parse(
                                                          //             score)));

                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              CategScreen()));
                                                        },
                                                        text: 'Continue'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: TextBold(
                                      text: 'Add Entry',
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                MaterialButton(
                                  height: 40,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minWidth: 130,
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LeaderBoardScreen()));
                                  },
                                  child: TextBold(
                                      text: 'View Leaderbord',
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
