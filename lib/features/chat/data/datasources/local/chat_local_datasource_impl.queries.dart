part of 'chat_local_datasource_impl.dart';

const getContactsSQLQuery =
    'SELECT * FROM profiles WHERE NOT id = ? ORDER BY username ASC';

const getMessagesFromRoomSQLQuery = '''
SELECT
    m.id AS id,
    m.created_at AS created_at,
    json_object(
        'id', p.id,
        'username', p.username,
        'image_url', p.image_url,
        'created_at', p.created_at,
        'bio', p.bio
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
            'image_url', p.image_url,
            'created_at', p.created_at,
            'bio', p.bio
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
    lm.lastMessage as last_message,
    lm.lastMessageStatus as last_message_status,
    lm.lastSenderId as last_sender_id,
    lm.lastMessageTimeSent last_message_time_sent,
    COUNT(CASE WHEN m.status = 0 THEN 1 END) AS unread_messages -- Assuming '0' represents unread
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

const getRoomWithParticipantSQLQuery = '''

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
            'image_url', p.image_url,
            'created_at', p.created_at,
            'bio', p.bio
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
    r.created_at AS created_at,
    up.participants,
    lm.lastMessage as last_message,
    lm.lastMessageStatus as last_message_status,
    lm.lastSenderId as last_sender_id,
    lm.lastMessageTimeSent as last_message_time_sent,
    COUNT(CASE WHEN m.status = 0 THEN 1 END) AS unread_messages -- Assuming '0' represents unread
FROM
    rooms r
LEFT JOIN
    UniqueParticipants up ON up.room_id = r.id
LEFT JOIN
    LastMessage lm ON lm.room_id = r.id
LEFT JOIN
    messages m ON m.room_id = r.id
JOIN
    room_participants rp2 ON rp2.room_id = r.id -- Ensure the participant is part of the room
WHERE
    rp2.profile_id = ? -- Replace <participant_id> with the actual profile ID
GROUP BY
    r.id
ORDER BY
    lm.lastMessageTimeSent DESC;

''';

const sendMessageSQLQuery = '''
  INSERT INTO messages (id, created_at, room_id, profile_id, content, status)
  VALUES (
      uuid(),               
      datetime(),    
      ?,          
      ?,       
      ?,        
      0              
  );

''';

const createRoomSQLQuery = '''
  INSERT INTO rooms (id, created_at)
  VALUES (?, datetime());
''';

const createProfileInteractionsSQLQuery = '''
  INSERT INTO profile_interactions (id, created_at, me, connection)
  VALUES (uuid(), datetime(), ?, ?);
''';

const addRoomParticipantsSQLQuery = '''
  INSERT INTO room_participants (id, created_at, profile_id, room_id)
  VALUES (uuid(), datetime(), ?, ?);
''';
