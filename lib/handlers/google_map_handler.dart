import 'package:flutter_package_integrator/const/project_path.dart';
import 'package:flutter_package_integrator/handlers/package_handler.dart';
import 'package:flutter_package_integrator/models/file_patch.dart';
import 'package:flutter_package_integrator/models/flutter_package.dart';
import 'package:flutter_package_integrator/models/package_requirement.dart';
import 'package:flutter_package_integrator/models/platform_config.dart';

class GoogleMapHandler extends PackageHandler {
  GoogleMapHandler() ;

  @override
  String get displayName => 'google maps flutter';

  @override
  Future<FlutterPackage> load() async {
    return FlutterPackage(
      name: packageName,
      version: '^ 2.2.0',
      requiements: [
        PackageRequirement(
          key: 'apiKeyForAnroid',
          pormpt: 'Enter Google Api Key',
          validation: RegExp(r''),
        ),
        PackageRequirement(
          key: 'apiKeyForIos',
          pormpt: 'Enter Google Api Key',
          validation: RegExp(r''),
        ),
      ],
      platforms:(requirements) {
        return [
        
        PlatformConfig(
          platform: PlatFormType.android,
      
          patches:  [
              FilePatch(
                filePath: Paths.androidManifest,
                action: Action.replace,
                pattern: '<application',
                replacement: '''
                <application
                    android:name="Application"
                    android:icon="@mipmap/ic_launcher"
                    android:label="example">
                    <meta-data
                        android:name="com.google.android.geo.API_KEY"
                        android:value="\${api_key}"/>
              ''',
              ),
            ]
          ,
        ),
      ];
      },

      exampleCode: '''
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(37.42796, -122.08574),
            zoom: 14.4746,
          ),
        )
      ''',
      dependencies: {'googl_maps_flutter': 'version'},
    );
  }
  
  @override
  String get packageName => 'google_maps_flutter';
}
