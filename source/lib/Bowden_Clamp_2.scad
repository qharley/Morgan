//******************* OTHER FILES NEEDED **************************************

use <MCAD/boxes.scad>
use <knurledFinishLib.scad>
use <polyScrewThread.scad>


//*****************************************************************************
//******************* VARIABLES TO ADJUST *************************************

baseWidth = 48; //leave
baseCornerRadius = 3.5; //leave
outsideHolesFromCentre = 20.5; //distance in x or y not vector
insideHolesFromCentre = 11; //distance in x or y not vector
outsideHolesRadius = 1.5;
oHR_Allow = 0.75; //adjustment for above for clearance. Printers put too much inside holes usually
baseHeight = 6; //6 is good
centreToInsideBase = 7;
baseLegWidth = 9;
fanSideBaseHeight = 6; //No less than 2 but preferably more. Need short to fit nut on fan below
tubeRadius = 2;		// Tube Radius...
tR_Allow = 0.8; //adjustment for above for clearance. Printers put too much inside holes usually
threadLength = 20;
tubeBottom = 16;
tighteningConeTopRadius = 4.7;
tighteningConeHeight = 10;
topOfTighteningConeHeight = 3;
tighteningConeOpening = 1.7;
tighteningConeInnerRatio = 0.9; //Ratio to Width of Bowden tube. 0.9 works good
riserTubeRadius = 7.5;
riserTubeSkirt = 1; // leave at 1
capInsideDiameter = 16; // usually double riserTubeRadius + 1 (Use capTest(); first if not sure)
capHeight = 24;
capTopThickness = 4;
capOuterDiameter = 24.5;


//*****************************************************************************
//******************* OTHER VARIABLES *****************************************

$fn = 36;
stlClearance = 0.02; //Used to make edges to overlap by a small amount to prevent errors in the STL output
PI=3.141592;
tubeCentre = [insideHolesFromCentre,-insideHolesFromCentre, -stlClearance];


//*****************************************************************************
//******************* VIEWING ****************************************************



//explodedView(); // Hit F6 for good view. Takes a while on my i7. F5 = not good.


//*****************************************************************************
//******************* PRINTING ****************************************************

//baseAndRiser();
riserTube(2);

//tighteningCone();

//cap();

//capTest(); // Makes a 4mm High Cap with no top to test thread for fit on riser. Uses capInsideDiameter same as cap

//*****************************************************************************
//************************** MODULES ******************************************

module explodedView(){

    baseAndRiser();

    translate (tubeCentre)
        translate ([0,0, baseHeight + tubeBottom + threadLength + 5 + tighteningConeHeight + topOfTighteningConeHeight])
            rotate([180,0,0])tighteningCone();

    translate (tubeCentre)
        translate ([0,0, baseHeight + tubeBottom + threadLength + 5 + tighteningConeHeight + topOfTighteningConeHeight + 5 + capHeight])
            rotate([180,0,0])cap();
}


module baseAndRiser(){
    difference(){
        union(){
            base();
            riserTube();
        }
            translate(tubeCentre) passThroughTube();
    }
}


module base(){
    difference(){
        union(){
            difference(){
                translate([0, 0, baseHeight / 2])roundedBox([baseWidth,baseWidth,baseHeight],baseCornerRadius,true);
                    rotate ([0,0,45])
                        translate ([-baseWidth,-centreToInsideBase, -baseHeight / 2])
                            cube([2 * baseWidth, baseWidth, 2 * baseHeight]);
            }
            translate ([0,-baseWidth / 2 + baseLegWidth / 2, fanSideBaseHeight / 2])
                roundedBox([baseWidth, baseLegWidth, fanSideBaseHeight],baseCornerRadius,true);
            translate ([baseCornerRadius,-baseWidth / 2 + baseLegWidth / 2, baseHeight / 2])
                roundedBox([baseWidth - baseCornerRadius * 2, baseLegWidth, baseHeight],baseCornerRadius,true);
            translate ([baseWidth / 2 - baseLegWidth / 2, 0, baseHeight / 2])
                roundedBox([baseLegWidth, baseWidth, baseHeight],baseCornerRadius,true);
        }
            translate ([outsideHolesFromCentre,outsideHolesFromCentre,-1])
                cylinder(r = outsideHolesRadius + oHR_Allow, h = baseHeight * 2);
            translate ([outsideHolesFromCentre,-outsideHolesFromCentre,-1])
                cylinder(r = outsideHolesRadius + oHR_Allow, h = baseHeight * 2);
            translate ([-outsideHolesFromCentre,-outsideHolesFromCentre,-1])
                cylinder(r = outsideHolesRadius + oHR_Allow, h = baseHeight * 2);
    }
}

//difference(){    translate (-tubeCentre)riserTube();passThroughTube();}
module riserTube(tubeRadius){
    translate (tubeCentre)
        translate ([0,0,baseHeight])
        difference(){
            union(){
                cylinder(r = riserTubeRadius, h = tubeBottom + stlClearance);
                cylinder(r1 = riserTubeRadius + riserTubeSkirt, r2 = riserTubeRadius, h = riserTubeSkirt + stlClearance);  //riserTubeSkirt
                translate([0,0,tubeBottom])Makerbolt();
            }
                translate ([0,0,tubeBottom])
                    #cylinder(r1 = tubeRadius + tR_Allow, r2 = tighteningConeTopRadius, h = threadLength + stlClearance);
						cylinder(r = tubeRadius + tR_Allow, h=100);
        }
}


