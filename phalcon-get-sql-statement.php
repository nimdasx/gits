<?php        
//cara dapat real sql statement di everywhere
$di = \Phalcon\DI::getDefault();
$db = $di->get('db');
print_r($db->getRealSQLStatement());

//cara data real sql statement di controller
$db = $this->di->get('db');
print_r($db->getRealSQLStatement());