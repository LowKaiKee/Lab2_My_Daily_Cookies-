<?php
include_once("dbconnect.php");

$name = $_POST['name'];
$comment = $_POST['comment'];
$email = $_POST['email'];
$username = $_POST['username'];

$sqlregister = "INSERT INTO COMMENT(NAME,COMMENT,EMAIL,USERNAME) VALUES('$name','$comment','$email','$username')";

if ($conn->query($sqlregister) === TRUE) {

    echo "success";
  
}else{
    echo "failed";
}

?>