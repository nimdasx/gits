<?php

//gini
$sql = "
    update apbdm_urusan
    set apbdm_urusan_id=urusan_kode
";
$di = \Phalcon\DI::getDefault();
$db = $di->get('db');
$telo = $db->execute($sql);

//gini juga bisa
$sql = "
    update apbdm_urusan
    set apbdm_urusan_id=urusan_kode
";
$db = Phalcon\DI::getDefault()->get('db');
$telo = $db->execute($sql);