<?php
require('password.php');
$url = "https://www.strava.com/oauth/authorize?client_id=".$client_id."&response_type=code&redirect_uri=http://ridecleaner.ddns.net/RideCleaner/auth_success.php&scope=write&approval_prompt=auto";
Header("Location: ".$url);
?>
