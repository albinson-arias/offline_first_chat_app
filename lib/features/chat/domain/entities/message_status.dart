import 'package:dart_mappable/dart_mappable.dart';

part 'message_status.mapper.dart';

@MappableEnum(mode: ValuesMode.indexed)
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
}
