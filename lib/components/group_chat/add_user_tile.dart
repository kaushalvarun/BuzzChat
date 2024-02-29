import 'package:flutter/material.dart';

class AddUserTile extends StatelessWidget {
  final String username;
  final void Function() onPressed;
  const AddUserTile({
    super.key,
    required this.onPressed,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: SizedBox(
                  width: 60,
                  child: Image.asset(
                    'lib/images/groupDefault.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onPressed,
          ),
          dense: true,
          visualDensity: const VisualDensity(vertical: 2.5),
        ),
        const Divider(
          indent: 25,
          height: 20,
        )
      ],
    );
  }
}
