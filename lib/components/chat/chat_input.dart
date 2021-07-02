import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: null,
            splashRadius: 20,
            icon: Icon(
              Icons.image,
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(8),
              child: TextField(
                maxLines: null,
                onChanged: (val) {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: "Type a message...",
                  filled: true,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            splashRadius: 20,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
