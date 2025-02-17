//panggil DI dari mana pun, ini contoh panggil DI session
$sesi = Phalcon\DI::getDefault()->get('session');

//raw sql
$di = \Phalcon\DI::getDefault();
$db = $di->get('db');
$r = $db->query($sql);
$r = $r->fetchAll($r);
$y = $r[0];