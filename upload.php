<?php
require('password.php');
ini_set('display_errors',0);

if ($_FILES["file"]["error"] > 0) {
	echo "Error: " . $_FILES["file"]["error"] . "<br>";
	return;
}
$path = getcwd()."/gpx_back/".$_FILES["file"]["name"];
if(move_uploaded_file($_FILES["file"]["tmp_name"], $path)){
	//echo "success";
}
$command = "./cleaner ".$path;
$output = shell_exec($command);

$url = 'http://www.strava.com/api/v3/uploads';

$file = '@'.realpath($path);
echo $file;
$postfields = array(
	"activity_type" => "ride",
	"data_type" => "gpx",
	"file" => $file.";type=application/xml"
);

$ch = curl_init( $url );
curl_setopt( $ch, CURLOPT_POSTFIELDS, $postfields);
curl_setopt( $ch, CURLOPT_HTTPHEADER, array('Authorization: Bearer '.$access_token));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
curl_setopt($ch, CURLOPT_HEADER, false);

$response = curl_exec( $ch );
echo var_dump(json_decode($response, true));
?>
