import 'package:cookbook/base_widgets/base_input_field.dart';
import 'package:flutter/material.dart';
import '../util/custom_text_style.dart';
import '../util/colors.dart';
import '../base_widgets/base_dropdown_button.dart';
import '../util/units.dart';
import '../util/input_checks.dart';
import '../base_widgets/base_button.dart';

class SpecIngredientList extends StatefulWidget {
  const SpecIngredientList({super.key});

  @override
  SpecIngredientListState createState() => SpecIngredientListState();
}

class SpecIngredientListState extends State<SpecIngredientList> {
  InputCheck check = InputCheck();
  List<Map<String, dynamic>> rows = [
    {
      'qtyC': TextEditingController(),
      'ingC': TextEditingController(),
      'qtyT': '',
      'unitT': 'unit',
      'ingT': '',
      'editable': true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: rows.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> row = entry.value;

            return Padding(
              padding: EdgeInsets.only(bottom: 10,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: !row['editable']
                    ? _buildTextLayout(row, index)
                    : _buildInputLayout(row, index),
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 15),
          child: SizedBox(
            height: 30,
            width: 30,
            child: CustomButton(
              func: _addNewRow,
              icon: Icon(
                Icons.add_rounded,
                color: MyColors.myWhite,
                size: 20,
              ),
            )
          ),
        )
      ],
    );
  }

  List<Widget> _buildInputLayout(Map<String, dynamic> row, int index) {
    return [
      Flexible(
        flex: 8,
        child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BaseInputField(
              control: row['qtyC'],
              hintText: 'qty',
              fillColour: MyColors.myBlack,
              focusedColour: MyColors.myRed,
              normalColour: MyColors.myGrey,
              textColour: MyColors.myWhite,
              paddingHeight: 10,
              borderWidth: 1,
              paddingWidth: 10,
              maxRows: 1,
            )
        ),
      ),
      Flexible(
        flex: 10,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: BaseDropdownButton(
            hintText: 'unit',
            currentValue: row['unitT'],
            values: units,
            func: (newValue) {
              setState(() {
                row['unitT'] = newValue!;
              });
            },
          ),
        ),
      ),
      Flexible(
        flex: 20,
          child: BaseInputField(
            control: row['ingC'],
            hintText: 'ingredient',
            fillColour: MyColors.myBlack,
            focusedColour: MyColors.myRed,
            normalColour: MyColors.myGrey,
            textColour: MyColors.myWhite,
            paddingWidth: 10,
            borderWidth: 1,
            paddingHeight: 10,
            maxRows: null,
          )
      ),
      SizedBox(
        width: 25,
        height: 30,
        child: IconButton(
          padding: EdgeInsets.only(left: 5),
          icon: const Icon(Icons.delete_rounded, color: MyColors.myBrightRed, size: 20,),
          onPressed: () => _deleteRow(index),
        ),
      ),
    ];
  }

  List<Widget> _buildTextLayout(Map<String, dynamic> row, int index) {
    return [
      SizedBox(
        width: 100,
        child: Row(
          children: [
            Flexible(
              child: Text(
                row['qtyT'],
                style: CustomTextStyle(size: 15, colour: MyColors.myWhite),
                softWrap: true, // Enable line breaks
                overflow: TextOverflow.visible,
              ),
            ),
            SizedBox(width: 10,),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 45),
              child: Text(
                row['unitT'],
                style: CustomTextStyle(size: 15, colour: MyColors.myWhite)),
            )
          ],
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width -245,
        child: Text(row['ingT'], style: CustomTextStyle(size: 15, colour: MyColors.myWhite)),
      ),
      Spacer(),
      SizedBox(
        width: 25,
        height: 20,
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          color: MyColors.myWhite,
          icon: const Icon(Icons.edit_rounded,),
          onPressed: () => _editRow(index),
        ),
      ),
      SizedBox(
        width: 25,
        height: 20,
        child: IconButton(
          padding: EdgeInsets.only(left: 5),
          iconSize: 20,
          color: MyColors.myBrightRed,
          icon: const Icon(Icons.delete_rounded,),
          onPressed: () => _deleteRow(index),
        ),
      )
    ];
  }

  bool save() {
    int counter = 0;
    bool saved = true;
    setState(() {
      for (var row in rows) {
        counter++;
        if (check.isNumeric(row['qtyC'].text) && check.isText(row['ingC'].text) && row['unitT']!='unit') {
          row['qtyT'] = row['qtyC'].text;
          row['ingT'] = row['ingC'].text;
          if (row['editable']) {
            row['qtyC'].dispose();
            row['ingC'].dispose();
            row['editable'] = false;
          }
        } else if (!check.isNumeric(row['qtyC'].text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter a valid quantity (>0) in row $counter."),
            ),
          );
          saved = false;
        } else if (!check.isText(row['ingC'].text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter a valid ingredient in row $counter."),
            ),
          );
          saved = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter a valid unit in row $counter."),
            ),
          );
          saved = false;
        }
      }
    });
    return saved;
  }

  void _addNewRow() {
    int counter = 0;
    bool addRow = true;
    setState(() {
      for (var row in rows) {
        counter++;
        if (check.isNumeric(row['qtyC'].text) && check.isText(row['ingC'].text) && row['unitT']!='unit') {
          row['qtyT'] = row['qtyC'].text;
          row['ingT'] = row['ingC'].text;
          if (row['editable']) {
            row['qtyC'].dispose();
            row['ingC'].dispose();
            row['editable'] = false;
          }
        } else if (!check.isNumeric(row['qtyC'].text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter a valid quantity (>0) in row $counter."),
            ),
          );
          addRow = false;
        } else if (!check.isText(row['ingC'].text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter a valid ingredient in row $counter."),
            ),
          );
          addRow = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter a valid unit in row $counter."),
            ),
          );
          addRow = false;
        }
      }
      if (addRow) {
        rows.add({
          'qtyC': TextEditingController(),
          'ingC': TextEditingController(),
          'qtyT': '',
          'unitT': 'unit',
          'ingT': '',
          'editable': true
        });
      }
    });
  }

  void _editRow(int index) {
    setState(() {
      if (!rows[index]['editable']) {
        rows[index]['qtyC'] = TextEditingController(text: rows[index]['qtyT']);
        rows[index]['ingC'] = TextEditingController(text: rows[index]['ingT']);
        rows[index]['editable'] = true;
      }
    });
  }

  void _deleteRow(int index) {
    setState(() {
      rows.removeAt(index);
    });
  }

  List<Map<String, String>> get inputs {
    return rows.map((row) {
      return {
        'qtyT' : row['qtyT'].toString(),
        'unitT' : row['unitT'].toString(),
        'ingT' : row['ingT'].toString(),
      };
    }).toList();
  }
}
