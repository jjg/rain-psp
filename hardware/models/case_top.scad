include <modules/vent.scad>

module Case_top(){
    
    WIDTH = 149;
    DEPTH = 243;//233;//210;
    HEIGHT = 30;
    OUTER_WALL = 5;
    
    difference(){
        
        // Main box
        cube([WIDTH, DEPTH, HEIGHT]);
        
        // Cut-aways for display
        translate([WIDTH-26,0,0]){
            rotate([0,30,0]){
                cube([HEIGHT, OUTER_WALL, HEIGHT-5]);
            }
        }
        translate([WIDTH-26,DEPTH-OUTER_WALL,0]){
            rotate([0,30,0]){
                cube([HEIGHT, OUTER_WALL, HEIGHT-5]);
            }
        }
        translate([WIDTH,0,HEIGHT/2]){
            rotate([-90,0,0]){
                cylinder(r=HEIGHT/2,h=OUTER_WALL*2);
            }
        }
        translate([WIDTH,DEPTH-(OUTER_WALL*2),HEIGHT/2]){
            rotate([-90,0,0]){
                cylinder(r=HEIGHT/2,h=OUTER_WALL*2);
            }
        }
        
        // Make room for electronics
        translate([OUTER_WALL, OUTER_WALL, OUTER_WALL]){
            cube([WIDTH,DEPTH-(OUTER_WALL*2),HEIGHT+OUTER_WALL]);
        }
        
        // Cutout for fans
        translate([OUTER_WALL,3,OUTER_WALL-2]){
            cube([40.5,20.5,40.5]);
            translate([19,0,HEIGHT-3]){
                rotate([90,0,180]){
                    Vent();
                }
            }
        }
        translate([OUTER_WALL+40+2,3,OUTER_WALL-2]){
            cube([40.5,20.5,40.5]);
            translate([19,0,HEIGHT-3]){
                rotate([90,0,180]){
                    Vent();
                }
            }
        }
        translate([OUTER_WALL+40+2+40+2,3,OUTER_WALL-2]){
            cube([40.5,20.5,40.5]);
            translate([19,0,HEIGHT-3]){
                rotate([90,0,180]){
                    Vent();
                }
            }
        }
        
        // Vents
        for(i=[2:10]){
            translate([(WIDTH/2) - (WIDTH*.80)/2, (OUTER_WALL*4)*i, -1]){
                cube([WIDTH*.75, 3, OUTER_WALL+2]);
            }
        }
    }
}

//Case_top();