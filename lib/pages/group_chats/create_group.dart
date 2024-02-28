import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'Create a new Group',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // body
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: TextField(
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          controller: _groupNameController,
          maxLines: null, // to wrap input text
          minLines: 1,
          decoration: InputDecoration(
            hintText: 'Enter Group Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            focusedBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            isDense: true, // Reduces the overall height of the TextField
          ),

          // trigger rebuild if longer wrapped text
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
