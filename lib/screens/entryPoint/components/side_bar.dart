import 'package:flutter/material.dart';

import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  final SharedPreferences prefs;
  Menu selectedSideMenu;
  SideBar({required this.prefs, required this.selectedSideMenu});

  @override
  State<SideBar> createState() =>
      _SideBarState(prefs: prefs, selectedSideMenu: selectedSideMenu);
}

class _SideBarState extends State<SideBar> {
  late String name, surname, groupname;
  final SharedPreferences prefs;
  _SideBarState({required this.prefs, required this.selectedSideMenu}) {
    final List<String> account = prefs.getStringList('account')!;
    if (account.length > 0) {
      this.name = account[0];
      this.surname = account[1];
      this.groupname = account[2];
    } else {
      this.name = "";
      this.surname = "";
      this.groupname = "";
    }
  }

  Menu selectedSideMenu = sidebarMenus.toList()[0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: "$name $surname",
                bio: "Студент, $groupname",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Ресурсы".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          if (menu.title == 'Разговорчики') {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/confessions', (route) => false);
                          } else if (menu.title == 'Тайминг') {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/schedule', (route) => false);
                          } else if (menu.title == 'Чат') {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/homechat', (route) => false);
                          } else {
                            RiveUtils.chnageSMIBoolState(menu.rive.status!);
                            setState(() {
                              selectedSideMenu = menu;
                            });
                          }
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "Аккаунт".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus2
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          if (menu.title == 'Выйти') {
                            prefs.remove('account');
                            prefs.remove('is_verified');
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false);
                          } else {
                            RiveUtils.chnageSMIBoolState(menu.rive.status!);
                            setState(() {
                              selectedSideMenu = menu;
                            });
                          }
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
