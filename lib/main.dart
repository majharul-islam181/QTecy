// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'app.dart';
// import 'flavors.dart';

// void main() {
//   F.appFlavor = Flavor.values.firstWhere(
//     (element) => element.name == appFlavor,
//   );

//   runApp(const App());
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'app.dart';

FutureOr<void> main() async {
  runApp(const App());
}