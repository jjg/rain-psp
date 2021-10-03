module Case_top(){
    
    WIDTH = 149;
    DEPTH = 233;//210;
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
                cylinder(r=HEIGHT/2,h=OUTER_WALL);
            }
        }
        translate([WIDTH,DEPTH-OUTER_WALL,HEIGHT/2]){
            rotate([-90,0,0]){
                cylinder(r=HEIGHT/2,h=OUTER_WALL);
            }
        }
        
        // Make room for electronics
        translate([OUTER_WALL, OUTER_WALL, OUTER_WALL]){
            cube([WIDTH,DEPTH-(OUTER_WALL*2),HEIGHT+OUTER_WALL]);
        }
        
        // Vents
        for(i=[1:9]){
            translate([(WIDTH/2) - (WIDTH*.80)/2, (OUTER_WALL*4)*i, -1]){
                cube([WIDTH*.75, 3, OUTER_WALL+2]);
            }
        }
    }
}

//Case_top();