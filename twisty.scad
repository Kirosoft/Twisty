o = .001;
flangeWidth=5;
flangeRadius=25;
numLines=6;
flangeSpacing=25-o;
lineRadius=0.5;
lineCenterRadius=flangeRadius-3;
numFlanges=3;
centerHole=10;
totalLength=((numFlanges+1)*flangeSpacing)+flangeWidth;
outerSliderRadius=centerHole-2;
outerSliderWall=2.5;
sliderTolerance=0.5;
innerSliderRadius=outerSliderRadius-outerSliderWall-sliderTolerance;
innerSliderWall=2.5;
keywayWidth = 5;
keywayHeight =5;
keywayTolerance=0.5;

$fn=360;
// TowerPro MG955 Servo dummy
module screwBracket(){
//screwBracket
	difference(){
		union(){
			minkowski(){
				cube([5.25,17,1]);
				translate([1,1,0]) cylinder(h=1.5, d=2);
				}
			cube([5.25,19,2.5]);
			rotate([0,10,0]) translate([-1.4,9,1.7]) cube([8,1,2]);
			}
		//srewHoles
		union() {
			translate([4.25,4.3,-1])  cylinder(h=4, d=4.5);
			translate([4.25,14.8,-1])  cylinder(h=4, d=4.5);	
			translate([5,3,-1]) cube([2.5,2.5,4]);
			translate([5,13.5,-1]) cube([2.5,2.5,4]);
			
			}
		}
}
module TorqueMount(){
// torque mount
		color("Silver"){
			difference(){
				union(){
					translate([0,0,2.7]) cylinder(h=2, d=20);
					cylinder(h=4.7, d=9);				
				}
				translate([0,0,-1])cylinder(h=8, d=4.5);
				translate([7,0,2]) cylinder(h=4,d=3);
				rotate([0,0,90]) translate([7,0,2]) cylinder(h=4,d=3);
				rotate([0,0,180]) translate([7,0,2]) cylinder(h=4,d=3);
				rotate([0,0,270]) translate([7,0,2]) cylinder(h=4,d=3);
			}
		}
}
module WireTerminal(){
		//wireTerminal
	color("DimGray",1){
		translate([40,6.5,4]) cube([5,7,4]);
		}
		color("Red",1){
			translate([40,7.5,5.5]) cube([7,5,1]);
		}


}
module ServoMainPart(x,y,z){
    translate([x,y,z]) {
        
        color("DimGray",1){
            //mainpart
            cube([40.5,20,36.5]);
            translate([40.5,0.5,28]) screwBracket();
            rotate([0,0,180]) translate([0,-19.5,28])  screwBracket();
            translate([10,10,36.5]) cylinder(h=2, d=19);
            translate([10,10,38.5]) cylinder(h=1, d=13);
            translate([10,10,39.5]) cylinder(h=0.5, d=11);
            translate([14,1.5,36.5]) cube([21,17,2]);
            }
            //torqueConnector
            color("Gold",1){
                translate([10,10,40]) cylinder(h=4.5, d=5);
            }
        //silver torque disc
        //translate([10,10,40.5]) TorqueMount();
        //red wire terminal
        rotate([0,0,180]) translate([-42,-20,0]) WireTerminal();
    }
}

module DrawDiscs(x,y,z) 
{
    translate([x,y,z]) {
        color("Blue",1.0) {

            // bottom flange
            difference() {
                cylinder(h = flangeWidth, r = flangeRadius);
                cylinder(h = flangeWidth+10, r = centerHole, center=true);
            }

            for (f = [0:numFlanges]) {
                // draw the lines
                for (i = [0:numLines-1]) {
                    
                    color("Green",1.0) {
                      translate([sin(360*i/numLines)*lineCenterRadius, cos(360*i/numLines)*lineCenterRadius, (f*flangeSpacing)+flangeWidth/2])
                        
                                cylinder(h = flangeSpacing, r=lineRadius);
                     }
                }
                
                // Flanges
                translate([0, 0, (f+1)*flangeSpacing ])

                    difference() {
                         cylinder(h = flangeWidth, r = flangeRadius);

                         if (f < numFlanges) {
                            // normal holes
                            cylinder(h = flangeWidth+10, r = centerHole, center=true);        }
                         else 
                         {
                             //keyway on the last flange
                            union() {
                                // Inner shaft core
                                cylinder(h = totalLength/2, r = innerSliderRadius);
                                // Male poart of keyway
                                translate([-(keywayWidth-keywayTolerance)/2,innerSliderRadius/2, 0]) 
                                    cube([keywayWidth-keywayTolerance,outerSliderRadius-innerSliderRadius/2,totalLength/2]);
                            }
                        }
                        for (j = [0:numLines-1]) {
                            spacing=(360/numLines/2)+(360*j/numLines);
                            translate([sin(spacing)*lineCenterRadius, cos(spacing)*lineCenterRadius, 0])
                        
                                cylinder(h = flangeWidth+10, r=2,center=true);
                        }

                    }
            }
        }
    }
}

module TwistyFlange(x,y,z)
{
    DrawDiscs(x,y,z);
    Slider(x,y,z);
}

module Slider(x,y,z)
{
    translate([x,y,z]) {
        
        color("Orange",1.0) {

            // Outer slider
            translate([x, y, z]);
            difference() {
                // Outerwall with keyway
                difference() {
                    cylinder(h = totalLength/2, r = outerSliderRadius);
                    // Female part of the keyway
                    translate([0,innerSliderRadius,0]) 
                        cube([keywayWidth,outerSliderRadius,totalLength], center=true);
                }
                // Inner bore hole
                cylinder(h = (totalLength)+50, r = outerSliderRadius-outerSliderWall,center=true);
            }
        }
        
        // inner slider
        color("Green",1.0) {
            translate([0, 0, 50]) {
                union() {
                    // Inner shaft core
                    cylinder(h = totalLength/2, r = innerSliderRadius);
                    // Male poart of keyway
                    translate([-(keywayWidth-keywayTolerance)/2,innerSliderRadius/2, 0]) 
                        cube([keywayWidth-keywayTolerance,outerSliderRadius-innerSliderRadius/2,totalLength/2]);
                }
            }    
        }
    }
}


echo(version=version());

TwistyFlange(0,0,41.5);
// END SERVODUMMY
ServoMainPart(-10,-10,0);

