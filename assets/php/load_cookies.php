<?php
error_reporting(0);
include_once ("dbconnect.php");
$sql = "SELECT * FROM COOKIES";
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cookies"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cookieslist = array();
        $cookieslist["image"] = $row["IMAGE"];
        $cookieslist["id"] = $row["ID"];
        $cookieslist["name"] = $row["NAME"];
        $cookieslist["price"] = $row["PRICE"];
        $cookieslist["quantity"] = $row["QUANTITY"];
        $cookieslist["rating"] = $row["RATING"];
        array_push($response["cookies"], $cookieslist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>