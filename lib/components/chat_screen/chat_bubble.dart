import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String messageText;
  final bool isCurrentUser;
  final String msgTimestamp;

  const ChatBubble({
    super.key,
    required this.messageText,
    required this.isCurrentUser,
    required this.msgTimestamp,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool readMoreMsg = false;
  @override
  Widget build(BuildContext context) {
    // to dynamically get maxlines for read more
    double screenHeight = MediaQuery.of(context).size.height;
    int maxLines = (screenHeight / 16)
        .floor(); // maxLines for text = screenHeight / fßontSize

    final Color bubbleColor = widget.isCurrentUser
        ? const Color.fromRGBO(194, 175, 244, 1)
        : const Color.fromRGBO(238, 238, 238, 1);
    final Color readMoreColor = widget.isCurrentUser
        ? const Color.fromARGB(255, 0, 0, 0)
        : const Color.fromARGB(255, 32, 10, 83);
    final alignment =
        widget.isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.messageText,
                  maxLines: readMoreMsg ? maxLines : 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Helvetica',
                  ),
                ),
                if (widget.messageText.length > 100)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            readMoreMsg = !readMoreMsg;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            readMoreMsg ? 'Read less' : 'Read more',
                            style: TextStyle(
                              color: readMoreColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.msgTimestamp,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Helvetica',
                          fontStyle: FontStyle.normal,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    widget.msgTimestamp,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Helvetica',
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
