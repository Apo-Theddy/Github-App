import 'package:dartz/dartz.dart';
import 'package:github_app/core/errors/api_failure.dart';

typedef APIResponse<T> = Either<APIFailure, T>;
