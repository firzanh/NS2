set ns [new Simulator]

set tr [ open "out.tr" w ]
$ns trace-all $tr

set ftr [ open "out.nam" w ]
$ns namtrace-all $ftr

proc finish { } {
	global ns tr ftr
	$ns flush-trace
	close $tr
	close $ftr
	exec nam out.nam &
	exit
	}

set n0 [$ns node]
$n0 shape box
$n0 color yellow

set n1 [$ns node]
$n1 color red

$ns duplex-link $n0 $n1 3Mb 3ms DropTail

$ns at 2.1 "finish"

$ns run
