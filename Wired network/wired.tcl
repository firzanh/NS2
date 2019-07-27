#membuat objek simulator baru
set ns [new Simulator]

#membuat file trace, file ini untuk kebutuhan perekaman data
set tracefile [open wired.tr w]
$ns trace-all $tracefile

#membuat informasi animasi atau menciptakan file NAM
set namfile [open wired.nam w]
$ns namtrace-all $namfile

#membuat node
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#menciptakan link antara node dengan antrian (queue) droptail
#droptail artinya FIFO
$ns duplex-link $n0 $n1 5Mb 2ms DropTail
$ns duplex-link $n2 $n1 10Mb 5ms DropTail
$ns duplex-link $n1 $n4 3Mb 10ms DropTail
$ns duplex-link $n4 $n3 100Mb 2ms DropTail
$ns duplex-link $n4 $n5 4Mb 10ms DropTail

#menciptakan agen-agen
#node 0 ke node 3
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp
$ns attach-agent $n3 $null
$ns connect $udp $null

#menciptakan agen TCP
#node 2 to node 5
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

#menciptakan aplikasi CBR, FTP
#CBR - Constant Bit Rate (Contohnya file nmp3 yang memiliki CBR atau 192kbps, 320kbps, dsb)
#FTP - File Transfer Protocol (contohnya : untuk mendownload file dari sebuah jaringan)
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

set ftp [new Application/FTP]
$ftp attach-agent $tcp

#kasih warna biar asik
$ns color 1 "red"
$ns color 2 "blue"
$udp set fid_ 1
$tcp set fid_ 2 

#kasih label biar asik
$n0 label "UDP - CBR"
$n2 label "TCP - FTP"
$n3 label "Null"
$n5 label "Sink"

#mulai traffic
$ns at 1.0 "$cbr start"
$ns at 2.0 "$ftp start"

$ns at 10.0 "finish"

proc finish { } {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exec nam wired.nam &
	exit 0
}

puts "Simulasi sedang dimulai..."
$ns run
