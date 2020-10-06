<?php
/***************************************************************************************
This is a simple PHP script to lookup for blacklisted IP against multiple DNSBLs at once.

You are free to use the script, modify it, and/or redistribute the files as you wish.

Homepage: http://dnsbllookup.com
****************************************************************************************/
function dnsbllookup($ip){
$listed = 0;
$dnsbl_lookup=array("bl.spamcop.net","cbl.abuseat.org","dnsbl.sorbs.net","zen.spamhaus.org"); // Add your preferred list of DNSBL's
if($ip){
$reverse_ip=implode(".",array_reverse(explode(".",$ip)));
foreach($dnsbl_lookup as $host){
if(checkdnsrr($reverse_ip.".".$host.".","A")){
$listed += 1;
}
}
}
echo $listed;
}
$ip=$_GET['ip'];
if(isset($_GET['ip']) && $_GET['ip']!=null){
if(filter_var($ip,FILTER_VALIDATE_IP)){
echo dnsbllookup($ip);
}else{
echo "NON-IP";
}
}
?> 