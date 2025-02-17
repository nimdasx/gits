<?php
$files = $this->request->getUploadedFiles("FILE_INOVASI");
            if ($this->request->hasFiles()) {
                foreach ($files as $file)
                {
                    $new_file_final = $r->TAHUN.'-'.$r->SKPD_ID.'-'.$r->KEGIATAN_ID.'-'.$file->getName();
                    $file->moveTo(
                        'dokumen-inovasi/'.$new_file_final
                    );

                    $r->FILE_INOVASI = 'dokumen-inovasi/'.$new_file_final;
                }
            }