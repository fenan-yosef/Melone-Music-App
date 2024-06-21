class MenuModel {
  List<String> menuItems = ["Playback Settings", "Appearance", "Timer", "Settings"];
  String? currentSelection;

  List<String> getMenuItems() {
    return menuItems;
  }

  void setCurrentSelection(String selection) {
    if (menuItems.contains(selection)) {
      currentSelection = selection;
    } else {
      throw Exception("Invalid menu selection");
    }
  }

  String? getCurrentSelection() {
    return currentSelection;
  }
}