module tighteningCone(tubeRadius){
    rotate ([180,0,-45])
        translate ([0,0,-threadLength - topOfTighteningConeHeight])
        difference(){
            union(){
                cylinder(r1 = tubeRadius + tR_Allow, r2 = tighteningConeTopRadius, h = threadLength);
                translate([0,0,threadLength - stlClearance]) cylinder(r = tighteningConeTopRadius, h = topOfTighteningConeHeight);
            }
                translate ([0,0, - stlClearance])
                    cylinder(r = tighteningConeTopRadius + 1, h = threadLength - tighteningConeHeight);
                #translate([0,0,-1])cylinder(r=(tubeRadius + tR_Allow) * tighteningConeInnerRatio, h = 70);
                translate([0, -tighteningConeOpening / 2,0]) cube([riserTubeRadius * 2, tighteningConeOpening, threadLength * 2]);
        }
    }


module cap(){
    translate ([0,0,capHeight])
    rotate ([180,0,0])
        union(){
            nut_4_Makerbolt();
            difference(){
                translate ([0,0,capHeight - capTopThickness])
                    cylinder(r = capInsideDiameter / 2 + 1, h = capTopThickness);
                        passThroughTube();
            }
        }
}


module passThroughTube(){
    cylinder(r=tubeRadius + tR_Allow, h = 70);
}


//*****************************************************************************
//************************** BORROWED MODULES *********************************

// Thanks http://www.thingiverse.com/thing:9095

module Makerbolt() {
    /* Bolt parameters.
    *
    * Just how thick is the head.
    * The other parameters, common to bolt and nut, are defined into k_cyl() module
    */
    b_hg=0; //distance of knurled head
    
    /* Screw thread parameters
    */
    t_od=riserTubeRadius * 2; // Thread outer diameter
    t_st=2.5; // Step/traveling per turn
    t_lf=55; // Step angle degrees
    t_ln=threadLength; // Length of the threade section
    t_rs=PI/2; // Resolution
    t_se=1; // Thread ends style
    t_gp=0; // Gap between nut and bolt threads
    
    
    translate([0,0,b_hg])screw_thread(t_od+t_gp, t_st, t_lf, t_ln, t_rs, t_se);
}

/* Knurled cylinder module used in both: Makerbolt() and Makerbolt_nut() modules
*/
module k_cyl(bnhg)
{
/* Bolt/Nut parameters
*/
k_cyl_hg=bnhg; // Knurled cylinder height
k_cyl_od=22.5; // Knurled cylinder outer* diameter

knurl_wd=3; // Knurl polyhedron width
knurl_hg=4; // Knurl polyhedron height
knurl_dp=1.5; // Knurl polyhedron depth

e_smooth=1; // Cylinder ends smoothed height
s_smooth=0; // [ 0% - 100% ] Knurled surface smoothing amount

knurled_cyl(k_cyl_hg, k_cyl_od,
knurl_wd, knurl_hg, knurl_dp,
e_smooth, s_smooth);
}


/* ****************************************************************************** */
/* Example 03.
 *
 * Just a knurled nut.
 * (Because we needed something where we can use Example 02...)
 */
module nut_4_Makerbolt()
{
 /* Nut parameters.
  */
    n_df=25;    // Distance between flats
    n_hg=capHeight;    // Thickness/Height
    n_od=capInsideDiameter;    // Outer diameter of the bolt to match
    n_st=2.5;   // Step height
    n_lf=55;    // Step Degrees
    n_rs=0.5;   // Resolution
    n_gp=0.07;   // Gap between nut and bolt


    intersection()
    {
        hex_nut(n_df, n_hg, n_st, n_lf, n_od + n_gp, n_rs);

        k_cyl(n_hg);
    }
}

module capTest()
{
 /* Nut parameters.
  */
    n_df=25;    // Distance between flats
    n_hg=4;    // 4mm High
    n_od=capInsideDiameter;    // Outer diameter of the bolt to match
    n_st=2.5;   // Step height
    n_lf=55;    // Step Degrees
    n_rs=0.5;   // Resolution
    n_gp=0.07;   // Gap between nut and bolt


    intersection()
    {
        hex_nut(n_df, n_hg, n_st, n_lf, n_od + n_gp, n_rs);

       // k_cyl(n_hg);
    }
}


/* ****************************************************************************** */
/* Knurled cylinder module used in both: Makerbolt() and Makerbolt_nut() modules
 */
module k_cyl(bnhg)
{
 /* Bolt/Nut parameters
  */
    k_cyl_hg=bnhg;   // Knurled cylinder height
    k_cyl_od = capOuterDiameter; // was 22.5;   // Knurled cylinder outer* diameter

    knurl_wd=3;      // Knurl polyhedron width
    knurl_hg=4;      // Knurl polyhedron height
    knurl_dp=1.5;    // Knurl polyhedron depth

    e_smooth=1;      // Cylinder ends smoothed height
    s_smooth=0;      // [ 0% - 100% ] Knurled surface smoothing amount

    knurled_cyl(k_cyl_hg, k_cyl_od,
                knurl_wd, knurl_hg, knurl_dp,
                e_smooth, s_smooth);
}


//********************** END MODULES ******************************************

