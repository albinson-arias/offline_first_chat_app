import 'package:powersync/powersync.dart';

const schema = Schema([
  Table('rooms', [
    Column.text('created_at'),
  ]),
  Table('room_participants', [
    Column.text('created_at'),
    Column.text('profile_id'),
    Column.text('room_id'),
  ]),
  Table('messages', [
    Column.text('created_at'),
    Column.text('room_id'),
    Column.text('profile_id'),
    Column.text('content'),
    Column.integer('status'),
  ]),
  Table('profiles', [
    Column.text('created_at'),
    Column.text('username'),
    Column.text('image_url'),
    Column.text('bio'),
    Column.text('fcm_token'),
  ]),
  Table('status', [
    Column.text('created_at'),
    Column.text('profile_id'),
    Column.text('link_url'),
    Column.integer('views'),
    Column.text('expires_at'),
  ]),
]);
