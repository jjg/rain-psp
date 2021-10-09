include <modules/clusterboard.scad>
include <modules/pinea64.scad>
include <modules/keyboard.scad>
include <modules/vent.scad>

include <case_bottom.scad>
include <case_top.scad>
include <display_top.scad>


// TODO: Rename these variables to avoid confusion.
BASE_WIDTH = 300;
BASE_DEPTH = 243; //233;//210;
BASE_HEIGHT = 5;
BOTTOM_HEIGHT = 30; // TODO: Measure this.
OUTER_WALL = 5;

difference(){
    union(){
        
        Case_bottom();

        // Add clusterboard
        translate([20,10,BASE_HEIGHT]){
            color("red")
            Clusterboard();
        }

        // Add A64
        translate([BASE_WIDTH-20, 68, BASE_HEIGHT]){
            rotate([0,0,90]){
                color("blue")
                PINEA64();
            }
        }

        // Add keyboard
        translate([BASE_WIDTH-3, -3, 21.5]){
            rotate([5,0,90]){
                color("green")
                //Keyboard();
                import("planck_plate.stl");
            }
        }

        // Add case top
        translate([0,BASE_DEPTH,BOTTOM_HEIGHT+30]){
            rotate([180,0,0]){
                color("orange")
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
        /*
        translate([137,BASE_DEPTH,38]){
            rotate([180,-120,0]){
                color("pink")
                Display_top();
            }
        }
        */
        // 90 degrees
        translate([135,BASE_DEPTH,45]){
            rotate([180,-90,0]){
                color("pink")
                Display_top();
            }
        }
        
    }
    
    // Vents
    // NOTE: These are roughly-equally spaced across the back.
    // The will need to be moved to the bottom plate (when the 
    // bottom plate is expanded to provide the entire back-side
    // of the case).  They may also be biased to one side or
    // another depending on optimal fan placement.
    /*
    translate([0,58,30]){
        rotate([90,0,-90]){
            Vent();
        }
    }
    translate([0,116,30]){
        rotate([90,0,-90]){
            Vent();
        }
    }
    translate([0,174,30]){
        rotate([90,0,-90]){
            Vent();
        }
    }
    */
    
    // Cross-section
    translate([-1,-1,-1]){
        //cube([310,100,200]);
    }
}
