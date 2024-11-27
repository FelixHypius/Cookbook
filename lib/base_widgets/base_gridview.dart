import 'package:flutter/material.dart';
import '../base_widgets/base_list_child.dart';

class BaseGridView extends StatefulWidget {
  final String searchQuery;
  final List<dynamic> values;
  final String parent;

  const BaseGridView({
    super.key,
    required this.searchQuery,
    required this.values,
    required this.parent,
  });

  @override
  BaseGridViewState createState() => BaseGridViewState();
}

class BaseGridViewState extends State<BaseGridView> {

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
        parent: widget.parent,
        text: value['title'],
        id: value['id'],
        imageUrl: value['imageUrl'],
        contxt: context,
      );
    }).toList();
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 0.75,
      children: _filterList(widget.searchQuery, listViewChildren),
    );
  }
}
