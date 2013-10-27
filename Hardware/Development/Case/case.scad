include <MCAD/units.scad>
include <MCAD/materials.scad>
include <MCAD/metric_fastners.scad>
include <MCAD/nuts_and_bolts.scad>


Acrylic = [1,1,1,0.2];


module case_top(top_x, top_y, top_z) {
  translate([-top_x/2,-top_y/2,0]) color(Acrylic)
    cube([top_x,top_y,top_z]);
}


module case_side(side_x, side_y, side_z, foot_width=0, foot_height=0, hole_height=0) {

  diff_x = 2*side_x;
  diff_y = (side_y-2*foot_width)+2*epsilon;
  diff_z = foot_height+10*epsilon;

  translate([0,-side_y/2,-(side_z+foot_height)/2]) {
    difference() {
      translate([0,0,-foot_z])
        color(Acrylic) cube([side_x,side_y,side_z+foot_height]);

      if(foot_height) {
	     translate([-side_x/2,(side_y-diff_y)/2,-10*epsilon-(foot_height-hole_height)]) {
           difference() {
             cube([diff_x, diff_y, diff_z]);


             translate([-diff_x/2, 0, foot_height-hole_height])
               rotate([60,0,0])
                 cube([diff_x*2,diff_y/2,diff_z]);

             translate([0, 0, foot_height-hole_height])
               translate([0, diff_y, 0]) rotate([-60,0,0])
                 translate([-diff_x/2, -diff_y/2, 0])
                   cube([diff_x*2,diff_y/2,diff_z]);
           }
         }
	  }
    }
  }
}

//case_side(side_x=5, side_y=320, side_z=240, foot_width=30, foot_height=90, hole_height=30);

module case_mount(size=70, thick=8, nut_size=6, with_extra_parts=false, exploded=false) {

  screw_pos = size/2.5;

  rotate([0,0,45]) rotate([0,10,0])
  difference() {
    rotate([0,-10,0]) rotate([0,0,-45])
     difference() {
       cube(size);

       translate([thick, thick, thick])
        cube(size*2);

       //screw holes
       translate([screw_pos,screw_pos,-screw_pos])
         cylinder(r=(nut_size+2)/2, h=10*thick);
       translate([screw_pos,screw_pos,screw_pos])
         rotate([90,0,0])
          cylinder(r=(nut_size+2)/2, h=10*thick);
       translate([-screw_pos,screw_pos,screw_pos])
         rotate([0,90,0])
           cylinder(r=(nut_size+2)/2, h=10*thick);

       translate([size/2+size*2/3,0,0])
         cube(size, center=true);
       translate([0,size/2+size*2/3,0])
         cube(size, center=true);
       translate([0,0,size/2+size*2/3])
         cube(size, center=true);
     }

     rotate([0,-45,0])
       translate([size*2+size/sqrt(2.3),0,0])
         cube(size*4, center=true);

  }


  if(with_extra_parts)
    case_mount_extras(exploded_distance=(exploded?40:0));

  module case_mount_extras(exploded_distance=0) {
    translate([screw_pos,screw_pos,thick+exploded_distance]) {
      color(Steel) washer(nut_size);
      translate([0,0,0.1*nut_size+nut_size*0.8+exploded_distance]) rotate([180,0,0])
        color(Steel) flat_nut(nut_size);
    }

    translate([thick+exploded_distance,screw_pos,screw_pos]) {
      color(Steel) rotate([0,90,0]) washer(nut_size);
      translate([0.1*nut_size+nut_size*0.8+exploded_distance,0,0]) rotate([0,-90,0])
        color(Steel) flat_nut(nut_size);
    }

    translate([screw_pos,thick+exploded_distance,screw_pos]) {
      color(Steel) rotate([-90,0,0]) washer(nut_size);
      translate([0,0.1*nut_size+nut_size*0.8+exploded_distance,0]) rotate([90,0,0])
        color(Steel) flat_nut(nut_size);
    }
  }
}

//case_mount();

module case_assembled(inner_x=310, inner_y=240, inner_z=320, thick=5, base_thick=15, foot_width=30,foot_height=90, hole_height=40, with_extra_parts=false, exploded=false) {

  exploded_distance = exploded ? 100:0;

  translate([0,0,-base_thick]) {
    //top
    translate([0,0,inner_z+0.5*exploded_distance])
      case_top(top_x=inner_x+2*thick, top_y=inner_y+2*thick, top_z=thick);

    //front
    translate([0,inner_y/2+1.5*exploded_distance,0]) rotate([0,0,90])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_x+2*thick, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);

    //back
    translate([0,-inner_y/2-thick-1.5*exploded_distance,0]) rotate([0,0,90])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_x+2*thick, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);

    //left
    translate([inner_x/2+0.5*exploded_distance,0,0])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_y, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);

    //right
    translate([-inner_x/2-thick-0.5*exploded_distance,0,0])
      translate([0,0,(inner_z+foot_height)/2-foot_height])
        case_side(side_x=thick, side_y=inner_y, side_z=inner_z, foot_width=foot_width, foot_height=foot_height, hole_height=hole_height);
  }

  //4 case_mounts for holding top
  translate([-inner_x/2,inner_y/2+exploded_distance,inner_z-base_thick])
    rotate([180,0,0])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);

  translate([-inner_x/2,-inner_y/2-exploded_distance,inner_z-base_thick])
    rotate([180,0,90])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);

  translate([inner_x/2,-inner_y/2-exploded_distance,inner_z-base_thick])
    rotate([180,0,180])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);

  translate([inner_x/2,inner_y/2+exploded_distance,inner_z-base_thick])
    rotate([180,0,270])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);

  //4 case_mounts for holding machine base
  translate([-inner_x/2,inner_y/2+exploded_distance,-base_thick])
    rotate([180,0,0])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);

  translate([-inner_x/2,-inner_y/2-exploded_distance,-base_thick])
    rotate([180,0,90])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);

  translate([inner_x/2,-inner_y/2-exploded_distance,-base_thick])
    rotate([180,0,180])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);

  translate([inner_x/2,inner_y/2+exploded_distance,-base_thick])
    rotate([180,0,270])
      case_mount(with_extra_parts=with_extra_parts, exploded=exploded);
}


//case_assembled(inner_x=310, inner_y=240, inner_z=315, thick=8, base_thick=15);

