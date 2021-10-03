include <modules/clusterboard.scad>
include <modules/pinea64.scad>
include <modules/keyboard.scad>

include <case_bottom.scad>
include <case_top.scad>
include <display_top.scad>


// TODO: Rename these variables to avoid confusion.
BASE_WIDTH = 300;
BASE_DEPTH = 233;//210;
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
        translate([BASE_WIDTH/2,BASE_DEPTH,BOTTOM_HEIGHT]){
            rotate([180,-120,0]){
                color("pink")
                Display_top();
            }
        }
    }
    
    // Cross-section
    translate([-1,-1,-1]){
        //cube([310,100,200]);
    }
}
