import 'package:flutter/material.dart';
import 'package:notebook/utils/connection.dart';

class AccounDetails extends StatefulWidget {
  final Map account;
  const AccounDetails({super.key, required this.account});

  @override
  State<AccounDetails> createState() => _AccounDetailsState();
}

class _AccounDetailsState extends State<AccounDetails> {
  bool _newTransactionTab = false;
  final Connections _connections = Connections();
  final TextEditingController _newTransactionController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _transactionType = "Debit";

  Future<void> addNewTransaction() async {
    if (_newTransactionController.text.isEmpty) {
      const snackBar = SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("Enter amount!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (int.tryParse(_newTransactionController.text) == null) {
      const snackBar = SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("Only numbers allowed!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (int.parse(_newTransactionController.text) < 0) {
      const snackBar = SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("Amount can not be negative!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      int? response = await _connections.addNewTransaction(
          int.parse(_newTransactionController.text),
          _transactionType,
          widget.account["id"],
          _noteController.text);
      switch (response) {
        case 200:
          _noteController.clear();
          _newTransactionController.clear();
          _newTransactionTab = false;
          const snackBar = SnackBar(
            duration: Duration(milliseconds: 500),
            content: Text("Transaction added!"),
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            setState(() {});
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: _connections.getTransactions(),
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
                  return Column(
                    children: [
                      Container(
                        height: 150,
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(166, 255, 255, 255),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entries[index]['note'] != ""
                                  ? entries[index]['note']
                                  : "No Note",
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 67, 237, 0)),
                            ),
                            Text(
                              "₹${entries[index]['amount']}",
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.black),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  color: Color.fromARGB(255, 67, 237, 0),
                                  size: 16,
                                ),
                                Text(
                                  entries[index]['timestamp'].toString(),
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Expanded(child: Container()),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color.fromARGB(255, 67, 237, 0),
                                    size: 14,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 14,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    const Text("New transaction"),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _newTransactionTab = !_newTransactionTab;
                          });
                        },
                        icon: Icon(_newTransactionTab
                            ? Icons.close
                            : Icons.file_open)),
                  ],
                ),
              ),
              _newTransactionTab
                  ? Column(
                      children: [
                        Row(children: [
                          SizedBox(
                            width: 140,
                            child: ListTile(
                              title: const Text("Debit"),
                              leading: Radio<String>(
                                value: "Debit",
                                groupValue: _transactionType,
                                onChanged: (String? value) {
                                  setState(() {
                                    _transactionType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 140,
                            child: ListTile(
                              title: const Text("Credit"),
                              leading: Radio<String>(
                                value: "Credit",
                                groupValue: _transactionType,
                                onChanged: (String? value) {
                                  setState(() {
                                    _transactionType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _newTransactionController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  label: Text("Amount"),
                                ),
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _noteController,
                            minLines: 5,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              label: Text("Note"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                addNewTransaction();
                              },
                              child: const Text("SUBMIT")),
                        )
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
