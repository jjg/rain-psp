module Display_bezel(){
    
    WIDTH = 150;
    DEPTH = 243;//233;//210;
    HEIGHT = 30;
    OUTER_WALL = 5;
    HINGE_BOLT_SHAFT_DIAMETER = 5;
    
    LCD_WIDTH = 106.96;
    LCD_DEPTH = 164.9;
    LCD_MOUNT_WIDTH = 124.27;
    
    // LCD mounting tab is 8mm wide, hole is 5mm center above/below screen itself.
    
    difference(){
        //cube([WIDTH+2,DEPTH-(OUTER_WALL*2),HEIGHT+OUTER_WALL]);
        cube([WIDTH+2,DEPTH-(OUTER_WALL*2),3]);
        
        // LCD hole
        translate([WIDTH-LCD_MOUNT_WIDTH,((DEPTH-(OUTER_WALL*2))/2)-(LCD_DEPTH/2),0]){
            cube([LCD_WIDTH,LCD_DEPTH,3]);
            
            // Mounting holes
            translate([-5,4,0]){
                cylinder(r=3/2,h=3);
            }
            
            translate([LCD_WIDTH+5,4,0]){
                cylinder(r=3/2,h=3);
            }
            
            translate([LCD_WIDTH+5,LCD_DEPTH-4,0]){
                cylinder(r=3/2,h=3);
            }
            
            translate([-5,LCD_DEPTH-4,0]){
                cylinder(r=3/2,h=3);
            }
        }               
    }
}

Display_bezel();