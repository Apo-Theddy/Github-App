import 'package:equatable/equatable.dart';

class APIFailure extends Equatable implements Exception {
  final String message;
  final int code;

  const APIFailure(this.message, this.code);

  @override
  List<Object?> get props => [message, code];
}
