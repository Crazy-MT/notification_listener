import 'dart:convert';
import 'dart:io';

import 'package:process_run/shell_run.dart';

class ExecShell {
  static final ExecShell _app = ExecShell._();

  ExecShell._() {
    print('MTMTMT ExecShell._ ${userHome} ${Platform.environment['HOME']} ${Platform.environment['HOME']}');
    shell = Shell(
      workingDirectory: userHome,
      environment: Platform.environment,
      throwOnError: false,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );
  }

  factory ExecShell() => _app;

  String? get userHome =>
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

  late Shell shell;

  Future<List<ProcessResult>?> execShell(
      String arguments, {
        void Function(Process process)? onProcess,
      }) async {
    List<ProcessResult>? results;

    try {
      results = await shell.run(arguments, onProcess: onProcess);
      return results;
    } catch (e) {
      print(e);
      return null;
    } finally {
      return results;
    }
  }
}