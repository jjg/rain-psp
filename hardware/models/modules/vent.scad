// NOTE: This is kind of messy because the vent.svg file is in two locations
// because the module will look for the relative path based on where the
// module is invoked.  So when we invoke it here, it looks in the "modules"
// directory but when it's invoked in assembly.scad it looks in the "models"
// directory.  Maybe OpenSCAD has a smart way to do this but I don't know
// what it is yet.

module Vent(){
    translate([0,-30,0])
    rotate([0,0,45])
    scale([.5,.5,2])
    linear_extrude(height = 5, center = true, convexity = 10)
        import("vent.svg");
}

//Vent();