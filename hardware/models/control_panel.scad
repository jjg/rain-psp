module Control_panel(){
    
    WIDTH = 47;
    DEPTH = 232.82;
    HEIGHT = 30;
    BASE_HEIGHT = 5;
    OUTER_WALL = 5;
    BUTTON_COUNT = 7;
    BUTTON_DIAMETER = 13;
    
    difference(){
        cube([WIDTH,DEPTH,HEIGHT-BASE_HEIGHT]);
        
        // cutout
        translate([0,OUTER_WALL,BASE_HEIGHT]){
            cube([WIDTH,DEPTH-(OUTER_WALL*2),HEIGHT]);
        }
        
        // power control holes
        translate([0,(BUTTON_DIAMETER/2)+5,-1]){
            for(x=[0:BUTTON_COUNT]){
                translate([(WIDTH/2),x*19,0]){
                    cylinder(r=BUTTON_DIAMETER/2,h=BASE_HEIGHT*2);
                }
            }
        }
    }
}

//Control_panel();