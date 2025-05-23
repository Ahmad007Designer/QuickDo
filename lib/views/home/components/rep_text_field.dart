import 'package:flutter/material.dart';
import 'package:todo_app/utils/app_str.dart';

class RepTextField extends StatelessWidget {
  const RepTextField({
    super.key,
    required this.controller,
    this.isForDescription = false,
    required this.onChanged,
    required this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool isForDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextFormField(
          controller: controller,
          maxLines: !isForDescription ? 5 : null,
          cursorHeight: !isForDescription ? 40 : null,
          style: TextStyle(color: Colors.black, fontSize: 20),
          decoration: InputDecoration(
            border: isForDescription ? InputBorder.none : null,
            counter: Container(),
            hintText: isForDescription ? MyString.addNote : null,
            prefixIcon:
                isForDescription
                    ? Icon(Icons.bookmark_border, color: Colors.grey)
                    : null,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),

            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),

          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
