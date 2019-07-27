Class Student 

Student instproc show {} {
 $self instvar name roll city
 puts "Name : $name"
 puts "Roll : $roll"
 puts "City : $city"
}

Student instproc init {} {
 $self instvar name roll city
 set name "no name"
 set roll 0
 set city "bekasi"
}

Student ob1

#ob1 set name "firza"
#ob1 set roll 1234
#ob1 set city "malang"

ob1 show
