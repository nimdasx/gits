<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Menghitung Daging Qurban Sapi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
</head>
<body>

<div class="container">

    <h1>Menghitung Daging Qurban Sapi</h1>

    <p class="lead">
        Berdasarkan penjelasan dari Ustadz Nuruddin, 27 Juni 2023 / 9 Dulhijah 1444H
    </p>

    <div class="card mb-3">
        <div class="card-body">
            <form method="get">
                <div class="mb-3">
                    <label class="form-label">Masukkan Panjang Lingkar deket kaki depan ke belakang, yg perut, satuan CM</label>
                    <input type="number" name="el" class="form-control" value="<?= @$_GET['el'] ?>">
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
            </form>
        </div>
    </div>

    <?php
    if (isset($_GET['el'])) {
        $l = $_GET['el'];
        ?>
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Hasil Perhitungan</h5>
                <table class="table table-bordered">
                    <tr>
                        <th>Nilai L</th>
                        <td><?= $l ?> CM</td>
                    </tr>
                    <tr>
                        <th>A = (L + 22)^2 : 100</th>
                        <td><?= $a = pow($l+22,2)/100 ?> KG</td>
                    </tr>
                    <tr>
                        <th>B = 3,26% dari A</th>
                        <td><?= $b = round($a*3.26/100,2) ?> KG</td>
                    </tr>
                    <tr>
                        <th>C = A Dikurangi 3,26%</th>
                        <td><?= $c = round($a-$b,2) ?> KG</td>
                    </tr>
                    <tr>
                        <th>Karkas = C dibagi 2</th>
                        <td><?= $karkas = round($c/2,2) ?> KG</td>
                    </tr>
                    <tr>
                        <th>Daging = 70% dari Karkas</th>
                        <td><?= $daging = round($karkas*70/100,2) ?> KG</td>
                    </tr>
                    <tr>
                        <th>Daging dibagi 7 sohibul (1/7)</th>
                        <td><?= $sepertuju = round($daging / 7,2) ?> KG</td>
                    </tr>
                    <tr>
                        <th>Daging 1/3 dari 1/7</th>
                        <td><?= $sepertiga = round($sepertuju / 3,2) ?> KG</td>
                    </tr>
                </table>
            </div>
        </div>
        <?
    }
    ?>

</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
        crossorigin="anonymous"></script>
</body>
</html>
