import 'package:flutter/material.dart';
import './settings_controller.dart';
import 'playback/playback_controller.dart';
import 'playback/playback_model.dart';
import 'playback/playback_view.dart';
// import './settings_viewmodel.dart';

class MenuView extends StatefulWidget {
  final MenuControler controller;

  MenuView({required this.controller});

  @override
  _MenuViewState createState() => _MenuViewState();
}


class _MenuViewState extends State<MenuView> {
  void _onItemTapped(int index) {
    widget.controller.selectMenuItem(index);
    String selectedItem = widget.controller.model.getMenuItems()[index];

    // Navigate based on the selected menu item
    if (selectedItem == "Playback Settings") {
      // Navigate to the Playback Settings page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaybackSettingsView(
            controller: PlaybackSettingsController(PlaybackSettings()),
          ),
        ),
      );
    } else {
      // Handle other menu items
      // For example, show a placeholder or a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected: $selectedItem')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Melone Menu'),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: widget.controller.model.getMenuItems().length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.controller.model.getMenuItems()[index]),
            onTap: () => _onItemTapped(index),
          );
        },
      ),
    );
  }
}