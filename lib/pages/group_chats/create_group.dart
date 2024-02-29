import 'package:buzzchatv2/components/general_components/my_button.dart';
import 'package:buzzchatv2/pages/group_chats/add_members.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              controller: _groupNameController,
              maxLines: null, // to wrap input text
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Enter Group Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                isDense: true, // Reduces the overall height of the TextField
              ),

              // trigger rebuild if longer wrapped text
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 40),
            MyButton(
              onTap: () {
                // create group in db
                // go to add members page
                if (_groupNameController.text.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.amber[200],
                          title: const Text(
                            'Group Name can\'t be empty',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Center(
                                child: Text('OK'),
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMembers(
                                groupName: _groupNameController.text,
                              )));
                }
              },
              msg: 'Add Members',
            ),
          ],
        ),
      ),
    );
  }
}
