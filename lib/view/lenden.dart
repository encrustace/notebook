import 'package:flutter/material.dart';
import 'package:notebook/utils/connection.dart';
import 'package:notebook/utils/constants.dart' as constants;
import 'package:notebook/view/account_widget.dart';

class Lenden extends StatefulWidget {
  const Lenden({super.key});

  @override
  State<Lenden> createState() => _LendenState();
}

class _LendenState extends State<Lenden> {
  bool _newAccountTab = false;
  final Connections _connections = Connections();
  final TextEditingController _newAccounController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedColor = "";

  Future<void> addNewAccount() async {
    if (_newAccounController.text.isEmpty) {
      const snackBar = SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("Give account name!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (_selectedColor == "") {
      const snackBar = SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("Select the color!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      int? response = await _connections.addNewAccount(
          _newAccounController.text, _selectedColor, _noteController.text);
      switch (response) {
        case 200:
          const snackBar = SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text("Account added!"),
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            setState(() {});
          }
          break;
        case 2067:
          const snackBar = SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text("Account already exist!"),
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          break;
        default:
          const snackBar = SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text("Something went wrong!"),
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: _connections.getAccounts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data.isEmpty) {
                return const Center(
                  child: Icon(Icons.clear),
                );
              }
              final entries = snapshot.data;
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return AccountWidget(
                    account: entries[index],
                    voidCallback: () {
                      setState(() {});
                    },
                  );
                },
                itemCount: entries.length,
              );
            },
          )),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                decoration: const BoxDecoration(color: Colors.white70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("New account"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _newAccountTab = !_newAccountTab;
                          });
                        },
                        icon: Icon(
                            _newAccountTab ? Icons.close : Icons.file_open)),
                  ],
                ),
              ),
              _newAccountTab
                  ? Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: constants.randomColors.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = constants
                                          .randomColors.keys
                                          .elementAt(index);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    height: 50,
                                    width: _selectedColor ==
                                            constants.randomColors.keys
                                                .elementAt(index)
                                        ? 60
                                        : 50,
                                    decoration: BoxDecoration(
                                        color: constants.randomColors.values
                                            .elementAt(index),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                );
                              }),
                        ),
                        TextField(
                          controller: _newAccounController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              label: const Text("Account Name"),
                              suffix: IconButton(
                                icon: const Icon(Icons.done),
                                onPressed: () {
                                  addNewAccount();
                                },
                              )),
                        ),
                      ],
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}
