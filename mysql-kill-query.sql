SELECT
  GROUP_CONCAT(CONCAT('KILL ', id, ';') SEPARATOR ' ') KillQuery
FROM information_schema.processlist
WHERE user <> 'root'
AND time >= 100;