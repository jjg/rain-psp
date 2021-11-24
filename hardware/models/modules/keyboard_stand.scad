module Keyboard_stand(){
    
    BASE_WIDTH = 300;
    BASE_DEPTH = 243;//233;//210;
    BASE_HEIGHT = 5;
    BOTTOM_HEIGHT = 30; // TODO: Measure this.
    OUTER_WALL = 5;
    
    difference(){
        cube([80,BASE_DEPTH-(OUTER_WALL*2),20]);
        translate([3,3,0]){
            cube([80,(BASE_DEPTH-(OUTER_WALL*2))-3*2,20]);
        }
    }
}

Keyboard_stand();