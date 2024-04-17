
import 'package:flutter/material.dart';


class CostumeWidget{

  CostumeWidget(this.context);

  final BuildContext context;

  Widget myTextFieldView({TextEditingController? controller, String? labelText, InputBorder? border, double vertical = 5, double horizontal = 30, int minLine = 1, int maxLine = 1}) => Padding(

    padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
    child: TextField(
      controller: controller,
      minLines: minLine,
      textInputAction: TextInputAction.newline,
      maxLines: maxLine,
      decoration: InputDecoration(labelText: labelText, border: border ?? const UnderlineInputBorder()),
    ),
  );

  Widget myButtonView({VoidCallback? onPressed, String? btnName, double vertical = 10, double horizontal = 30}) => Container(

    padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
    width: MediaQuery.of(context).size.width,
    child: ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), child: Text(btnName!, style: const TextStyle(color: Colors.white),)),
  );

}