proc jumlah {a b c} {
 set hasil [expr $a+$b+$c]
 return $hasil
}

set x [jumlah 1 2 3]
puts $x

