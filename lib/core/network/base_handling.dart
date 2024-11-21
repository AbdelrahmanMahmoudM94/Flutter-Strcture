import 'package:dartz/dartz.dart';

import '../../error/failure.dart';

typedef CustomResponseType<T> = Either<Failure, T>;
