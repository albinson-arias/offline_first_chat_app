import 'package:equatable/equatable.dart';
import 'package:record_result/record_result.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, required this.statusCode});

  final String message;
  final String statusCode;

  @override
  List<Object?> get props => [message, statusCode];

  ServerFailure toFailure() {
    return ServerFailure(message: message, statusCode: statusCode);
  }
}
