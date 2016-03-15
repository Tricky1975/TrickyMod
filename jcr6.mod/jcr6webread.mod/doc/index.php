<?

/*
 
 This little script will just make a list for the WebRead driver of JCR6.
 All files it finds in the same directory as this script (except this script itself of course)
 will be reported to JCR6. This script does not work recursively yet. Future versions of it might!
 
 
 * WARNING! *
 
 Make sure no scripts containing any security data can be picked up by this script as it will not see the difference.
 Every file is just picked up. NO EXCEPTIONS!
 
 */
 

// $compalgrithms = array('Store','zlib'); -- Used for later reference, if this script can detect compress files.
 
$mydir = realpath(dirname(__FILE__));
if ($mydir[-1]!="/") $mydir = $mydir . "/";
unset($entries);



if ($handle = opendir($mydir)) {

    while (false !== ($entry = readdir($handle))) {
		if ($mydir.$entry!=__FILE__ && $entry[0]!="." && (!is_dir($mydir.$entry))){
		$entries[$entry]['Size'] = filesize($mydir.$entry);
		$entries[$entry]['Comp'] = $entries[$entry]['Size']; // This needs to be present for drivers supporting zlib
		$entries[$entry]['Storage'] = 'Store';}		
    }
    closedir($handle);
} 

echo "<!--\n\n";
echo "WELCOME:JCR6\n";
echo "HANDSHAKE:WEBDRIVE\n\n";


foreach($entries as $name => $data)
{
	echo "\nENTRY:$name\n";
	foreach($data as $k => $v) echo "\t$k:$v\n";

}
echo "GOODBYE:JCR6\n";
echo "WAVE:KISS\n";
echo "-->\n";
	



?>
