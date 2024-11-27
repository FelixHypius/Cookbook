import 'package:flutter/material.dart';
import '../database/database_service.dart';
import '../util/colors.dart';
import '../base_widgets/base_dropdown_button.dart';
import '../base_widgets/base_future_builder.dart';

class SpecSectionDropdownButton extends StatefulWidget {
  const SpecSectionDropdownButton({super.key});

  @override
  SpecSectionDropdownButtonState createState() => SpecSectionDropdownButtonState();
}

class SpecSectionDropdownButtonState extends State<SpecSectionDropdownButton> {
  final DatabaseService dbs = DatabaseService();
  String section = 'recipe category';

  String? get selectedSection {
    if (section == 'recipe category') return null;
    return section;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.sizeOf(context).width-30,
      child: BaseFutureBuilder(
        func: dbs.fetchSections(),
        build: (context, values) {
          List<String> dropdownValues = values!;
          return BaseDropdownButton(
            hintText: 'recipe category',
            currentValue: section,
            values: dropdownValues,
            func: (newValue) {
              setState(() {
                section = newValue!;
              });
            },
          );
        },
      )
    );
  }
}