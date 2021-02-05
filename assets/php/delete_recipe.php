<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$name = $_POST['name'];
    $sqldelete = "DELETE FROM RECIPE WHERE EMAIL = '$email' AND NAME='$name'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>