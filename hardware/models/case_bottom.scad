include <modules/vent.scad>

module Case_bottom(){

    BASE_WIDTH = 300;
    BASE_DEPTH = 243;//233;//210;
    BASE_HEIGHT = 5;
    BOTTOM_HEIGHT = 30; // TODO: Measure this.
    OUTER_WALL = 5;
    HINGE_BOLT_SHAFT_DIAMETER = 5;

    difference(){
        
        // Base cube
        cube([BASE_WIDTH,BASE_DEPTH,BOTTOM_HEIGHT]);
        
        // Cutout for electronics
        translate([OUTER_WALL, OUTER_WALL, BASE_HEIGHT]){
            cube([BASE_WIDTH-(OUTER_WALL*2),BASE_DEPTH-(OUTER_WALL*2),BOTTOM_HEIGHT+OUTER_WALL]);
        }
        
        // Cutout for fans
        translate([OUTER_WALL,BASE_DEPTH-20-3,OUTER_WALL-2]){
            cube([40.5,20.5,40.5]);
            translate([19,22,BOTTOM_HEIGHT-3]){
                rotate([90,0,180]){
                    Vent();
                }
            }
        }
        translate([OUTER_WALL+40+2,BASE_DEPTH-20-3,OUTER_WALL-2]){
            cube([40.5,20.5,40.5]);
            translate([19,22,BOTTOM_HEIGHT-3]){
                rotate([90,0,180]){
                    Vent();
                }
            }
        }
        translate([OUTER_WALL+40+2+40+2,BASE_DEPTH-20-3,OUTER_WALL-2]){
            cube([40.5,20.5,40.5]);
            translate([19,22,BOTTOM_HEIGHT-3]){
                rotate([90,0,180]){
                    Vent();
                }
            }
        }
        
        // Cutout for keyboard
        translate([BASE_WIDTH-3, 0, 21.5]){
            rotate([5,0,90]){
                //color("green")
                //Keyboard();
                cube([BASE_DEPTH,81,BOTTOM_HEIGHT]);
            }
        }
        
        // Cut-off keyboard lip
        translate([BASE_WIDTH-3, 0, 23]){
            cube([20,BASE_DEPTH,10]);
        }
        
    }
    
    // Add hinge
    translate([(BASE_WIDTH/2)-15,OUTER_WALL,0]){
        difference(){
            union(){
                cube([BOTTOM_HEIGHT,OUTER_WALL,BOTTOM_HEIGHT*1.5]);
                translate([BOTTOM_HEIGHT/2,0,BOTTOM_HEIGHT*1.5]){
                    rotate([-90,0,0]){
                        cylinder(r=BOTTOM_HEIGHT/2,h=OUTER_WALL);
                    }
                }
            }
            translate([BOTTOM_HEIGHT/2,0,BOTTOM_HEIGHT*1.5]){
                rotate([-90,0,0]){
                    cylinder(r=HINGE_BOLT_SHAFT_DIAMETER/2,h=OUTER_WALL);
                }
            }
        }
    }
    translate([(BASE_WIDTH/2)-15,BASE_DEPTH-(OUTER_WALL*2),0]){
        difference(){
            union(){
                cube([BOTTOM_HEIGHT,OUTER_WALL,BOTTOM_HEIGHT*1.5]);
                translate([BOTTOM_HEIGHT/2,0,BOTTOM_HEIGHT*1.5]){
                    rotate([-90,0,0]){
                        cylinder(r=BOTTOM_HEIGHT/2,h=OUTER_WALL);
                    }
                }
            }
            translate([BOTTOM_HEIGHT/2,0,BOTTOM_HEIGHT*1.5]){
                rotate([-90,0,0]){
                    cylinder(r=HINGE_BOLT_SHAFT_DIAMETER/2,h=OUTER_WALL);
                }
            }
        }
    }
}

//Case_bottom();