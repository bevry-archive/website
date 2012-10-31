<?php
# Example 1
echo "hello\n";
sleep(2);
echo "world\n";

# Example 2
$contents = file_get_contents('difference-node.js');
if ( $contents === false ) {
	echo "error occured\n";
	exit(-1);
} else {
	echo $contents;
}

# Example 3
$one = file_get_contents('difference-node.js');
$two = file_get_contents('difference-php.php');
if ( $one === false || $two === false ) {
	echo "error occured\n";
	exit(-1);
} else {
	echo "one: $one\n";
	echo "two: $two\n";
}

# Example 4
# ... o_O ...