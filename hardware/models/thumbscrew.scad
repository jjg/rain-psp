module Thumbscrew(){
    
    HEIGHT = 30;
    OUTER_WALL = 5;

    //$fn=30;
    
    difference(){
        cylinder(r=HEIGHT/2,h=OUTER_WALL*2);
        
        // Bolt shaft hole
        translate([0,0,OUTER_WALL-2]){
            resize([0,0,28], auto=true){
                import("modules/18-8 Stainless Steel Hex Head Screws.stl");
            }
        }
        
        // Bolt head opening
        translate([0,0,OUTER_WALL]){
            cylinder(r=4,h=10);
        }
        
        // Bolt thread opening
        cylinder(r=2.5,h=10);
    }
}

Thumbscrew();