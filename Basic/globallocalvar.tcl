set x 10

proc fun {} {
 global x
 set x 12
}

puts $x
fun
puts $x
