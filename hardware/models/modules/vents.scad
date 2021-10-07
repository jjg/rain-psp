module Vents(){
    //difference(){
    //cylinder(r=40/1,h=5);
    scale([.25,.25,2])
    linear_extrude(height = 5, center = true, convexity = 10)
        import("vent.svg");
    //}
}

Vents();