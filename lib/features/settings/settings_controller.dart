import './settings_viewmodel.dart';

class MenuControler {
  final MenuModel model;

  MenuControler(this.model);

  void selectMenuItem(int index) {
    var menuItems = model.getMenuItems();
    if (index >= 0 && index < menuItems.length) {
      var selection = menuItems[index];
      model.setCurrentSelection(selection);
      print("Selected: $selection"); // Or update the view to reflect this
    } else {
      print("Invalid selection");
    }
  }
}
