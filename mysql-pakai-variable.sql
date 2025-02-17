SET @var_name = '2wsadsafsaf';
SELECT @var_name;

delete from apbd_kegiatan where go_unor_id_opd=@var_name;
delete from apbn_kegiatan where go_unor_id_opd=@var_name;
delete from apbn_program where go_unor_id_opd=@var_name;
delete from dak_uraian where go_unor_id_opd=@var_name;
delete from dak_kegiatan where go_unor_id_opd=@var_name;
delete from dak_program where go_unor_id_opd=@var_name;
delete from go_unor where go_unor_id=@var_name;