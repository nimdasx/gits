<?php
$sql = "
    update apbdm_bidang_urusan
    set apbdm_bidang_urusan_id=bidang_urusan_kode
";
$this->db->execute($sql);