// based on modified version of the script originally found here:
// http://www.thingiverse.com/thing:58408/#files
// ndie.scad - by bwarne

include <write/Write.scad>

SIDES = 16;
//in mm
HEIGHT = 50;
//percent
FACE_DEPTH = 40;//[0:100]
//percent
FONT_DEPTH = 30;//[0:100]
//in mm
FONT_SIZE = 14;
//style
FONT = "write/orbitron.dxf"; //["write/Letters.dxf":Standard,"write/orbitron.dxf":Orbitron,"write/knewave.dxf":Knewave,"write/BlackRose.dxf":BlackRose,"write/braille.dxf":Braille]
RESOLUTION = 150; //[100:Low,250:Medium,400:High]

// radius of sphere
RADIUS = HEIGHT/2;

// approx depth of arc on sphere
SAGITTA_MAX = RADIUS-RADIUS*sin(90 - acos(1-2/SIDES));

// dot product of vector with z unit vector
function dot_z(x,y,z) = acos(z/sqrt(x*x + y*y + z*z));

// cross product of vector with z unit vector
function cross_z(x,y,z) = [y,-x,0];

// convert integer to hex representation
hex_values = ["A", "B", "C", "D", "E", "F"];
function to_hex(w) = (w < 10 ? str(w) : hex_values[w - 10]);

/*
 * Wrapper for write that will disambiguate strings with only sixes or nines
 * by underlining the entire string
 */
module safe_write(word, t, h, center, font) {
	write(to_hex(word), t=t, h=h, center=true, font=FONT);
	
	// if string is 6 or 9 we need to tell the user which way up it goes
	if (word == 6 || word == 9) {
		translate([0,-6.5*h/10,-1]) cube(size = 2, center = true);
	}
}


/*
 * Face number pair
 */
module face_pair(n, radius, face_depth, font_depth)
{
	translate([0,0,-2*(radius-face_depth)]) 
	{
		cube(2*radius, center=true);
	}
	translate([0,0,radius-font_depth/2]) 
	{
		safe_write(n, t=font_depth, h=FONT_SIZE, center=true, font=FONT);
	}
}

module make_die(radius, face_depth, font_depth, resolution)
{
	difference() 
	{
		sphere(radius, $fn=resolution);

		face_pair(1, radius, face_depth, font_depth);
		rotate(90, [1, 0, 0]) face_pair(4, radius, face_depth, font_depth);
		rotate(180, [1, 0, 0]) face_pair(3, radius, face_depth, font_depth);
		rotate(270, [1, 0, 0]) face_pair(2, radius, face_depth, font_depth);

		rotate(45, [1,0,0]) rotate(25, [0,1,0]) face_pair(6, radius, face_depth, font_depth);
		rotate(135, [1,0,0]) rotate(-25, [0,1,0]) face_pair(8, radius, face_depth, font_depth);
		rotate(225, [1,0,0]) rotate(25, [0,1,0]) face_pair(9, radius, face_depth, font_depth);
		rotate(315, [1,0,0]) rotate(-25, [0,1,0]) face_pair(12, radius, face_depth, font_depth);

		rotate(45, [1,0,0]) rotate(-25, [0,1,0]) face_pair(10, radius, face_depth, font_depth);
		rotate(135, [1,0,0]) rotate(25, [0,1,0]) face_pair(15, radius, face_depth, font_depth);
		rotate(225, [1,0,0]) rotate(-25, [0,1,0]) face_pair(7, radius, face_depth, font_depth);
		rotate(315, [1,0,0]) rotate(25, [0,1,0]) face_pair(0, radius, face_depth, font_depth);

		rotate(90, [1,0,0]) rotate(65, [0, 1, 0]) face_pair(11, radius, face_depth, font_depth);
		rotate(90, [1,0,0]) rotate(-65, [0, 1, 0]) face_pair(13, radius, face_depth, font_depth);
		rotate(-90, [1,0,0]) rotate(65, [0, 1, 0]) face_pair(14, radius, face_depth, font_depth);
		rotate(-90, [1,0,0]) rotate(-65, [0, 1, 0]) face_pair(5, radius, face_depth, font_depth);

	}
}

make_die(RADIUS, FACE_DEPTH/100 * SAGITTA_MAX, FONT_DEPTH/25 * SAGITTA_MAX, RESOLUTION);
