 module Case_bottom(){

    BASE_WIDTH = 300;
    BASE_DEPTH = 233;//210;
    BASE_HEIGHT = 5;
    BOTTOM_HEIGHT = 30; // TODO: Measure this.
    OUTER_WALL = 5;

    difference(){
        
        // Base cube
        cube([BASE_WIDTH,BASE_DEPTH,BOTTOM_HEIGHT]);
        
        // Cutout for electronics
        translate([OUTER_WALL, OUTER_WALL, BASE_HEIGHT]){
            cube([BASE_WIDTH-(OUTER_WALL*2),BASE_DEPTH-(OUTER_WALL*2),BOTTOM_HEIGHT+OUTER_WALL]);
        }
        
        // Cutout for keyboard
        translate([BASE_WIDTH-3, 0, 21.5]){
            rotate([5,0,90]){
                //color("green")
                //Keyboard();
                cube([233,81,BOTTOM_HEIGHT]);
            }
        }
        
        // Cut-off keyboard lip
        translate([BASE_WIDTH-3, 0, 23]){
            cube([20,233,10]);
        }
    }
    
    // Add hinge
    translate([(BASE_WIDTH/2)-15,OUTER_WALL,0]){
        cube([BOTTOM_HEIGHT,OUTER_WALL,(BOTTOM_HEIGHT*1.5)-OUTER_WALL]);
        translate([BOTTOM_HEIGHT/2,0,(BOTTOM_HEIGHT*1.5)-OUTER_WALL]){
            rotate([-90,0,0]){
                cylinder(r=BOTTOM_HEIGHT/2,h=OUTER_WALL);
            }
        }
    }
    translate([(BASE_WIDTH/2)-15,BASE_DEPTH-(OUTER_WALL*2),0]){
        cube([BOTTOM_HEIGHT,OUTER_WALL,(BOTTOM_HEIGHT*1.5)-OUTER_WALL]);
        translate([BOTTOM_HEIGHT/2,0,(BOTTOM_HEIGHT*1.5)-OUTER_WALL]){
            rotate([-90,0,0]){
                cylinder(r=BOTTOM_HEIGHT/2,h=OUTER_WALL);
            }
        }
    }
}

//Case_bottom();