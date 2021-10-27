include <modules/clusterboard.scad>
include <modules/pinea64.scad>
include <modules/keyboard.scad>
include <modules/vent.scad>
include <modules/fan.scad>

include <case_bottom.scad>
include <case_top.scad>
include <display_top.scad>
include <control_panel.scad>


// TODO: Rename these variables to avoid confusion.
BASE_WIDTH = 300;
BASE_DEPTH = 243; //233;//210;
BASE_HEIGHT = 5;
BOTTOM_HEIGHT = 30; // TODO: Measure this.
OUTER_WALL = 5;

difference(){
    union(){
        
        color("black")
        Case_bottom();

        // Add fans
        color("blue")
        translate([OUTER_WALL,BASE_DEPTH-OUTER_WALL-17,BASE_HEIGHT]){
            Fan();
            translate([40+5,0,0]){
                Fan();
                translate([40+5,0,0]){
                    Fan();
                }
            }
        }
        
        // Add clusterboard
        translate([OUTER_WALL,BASE_DEPTH-170-20-OUTER_WALL,BASE_HEIGHT]){
            rotate([0,0,0]){
                color("green")
                Clusterboard();
            }
        }
        
        // TODO: Add Raspberry Pi Zero

        /*
        // Add A64
        translate([BASE_WIDTH-20, 68, BASE_HEIGHT]){
            rotate([0,0,90]){
                color("blue")
                PINEA64();
            }
        }
        */

        // Add keyboard
        translate([BASE_WIDTH-40-3, 121, 21.5]){
            rotate([5,0,90]){
                color("red")
                //Keyboard();
                import("reference/planckplate_v2_tab_fix.stl");
            }
        }
        
        // Add control panel
        translate([(BASE_WIDTH/2)+(BOTTOM_HEIGHT/2), BASE_DEPTH-OUTER_WALL, BOTTOM_HEIGHT]){
            rotate([180,0,0]){
                color("red")
                Control_panel();
            }
        }
        
        // Add case top
        translate([0,BASE_DEPTH,BOTTOM_HEIGHT+30]){
            rotate([180,0,0]){
                color("red")
                Case_top();
            }
        }
        
        
        // Add display top
        /*
        // closed
        translate([BASE_WIDTH/2,BASE_DEPTH,BOTTOM_HEIGHT*2]){
            rotate([180,0,0]){
                color("pink")
                Display_top();
            }
        }
        */
        
        // open
        translate([137,BASE_DEPTH,38]){
            rotate([180,-120,0]){
                color("red")
                Display_top();
            }
        }
        
        /*
        // 90 degrees
        translate([135,BASE_DEPTH,45]){
            rotate([180,-90,0]){
                color("pink")
                Display_top();
            }
        }
        */
    }
    
    // Cross-section
    translate([-1,-1,-1]){
        //cube([310,100,200]);
    }
}
