module gusset(width, height, thickness){
    linear_extrude(thickness){
        polygon(points=[[0,0],[0,height],[width,0], [0,0]]);
    }
}

//gusset(10,10,2.5);