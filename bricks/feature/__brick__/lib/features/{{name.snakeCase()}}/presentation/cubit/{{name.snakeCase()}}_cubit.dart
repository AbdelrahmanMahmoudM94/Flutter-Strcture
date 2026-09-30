import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

part '{{name.snakeCase()}}_state.dart';

@Injectable()
class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {
 {{name.pascalCase()}}Cubit() : super({{name.pascalCase()}}Initial());

 
}