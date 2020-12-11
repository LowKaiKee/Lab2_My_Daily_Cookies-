<?php
    error_reporting(0);
    include_once("dbconnect.php");
    $email = $_GET['email'];
    $otp = $_GET['key'];
    
    $sql = "SELECT * FROM USER WHERE EMAIL = '$email'";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE USER SET OTP = '0' WHERE EMAIL = '$email' AND OTP = '$otp'";
        if ($conn->query($sqlupdate) === TRUE){
            echo 'Your verification is success. Welcome to My Daily Cookies application! Thank you for register it!';
        }else{
            echo 'failed';
        }   
    }else{
        echo "failed";
    }
    
    
?>