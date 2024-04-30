// ignore_for_file: unused_import, camel_case_types, override_on_non_overriding_member, annotate_overrides, prefer_final_fields, unused_field, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Myproject2 extends StatefulWidget {
  const Myproject2({super.key});

  @override
  State<Myproject2> createState() => _MyprojectState();
}

class _MyprojectState extends State<Myproject2> {
  @override
  bool _lights = false;
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SwitchItem(),
    );
  }
}

class SwitchItem extends StatefulWidget {
  const SwitchItem({super.key});

  @override
  State<SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<SwitchItem> {
  @override
  bool isSelected = false;
  void itemSwitch(bool value) {
    setState(() {
      isSelected = isSelected;
    });
  }

  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("ON"),
      trailing: Switch(
          value: isSelected, onChanged: itemSwitch, activeColor: Colors.blue),
    );
  }
}
