Class Student 

Student instproc show {} {
 $self instvar name roll city
 puts "Name : $name"
 puts "Roll : $roll"
 puts "City : $city"
}

Student obj1 
obj1 set name "firza"
obj1 set roll 1234
obj1 set city "malang"

obj1 show
