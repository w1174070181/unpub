import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:unpub/unpub.dart';

final notExistingPacakge = 'not_existing_package';

final baseUri = Uri.parse('http://localhost:3000');

// abstract class TestRusnner {
// Future<UnpubMetaStore> createMetaStore();

// Future<UnpubPackageStore> createPackageStore();

// startServer() async {
//   var repository = UnpubRepository(
//     metaStore: await createMetaStore(),
//     packageStore: await createPackageStore(),
//     shouldCheckUploader: false,
//   );
//   var server = UnpubServer(repository);
//   await server.serve('localhost', 3000);
// }

// Future<Map> readMeta(String package);

String readPubspec(String package, String version) {
  return File(path.absolute('test/fixtures', package, version, 'pubspec.yaml'))
      .readAsStringSync();
}

Future<http.Response> getVersions(String package) {
  package = Uri.encodeComponent(package);
  return http.get(baseUri.resolve('/api/packages/$package'));
}

Future<http.Response> getSpecificVersion(String package, String version) {
  package = Uri.encodeComponent(package);
  version = Uri.encodeComponent(version);
  return http.get(baseUri.resolve('/api/packages/$package/versions/$version'));
}

ProcessResult pubPublish(String package, String version) {
  return Process.runSync('pub', ['publish', '--force'],
      workingDirectory: path.absolute('test/fixtures', package, version),
      environment: {'PUB_HOSTED_URL': 'http://localhost:3000'});
}