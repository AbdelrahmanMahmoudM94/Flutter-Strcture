import 'package:mason/mason.dart';

void run(HookContext context) {
  final hasParams = context.logger.confirm(
    'Does this UseCase require parameters?',
    defaultValue: true,
  );

  String? paramTypeName;

  if (hasParams) {
    paramTypeName = context.logger.prompt(
      'What is the params type name?',
      defaultValue: 'Params',
    );
  }

  context.vars = {
    ...context.vars,
    'hasParams': hasParams,
    'paramTypeName': paramTypeName ?? '',
  };
}
