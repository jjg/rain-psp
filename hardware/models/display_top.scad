module Display_top(){
    
    WIDTH = 150;
    DEPTH = 233;//210;
    HEIGHT = 30;
    OUTER_WALL = 5;
    
    difference(){
        
        // Main box
        cube([WIDTH, DEPTH, HEIGHT]);
        
        // Make room for electronics
        translate([-OUTER_WALL, OUTER_WALL, OUTER_WALL]){
            cube([WIDTH,DEPTH-(OUTER_WALL*2),HEIGHT+OUTER_WALL]);
        }
        
        /*
        // Vents
        for(i=[1:9]){
            translate([(WIDTH/2) - (WIDTH*.75)/2, (OUTER_WALL*4)*i, -1]){
                cube([WIDTH*.75, 3, OUTER_WALL+2]);
            }
        }
        */
    }
}