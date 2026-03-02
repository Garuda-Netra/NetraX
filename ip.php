<?php

if (!empty($_SERVER['HTTP_CLIENT_IP']))
    {
      $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
    }
elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))
    {
      $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
    }
else
    {
      $ipaddress = $_SERVER['REMOTE_ADDR'];
    }
$useragent = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
$date      = date('Y-m-d H:i:s');

/* ── Central data directory ── */
$data_dir = __DIR__ . '/data';
if (!is_dir($data_dir)) {
    mkdir($data_dir, 0750, true);
}

$log_file = $data_dir . '/ip_logs.txt';
$entry    = "[{$date}] IP: {$ipaddress} | User-Agent: {$useragent}\r\n";

$fp = fopen($log_file, 'a');
if ($fp) {
    flock($fp, LOCK_EX);
    fwrite($fp, $entry);
    flock($fp, LOCK_UN);
    fclose($fp);
}

/* ── Signal shell script that a new IP arrived ── */
file_put_contents($data_dir . '/.flag_ip', date('Y-m-d H:i:s'));
