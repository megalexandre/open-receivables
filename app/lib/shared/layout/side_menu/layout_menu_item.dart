import 'package:flutter/material.dart';

enum LayoutMenuItemType { item, header }

class LayoutMenuItem {
  const LayoutMenuItem._({
    required this.type,
    required this.label,
    this.id = '',
    this.icon,
    this.hasChildren = false,
    this.indent = false,
  });

  factory LayoutMenuItem.item({
    required String id,
    required String label,
    required IconData icon,
    bool hasChildren = false,
    bool indent = false,
  }) =>
      LayoutMenuItem._(
        type: LayoutMenuItemType.item,
        id: id,
        label: label,
        icon: icon,
        hasChildren: hasChildren,
        indent: indent,
      );

  factory LayoutMenuItem.header(String label) => LayoutMenuItem._(
        type: LayoutMenuItemType.header,
        label: label,
      );

  factory LayoutMenuItem.fromJson(Map<String, dynamic> json) {
    if (json['type'] == 'header') {
      return LayoutMenuItem.header(json['label'] as String);
    }
    return LayoutMenuItem.item(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: _iconMap[json['icon'] as String] ?? Icons.circle_outlined,
      hasChildren: json['hasChildren'] as bool? ?? false,
      indent: json['indent'] as bool? ?? false,
    );
  }

  final LayoutMenuItemType type;
  final String id;
  final String label;
  final IconData? icon;
  final bool hasChildren;
  final bool indent;

  bool get isHeader => type == LayoutMenuItemType.header;
  bool get isItem => type == LayoutMenuItemType.item;

  static const Map<String, IconData> _iconMap = {
    'dashboard': Icons.dashboard,
    'payments': Icons.payments,
    'bolt': Icons.bolt,
    'search': Icons.search,
    'receipt_long': Icons.receipt_long,
    'history': Icons.history,
    'category': Icons.category,
    'home': Icons.home,
    'group': Icons.group,
    'location_on': Icons.location_on,
    'water_drop': Icons.water_drop,
    'science': Icons.science,
    'account_balance_wallet': Icons.account_balance_wallet,
    'post_add': Icons.post_add,
  };
}
