/*
 * Copyright 2018 Eric Windmill. All rights reserved.
 * Use of this source code is governed by the MIT license that can be found in the LICENSE file.
 */

import 'dart:async';

import 'package:e_commerce_start_chapter_8/app.dart';
import 'package:flutter/material.dart';
import 'package:shared_lib/e_commerce_app.dart';

class AppMenu extends StatefulWidget {
  @override
  AppMenuState createState() => AppMenuState();
}

class AppMenuState extends State<AppMenu> with RouteAware {
  String _activeRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    _activeRoute = ModalRoute.of(context).settings.name;
  }

  Future _navigate(String route) async {
    await Navigator.popAndPushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    _activeRoute ??= "/";

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/apple-in-hand.jpg"),
            ),
            accountEmail: Text("eric@ericwindmill.com"),
            accountName: Text("Eric Windmill"),
            onDetailsPressed: () {
              Navigator.pushReplacementNamed(
                  context, ECommerceRoutes.userSettingsPage);
            },
          ),
          ListTile(
            leading: Icon(Icons.apps),
            title: Text("Catalog"),
            selected: _activeRoute == ECommerceRoutes.catalogPage,
            onTap: () => _navigate(ECommerceRoutes.catalogPage),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Cart"),
            selected: _activeRoute == ECommerceRoutes.cartPage,
            onTap: () => _navigate(ECommerceRoutes.cartPage),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("My Products"),
            selected: _activeRoute == ECommerceRoutes.addProductFormPage,
            onTap: () => _navigate(ECommerceRoutes.addProductFormPage),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("User Settings"),
            selected: _activeRoute == ECommerceRoutes.userSettingsPage,
            onTap: () => _navigate(ECommerceRoutes.userSettingsPage),
          ),
          AboutListTile(
            icon: Icon(Icons.info),
            applicationName: "Produce Store",
            aboutBoxChildren: <Widget>[
              Text("Thanks for reading Flutter in Action!"),
            ],
          ),
        ],
      ),
    );
  }
}
