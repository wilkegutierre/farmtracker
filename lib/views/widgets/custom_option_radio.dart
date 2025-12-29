import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomOptionRadio extends StatefulWidget {
  final String text;
  final int index;
  final int selectedButton;
  final Function press;

  const CustomOptionRadio({
    required this.text,
    required this.index,
    required this.selectedButton,
    required this.press,
  }) : super();

  @override
  OptionRadio createState() => OptionRadio();
}

class OptionRadio extends State<CustomOptionRadio> {
  int id = 1;
  bool _isButtonDisabled = false;

  OptionRadio();

  @override
  void initState() {
    _isButtonDisabled = false;
  }

  int _selected = -1;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.press(widget.index);
      },
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    RadioListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      title: Text(
                        '${widget.text}',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      groupValue: widget.selectedButton,
                      value: widget.index,
                      activeColor: Colors.green,
                      onChanged: (val) async {
                        debugPrint('Radio button is clicked onChanged $val');
                        widget.press(widget.index);
                      },
                      toggleable: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
