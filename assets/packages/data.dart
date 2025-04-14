// import 'package:flutter_package_integrator/handlers/base_package_handler.dart';
// import 'package:flutter_package_integrator/models/file_patch.dart';
// import 'package:flutter_package_integrator/models/flutter_package.dart';
// import 'package:flutter_package_integrator/models/platform_config.dart';

// class Data {
//   final data = <String, FlutterPackage>{
//     'google_maps_flutter': FlutterPackage(
//       name: 'google_maps_flutter',
//       dependencies: {'google_maps_flutter': '2.12.1'},
//       version: '',
//       platforms: [PlatformConfig(platform: PlatFormType.android, patches: [ FilePatch(
//               filePath: 'android/app/src/main/AndroidManifest.xml',
//               pattern: '<application',
//               replacement: '<application\n'
//                   '        android:name="Application"\n'
//                   '        android:icon="@mipmap/ic_launcher"\n'
//                   '        android:label="example">\n'
//                   '        <meta-data\n'
//                   '            android:name="com.google.android.geo.API_KEY"\n'
//                   '            android:value="${api_key}"/>',
//             ),])],
//       exampleCode: '',
//     ),
//   };
  
//   static get api_key => null;
// }
