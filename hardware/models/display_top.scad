module Display_top(){
    
    WIDTH = 150;
    DEPTH = 243;//233;//210;
    HEIGHT = 30;
    OUTER_WALL = 5;
    HINGE_BOLT_SHAFT_DIAMETER = 5;

    difference(){
        union(){
            difference(){
                
                // Main box
                cube([WIDTH, DEPTH, HEIGHT]);
                
                // Make room for electronics
                translate([-OUTER_WALL, OUTER_WALL, OUTER_WALL]){
                    cube([WIDTH,DEPTH-(OUTER_WALL*2),HEIGHT+OUTER_WALL]);
                }
                
                // Opening for case top
                translate([0,OUTER_WALL,0]){
                    //#cube([26,DEPTH-(OUTER_WALL*2), OUTER_WALL]);
                    cube([20,DEPTH-(OUTER_WALL*2), OUTER_WALL]);
                }
            }
            
            // Hinge
            translate([0,0,HEIGHT/2]){
                rotate([-90,0,0]){
                    cylinder(r=HEIGHT/2,h=OUTER_WALL);
                }
            }
            translate([0,DEPTH-OUTER_WALL,HEIGHT/2]){
                rotate([-90,0,0]){
                    cylinder(r=HEIGHT/2,h=OUTER_WALL);
                }
            }   
        } 
        
        // Holes for hinge bolts
        translate([0,0,HEIGHT/2]){
            rotate([-90,0,0]){
                cylinder(r=HINGE_BOLT_SHAFT_DIAMETER/2,h=OUTER_WALL);
            }
        }
        translate([0,DEPTH-OUTER_WALL,HEIGHT/2]){
            rotate([-90,0,0]){
                cylinder(r=HINGE_BOLT_SHAFT_DIAMETER/2,h=OUTER_WALL);
            }
        } 
    }
}

Display_top();