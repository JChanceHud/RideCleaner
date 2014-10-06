<?php
require('password.php');
$url = "https://www.strava.com/oauth/token";
$postfields = array(
	"client_id" => $client_id,
	"client_secret" => $client_secret,
	"code" => $_GET["code"]
);

$ch = curl_init( $url );
curl_setopt( $ch, CURLOPT_POSTFIELDS, $postfields);
curl_setopt( $ch, CURLOPT_HEADER, 1);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
curl_setopt($ch, CURLOPT_HEADER, false);

$response = curl_exec( $ch );
$json = json_decode($response, true);

?>

<html>
<title>Success!</title>
<h2>Successfully authenticated</h2>
<h3>Auth code: <?php echo $json["access_token"]; ?></h3>

</html>
