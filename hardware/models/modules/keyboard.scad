module Keyboard(){
    
    /*
    Planck STL is 233x81x1.5mm
    */
    //cube([81,233,1.5]);
    union(){
        cube([5,81,1.5]);
        translate([2,0,0]){
            import("../planck_plate.stl");
            translate([233,0,0]){
                cube([5,81,1.5]);
            }
        }
    }
}

//Keyboard();