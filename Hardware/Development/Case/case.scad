include <MCAD/units.scad>
include <MCAD/metric_fastners.scad>


Acrylic = [1,1,1,0.5];


module case_top(top_x, top_y, top_z) {
  translate([-top_x/2,-top_y/2,0]) color(Acrylic)
    cube([top_x,top_y,top_z]);
}


module case_side(side_x, side_y, side_z, foot_width=0, foot_height=0, hole_height=0) {

  diff_x = 2*side_x;
  diff_y = (side_y-2*foot_width)+2*epsilon;
  diff_z = foot_height+10*epsilon;

  //rotate([0,-90,0])
  translate([0,-side_y/2,-(side_z+foot_height)/2]) {
    difference() {
      translate([0,0,-foot_z])
        color(Acrylic) cube([side_x,side_y,side_z+foot_height]);

      if(foot_height) {
	     translate([-side_x/2,(side_y-diff_y)/2,-10*epsilon-(foot_height-hole_height)]) {
           difference() {
             cube([diff_x, diff_y, diff_z]);

             translate([0, 0, foot_height-hole_height])
               rotate([60,0,0])
                 cube([diff_x,diff_y/2,diff_z]);

             translate([0, 0, foot_height-hole_height])
               translate([0, diff_y, 0]) rotate([-60,0,0])
                 translate([0, -diff_y/2, 0])
                   cube([diff_x,diff_y/2,diff_z]);
           }
         }
	  }
    }
  }
}


module case_assembled(inner_x=310, inner_y=240, inner_z=320, thick=5, base_thick=15, foot_width=30,foot_height=90, hole_height=40) {

  translate([0,0,-base_thick]) {
    //top
    translate([0,0,inner_z])
      case_top(top_x=inner_x+2*thick, top_y=inner_y+2*thick, top_z=thick);

    //front
    translate([0,inner_y/2,0]) rotate([0,0,90])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_x+2*thick, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);

    //back
    translate([0,-inner_y/2-thick,0]) rotate([0,0,90])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_x+2*thick, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);

    //left
    translate([inner_x/2,0,0])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_y, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);

    //right
    translate([-inner_x/2-thick,0,0])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_y, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);
  }
}


case_assembled(inner_x=310, inner_y=240, inner_z=300, thick=5, base_thick=15);

