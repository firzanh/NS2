#Contoh dari jaringan wireless
#Langkah 1 - inisialisasi variabel
#langkah 2 - buat simulator objek
#langkah 3 - buat file tracing dan animasi
#langkah 4 - topografi
#langkah 5 - GOD - General Operation Director
#langkah 6 - buat node-node
#langkah 7 - buat saluran/channel (PATH komunikasi)
#langkah 8 - posisi pada node (node nirkabel membutuhkan sebuah lokasi
#langkah 9 - ada kode mobilitas (mobitiy code) (jika node-node bergerak)
#langkah 10 - TCP, UDP traffic
#run simulasi

#Langkah 1 - inisialisasi variabel
set val(chan)	Channel/WirelessChannel		;#Channel Type
set val(prop)	Propagation/TwoRayGround	;#Radio-Propagation Model
set val(netif)	Phy/WirelessPhy			;#Network Interface Type WAVELAN DSSS 2.4Ghz
set val(mac)	Mac/802_11			;#MAC Type
set val(ifq)	Queue/DropTail/PriQueue		;#Interface Queue Type
set val(ll)	LL				;#Link Layer Type
set val(ant)	Antenna/OmniAntenna		;#Antenna model
set val(ifqlen)	50				;#Max Packet in Ifq
set val(nn)	6				;#Number of Mobilenodes
set val(rp)	AODV				;#Routing Protocol
set val(x)	500				;#dalam meter
set val(y)	500				;#dalam meter

#langkah 2 - buat simulator objek
set ns [new Simulator]

#langkah 3 - buat file tracing dan animasi
set tracefile [open wireless.tr w]
$ns trace-all $tracefile

set namfile [open wireless.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#langkah 4 - topografi
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#langkah 5 - GOD - General Operation Director
create-god $val(nn)
set channel1 [new $val(chan)]
set channel2 [new $val(chan)]
set channel3 [new $val(chan)]

#langkah 6 - buat dan konfigurasi node-node
#langkah 7 - buat saluran/channel (PATH komunikasi)
$ns node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-macTrace ON \
		-routerTrace ON \
		-movementTrace ON \
		-channel $channel1

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n0 random-motion 0
$n1 random-motion 0
$n2 random-motion 0
$n3 random-motion 0
$n4 random-motion 0
$n5 random-motion 0

$ns initial_node_pos $n0 20
$ns initial_node_pos $n1 20
$ns initial_node_pos $n2 20
$ns initial_node_pos $n3 20
$ns initial_node_pos $n4 20
$ns initial_node_pos $n5 50

#langkah 8 - posisi pada node (node nirkabel membutuhkan sebuah lokasi
#inisialisasi koordinat node-node
$n0 set X_ 10.0
$n0 set Y_ 20.0
$n0 set Z_ 0.0

$n1 set X_ 210.0
$n1 set Y_ 230.0
$n1 set Z_ 0.0

$n2 set X_ 100.0
$n2 set Y_ 200.0
$n2 set Z_ 0.0

$n3 set X_ 150.0
$n3 set Y_ 230.0
$n3 set Z_ 0.0

$n4 set X_ 430.0
$n4 set Y_ 320.0
$n4 set Z_ 0.0

$n5 set X_ 270.0
$n5 set Y_ 120.0
$n5 set Z_ 0.0

#jangan naro nilai apapun diatas 500 karena luasnya 500m x 500m 

#langkah 9 - ada kode mobilitas (mobitiy code) (jika node-node bergerak)
#Pada waktu kapan? Node yang mana? Kemana? Kelajuannya?
$ns at 1.0 "$n1 setdest 490.0 340.0 25.0"
$ns at 1.0 "$n4 setdest 300.0 130.0 5.0"
$ns at 1.0 "$n5 setdest 190.0 440.0 15.0"
#node-node bisa bergerak beberapa kali pada sebuah lokasi saat simulasi
$ns at 20.0 "$n5 setdest 100.0 200.0 30.0"

#langkah 10 - Agen-agen TCP, UDP traffic
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n0 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 1.0 "$ftp start"

set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n2 $udp
$ns attach-agent $n3 $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$ns at 1.0 "$cbr start"

$ns at 30.0 "finish"

proc finish {} {
	global ns tracefile namfile
	$ns flush-trace
	close $tracefile
	close $namfile
	exit 0
}

#run simulasi
puts "Memulai Simulasi..."
$ns run

