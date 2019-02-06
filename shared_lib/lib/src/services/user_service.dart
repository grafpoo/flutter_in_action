/*
 * Copyright 2018 Eric Windmill. All rights reserved.
 * Use of this source code is governed by the MIT license that can be found in the LICENSE file.
 */

import 'package:shared_lib/e_commerce_app.dart';

abstract class UserService {
  Stream<ECommerceUser> streamUserInformation();
  Future addUserProduct(Product p);
  Future updateUserInformation(ECommerceUser user);
}

class MockUserService implements UserService {
  final AppStore store;

  MockUserService(this.store);

  @override
  Stream<ECommerceUser> streamUserInformation() {
    return store.userNotifier.stream.map((snapshot) => store.user);
  }

  @override
  Future addUserProduct(Product p) async {
    store.user.userProducts.add(p);
  }

  @override
  Future updateUserInformation(ECommerceUser user) async {
    store.user = user;
  }
}
