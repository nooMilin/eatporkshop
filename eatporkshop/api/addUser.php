<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', '', "eatporkshop");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$ChooseType = $_GET['ChooseType'];
		$Name = $_GET['Name'];
		$User = $_GET['User'];
		$Password = $_GET['Password'];
							
		$sql = "INSERT INTO `user`(`id`, `ChooseType`, `Name`, `User`, `Password`) VALUES (Null,'$ChooseType','$Name','$User','$Password')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Hello World";
   
}
	mysqli_close($link);
?>