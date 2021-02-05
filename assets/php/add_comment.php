<?php
include_once("dbconnect.php");

$image = $_POST['image'];
$cookiesname = $_POST['cookiesname'];
$email = $_POST['email'];
$name = $_POST['name'];
$review = $_POST['review'];


$sqlregister = "INSERT INTO REVIEW(IMAGE, COOKIESNAME, EMAIL, NAME, REVIEW) VALUES('$image','$cookiesname','$email','$name','$review')";

if ($conn->query($sqlregister) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>