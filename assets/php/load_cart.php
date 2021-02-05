<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

// $sql = "SELECT * FROM COOKIESORDER WHERE EMAIL = '$email'";

$sql = "SELECT COOKIESORDER.ID, COOKIESORDER.QUANTITY, COOKIESORDER.REMARKS, 
COOKIES.IMAGE, COOKIES.NAME, COOKIES.PRICE FROM COOKIESORDER
INNER JOIN COOKIES ON COOKIESORDER.ID = COOKIES.ID
WHERE COOKIESORDER.EMAIL = '$email'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["cart"] = array();
    while ($row = $result ->fetch_assoc()){
        $cartlist = array();
        $cartlist[id] = $row["ID"];
        $cartlist[quantity] = $row["QUANTITY"];
        $cartlist[remarks] = $row["REMARKS"];
        $cartlist[image] = $row["IMAGE"];
        $cartlist[name] = $row["NAME"];
        $cartlist[price] = $row["PRICE"];
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>