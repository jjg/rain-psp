module Thumbscrew(){
    
    HEIGHT = 30;
    OUTER_WALL = 5;

    difference(){
        //cylinder(r=HEIGHT/2,h=OUTER_WALL*2);
        
        // Bolt shaft hole
        #import("modules/92314A199_18-8 Stainless Steel Hex Head Screws.stl");
        
        // Bolt head
    }
}

Thumbscrew();