<?php

//Username and Password from form
$username = "nettest";
$password = "nettest";
$salt = "12345678" //any random 8 digit

//connecting to azure vm using ssh
$ssh = new Net_SSH2('52.187.17.111:22');
$ssh->login('root', '04112000') or die("Login failed");
$ssh->getServerPublicHostKey();
$cmd = "sudo useradd -m -p $(mkpasswd -m sha-512 $password $salt) $username";
$cmdr = $ssh->exec($cmd); 
?>