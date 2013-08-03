
// Morgan SCARA Calibration phantom

use <Write.scad>;

Linkage = 150;	//	Arm segment nominal length (as programmed in Firmware)

xoffset = -35;	// Scara tower offset
yoffset = -65;

K1 = 0;
K2 = 0;

theta = 0;
psi = 0;

xpos = 125.27;
ypos = 82.5;

cal_angle = 33.367;

arm_width = 6;
arm_height = 4;



//projection(cut = false)
	SCARAcal();

$fn=100;

module SCARAcal(){


	intersection(){
		translate([-xpos,ypos+yoffset,0])
			difference(){
				cylinder(r=Linkage + 3, h=arm_height);
				cylinder(r=Linkage - 3, h=arm_height);
	
			}
		translate([-xpos,ypos+yoffset,0])
		rotate([0,0,cal_angle])
			translate([100,-50,0])
				cube([100,100,arm_height]);
	}

	intersection(){
		translate([xpos,ypos+yoffset,0])
			difference(){
				cylinder(r=Linkage + arm_width/2, h=arm_height);
				cylinder(r=Linkage - arm_width/2, h=arm_height);
	
			}
		translate([xpos,ypos+yoffset,0])
		rotate([0,0,180-cal_angle])
			translate([100,-50,0])
				cube([100,100,arm_height]);
	}

	translate([0,100,arm_height/2]){
		cube([100,arm_width,arm_height],center=true);
		cube([arm_width,100,arm_height],center=true);
	}

	translate([16,70,arm_height])
		#write("Theta",t=2,h=7,rotate=72,center=true);

	translate([-16,70,arm_height])
		#write("Psi",t=2,h=7,rotate=-72,center=true);

	translate([0,130,arm_height])
		#write("Y",t=2,h=7,rotate=0,center=true);

	translate([-30,100,arm_height])
		#write("X",t=2,h=7,rotate=90,center=true);

	translate([0,101,arm_height])
		#write("Morgan",t=2,h=7,rotate=0,center=true);
	
}