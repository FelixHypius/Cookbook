import 'package:flutter/material.dart';
import 'base_list_child.dart';

class BaseListView extends StatefulWidget {
  final String searchQuery;
  final List<dynamic> values;

  const BaseListView({
    super.key,
    required this.searchQuery,
    required this.values,
  });

  @override
  BaseListViewState createState() => BaseListViewState();
}

class BaseListViewState extends State<BaseListView> {

  List<BaseListChild> _filterList(String query, List<BaseListChild> list) {
    if (query.isEmpty) return list;
    return list.where((child) {
      return child.text.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<BaseListChild> listViewChildren = widget.values.map((value) {
      return BaseListChild(
        text: value['title'],
        id: value['id'],
        contxt: context,
      );
    }).toList();
    return GridView.count(
      crossAxisCount: 1,
      mainAxisSpacing: 10,
      childAspectRatio: 8,
      children: _filterList(widget.searchQuery, listViewChildren),
    );
  }
}
