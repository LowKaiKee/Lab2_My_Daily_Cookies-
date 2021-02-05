<?php
error_reporting(0);
include_once("dbconnect.php");


$sql = "SELECT * FROM RECIPE"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) 
{
    $response["recipe"]= array();
    while($row = $result -> fetch_assoc())
    {
        $recipelist = array();
        $recipelist[id] = $row["ID"];
        $recipelist[email] = $row["EMAIL"];
        $recipelist[username] = $row["USERNAME"];
        $recipelist[image] = $row["IMAGE"];
        $recipelist[name] = $row["NAME"]; 
        $recipelist[recipe] = $row["RECIPE"];
        array_push($response["recipe"], $recipelist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>