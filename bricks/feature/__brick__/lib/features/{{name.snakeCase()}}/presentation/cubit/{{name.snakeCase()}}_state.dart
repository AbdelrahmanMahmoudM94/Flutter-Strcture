// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '{{name.snakeCase()}}_cubit.dart';

abstract class {{name.pascalCase()}}State {}

class {{name.pascalCase()}}Initial extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}ReadyState extends {{name.pascalCase()}}State {
  
}

class {{name.pascalCase()}}LoadingState extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}ErrorState extends {{name.pascalCase()}}State {
 {{name.pascalCase()}}ErrorState({
    required this.message,
  });
  final String message;
}

 