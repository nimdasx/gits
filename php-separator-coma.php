<input type="text"
       id="pagu_operasi_text"
       class="form-control"
       value="<?= $_POST['pagu_operasi'] ?? $r->pagu_operasi ?>"
       placeholder="Operasi">
<input type="hidden" id="pagu_operasi_raw" name="pagu_operasi">

<script src="<?= $bu ?>js/easy-number-separator/easy-number-separator.js"></script>
<script>
    easyNumberSeparator({
        selector: '#pagu_operasi_text',
        separator: ',',
        resultInput: '#pagu_operasi_raw',
    })
</script>