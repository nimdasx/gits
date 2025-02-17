<?

mysql_connect('localhost','root','');
mysql_select_db('xxx');

$query = mysql_query("select * from lk_isi");

while( $row = mysql_fetch_assoc($query) ){
  $bener  = array();
  $tmp   = explode('.',$row['HIRARKI']);
  
  foreach( $tmp as $iva ){
    if( strlen($iva) < 2 ){
      $bener[] = str_pad($iva,2,'0',STR_PAD_LEFT);
    }else{
      $bener[] = $iva;
    }
  }
  
  $imp = implode('.',$bener);
  
  //echo "update lk_isi set HIRARKI = '$imp' where ISI_ID = '".$row['ISI_ID']."'; <br/>";
  mysql_query("update lk_isi set HIRARKI = '$imp' where ISI_ID = '".$row['ISI_ID']."'");
}

?>