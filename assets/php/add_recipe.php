<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$username = $_POST['username'];
$image = $_POST['image'];
$name = $_POST['name'];
$recipe = $_POST['recipe'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../images/cookiesimages/'.$image.'.jpg';
$is_written = file_put_contents($path, $decoded_string);

if ($is_written > 0){
    $sqlregister = "INSERT INTO RECIPE(EMAIL,USERNAME,IMAGE,NAME,RECIPE) VALUES('$email','$username','$image','$name','$recipe')";

    if ($conn->query($sqlregister) === TRUE){
    echo "success";
    }else{
    echo "failed";
}
}else{
    echo "failed";
}

?>