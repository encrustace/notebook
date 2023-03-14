import 'package:flutter/material.dart';
import 'package:notebook/utils/constants.dart' as constants;
import 'package:notebook/utils/connection.dart';
import 'package:notebook/view/account_details.dart';

class AccountWidget extends StatefulWidget {
  final Map account;
  final VoidCallback voidCallback;
  const AccountWidget({
    super.key,
    required this.account,
    required this.voidCallback,
  });

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  final Connections _connections = Connections();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AccounDetails(account: widget.account,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: constants.randomColors[widget.account['color']],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.account['name'],
            ),
            IconButton(
                onPressed: () async {
                  int? response =
                      await _connections.deleteAccount(widget.account['name']);
                  switch (response) {
                    case 200:
                      const snackBar = SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text("Account deleted!"),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        widget.voidCallback;
                      }
                      break;
                    case 2067:
                      const snackBar = SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text("Account does not exist!"),
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
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
