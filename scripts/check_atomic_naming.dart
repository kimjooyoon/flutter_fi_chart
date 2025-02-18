import 'dart:io';

class Logger {
  static void error(String message) {
    stderr.writeln('\x1B[31mError: $message\x1B[0m');
  }

  static void success(String message) {
    stdout.writeln('\x1B[32m$message\x1B[0m');
  }
}

void main() {
  final atomicLevels = ['atoms', 'molecules', 'organisms', 'templates', 'pages'];
  var hasError = false;

  // lib/presentation/atomic 디렉토리 검사
  for (final level in atomicLevels) {
    final dir = Directory('lib/presentation/atomic/$level');
    if (!dir.existsSync()) continue;

    final files = dir.listSync(recursive: true).whereType<File>();
    for (final file in files) {
      final filename = file.path.split('/').last;
      
      // 파일명이 app_로 시작하는지 검사
      if (!filename.startsWith('app_')) {
        Logger.error('$filename should start with "app_"');
        hasError = true;
      }

      // 파일명이 적절한 접미사를 가지는지 검사
      final suffixes = {
        'atoms': [
          '_button',
          '_text',
          '_icon',
          '_input',
          '_divider',
          '_chip',
          '_text_field',
          '_card',
        ],
        'molecules': [
          '_card',
          '_list_item',
          '_form_field',
          '_search_bar',
          '_input_group',
          '_dropdown',
        ],
        'organisms': [
          '_form',
          '_header',
          '_footer',
          '_sidebar',
          '_chart',
          '_table',
          '_navigation',
        ],
        'templates': [
          '_layout',
          '_grid',
          '_screen',
          '_dashboard',
        ],
        'pages': [
          '_page',
          '_view',
          '_screen',
          '_dashboard',
        ],
      };

      if (suffixes.containsKey(level)) {
        final hasSuffix = suffixes[level]!.any((suffix) => 
          filename.endsWith('$suffix.dart'));
        if (!hasSuffix) {
          Logger.error('$filename should end with one of ${suffixes[level]}');
          hasError = true;
        }
      }
    }
  }

  // test/goldens/atomic 디렉토리 검사
  for (final level in atomicLevels) {
    final dir = Directory('test/goldens/atomic/$level');
    if (!dir.existsSync()) continue;

    final files = dir.listSync(recursive: true).whereType<File>();
    for (final file in files) {
      final filename = file.path.split('/').last;
      
      // 테스트 파일명이 _test.dart로 끝나는지 검사
      if (!filename.endsWith('_test.dart')) {
        Logger.error('Test file $filename should end with "_test.dart"');
        hasError = true;
      }

      // 구현 파일이 존재하는지 검사
      final implFilename = filename.replaceAll('_test.dart', '.dart');
      final implFile = File('lib/presentation/atomic/$level/$implFilename');
      if (!implFile.existsSync()) {
        Logger.error('Implementation file not found for test: $filename');
        hasError = true;
      }
    }
  }

  if (hasError) {
    exit(1);
  }
  
  Logger.success('All atomic design naming conventions passed!');
  exit(0);
} 