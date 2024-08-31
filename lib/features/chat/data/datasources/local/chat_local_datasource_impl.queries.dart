part of 'chat_local_datasource_impl.dart';

const getContactsSQLQuery = 'SELECT * FROM profiles ORDER BY username ASC';

const getMessagesFromRoomSQLQuery = '''
SELECT
    m.id AS id,
    m.created_at AS createdAt,
    json_object(
        'id', p.id,
        'username', p.username,
        'image_url', p.image_url
    ) AS profile,
    m.content AS content,
    m.status AS status
FROM
    messages m
JOIN
    profiles p ON m.profile_id = p.id
WHERE
    m.room_id = ? 
ORDER BY
    m.created_at DESC;

''';

const getAllRoomsSQLQuery = '''
WITH LastMessage AS (
    SELECT
        room_id,
        content AS lastMessage,
        status AS lastMessageStatus,
        profile_id AS lastSenderId,
        created_at AS lastMessageTimeSent
    FROM
        messages
    WHERE
        created_at = (
            SELECT MAX(created_at)
            FROM messages AS sub_m
            WHERE sub_m.room_id = messages.room_id
        )
),
UniqueParticipants AS (
    SELECT
        rp.room_id,
        json_group_array(json_object(
            'id', p.id,
            'username', p.username,
            'image_url', p.image_url
        )) AS participants
    FROM
        room_participants rp
    JOIN
        profiles p ON p.id = rp.profile_id
    GROUP BY
        rp.room_id
)
SELECT
	  r.id,
    r.created_at,
    up.participants,
    lm.lastMessage,
    lm.lastMessageStatus,
    lm.lastSenderId,
    lm.lastMessageTimeSent,
    COUNT(CASE WHEN m.status = 0 THEN 1 END) AS unReadMessages -- Assuming '0' represents unread
FROM
    rooms r
LEFT JOIN
    UniqueParticipants up ON up.room_id = r.id
LEFT JOIN
    LastMessage lm ON lm.room_id = r.id
LEFT JOIN
    messages m ON m.room_id = r.id
GROUP BY
    r.id
ORDER BY
    lm.lastMessageTimeSent DESC;

''';

const sendMessageSQLQuery = '''
  INSERT INTO messages (id, created_at, room_id, profile_id, content, status)
  VALUES (
      uuid(),               -- Replace with a unique ID for the message (UUID or other unique identifier)
      datetime(),    -- Automatically sets the current timestamp
      ?,          -- Replace with the actual room ID
      ?,       -- Replace with the actual profile ID of the sender
      ?',          -- Replace with the actual message content
      0              -- Replace with the actual status (e.g., 0 for unread, 1 for read)
  );

''';
