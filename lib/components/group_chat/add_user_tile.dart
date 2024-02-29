import 'package:flutter/material.dart';

class AddUserTile extends StatelessWidget {
  final String username;
  final void Function() onTap;
  const AddUserTile({
    super.key,
    required this.onTap,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
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
            onPressed: () {
              // implement please
            },
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
