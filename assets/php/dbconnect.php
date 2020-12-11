<?php
$servername ="localhost";
$username   ="doubleks_mydailycookiesadmin";
$password   ="FqT56A9SkGVVTgp";
$dbname     ="doubleks_mydailycookies";

$conn = new mysqli($servername, $username, $password, $dbname);
if($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}
?>