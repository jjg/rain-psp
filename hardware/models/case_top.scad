module Case_top(){
    
    WIDTH = 150;
    DEPTH = 210;
    HEIGHT = 30;
    OUTER_WALL = 5;
    
    difference(){
        
        // Main box
        cube([WIDTH, DEPTH, HEIGHT]);
        
        // Cut-away for display
        translate([WIDTH-20,0,0]){
            rotate([0,30,0]){
                cube([HEIGHT, DEPTH, HEIGHT+20]);
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

Case_top();