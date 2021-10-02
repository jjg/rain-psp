include <modules/clusterboard.scad>
include <modules/pinea64.scad>
include <modules/keyboard.scad>

BASE_WIDTH = 300;
BASE_DEPTH = 210;
BASE_HEIGHT = 5;
BOTTOM_HEIGHT = 50; // TODO: Measure this.
OUTER_WALL = 5;

difference(){
    
    // Base cube
    cube([BASE_WIDTH,BASE_DEPTH,BOTTOM_HEIGHT]);
    
    // Cutout for electronics
    translate([OUTER_WALL, OUTER_WALL, BASE_HEIGHT]){
        cube([BASE_WIDTH-(OUTER_WALL*2),BASE_DEPTH-(OUTER_WALL*2),BOTTOM_HEIGHT+OUTER_WALL]);
    }
    
    // Cutout for keyboard
    translate([BASE_WIDTH, 0, 20]){
        rotate([15,0,90]){
            //color("green")
            //Keyboard();
            cube([210,100,BOTTOM_HEIGHT]);
        }
    }
}

// Add clusterboard
translate([10,10,BASE_HEIGHT]){
    color("red")
    Clusterboard();
}

// Add A64
translate([BASE_WIDTH-10, 10, BASE_HEIGHT]){
    rotate([0,0,90]){
        color("blue")
        PINEA64();
    }
}

// Add keyboard
translate([BASE_WIDTH, 0, 20]){
    rotate([15,0,90]){
        color("green")
        Keyboard();
    }
}