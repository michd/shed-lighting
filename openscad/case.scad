// Board size: 86.4mm x 71.2mm x 1.6mm
// Box inner height space: 12mm
// LED hole diameter: 7mm
// top left LED offset: 22.9mm, 7.6mm
// LED distance: 14mm

pcb_width = 86.4;
pcb_height = 71.2;
pcb_thickness = 2.5;
wall_thickness = 1.5;
ridge_width = wall_thickness * 1.5;
inner_height = 12;
led_hole_diameter = 7;
led_spacing = 14;
led_offset_x = 22.9 + wall_thickness;
led_offset_y = 7.6 + wall_thickness;
wire_diameter = 3;
screwhole_diameter = 3;
screwhole_tab_width = screwhole_diameter * 5;

// Modules
//----------------------------------------------------------------------------------

module ridge() {
	translate([wall_thickness, wall_thickness, 0])
		cube([
			pcb_width - ridge_width,
			ridge_width,
			wall_thickness]);

	translate([wall_thickness, pcb_height - 0.5 * wall_thickness, 0])
		cube([
			pcb_width - ridge_width,
			ridge_width,
			wall_thickness]);

	translate([wall_thickness, wall_thickness + ridge_width, 0])
		cube([
			ridge_width,
			pcb_height - ridge_width - ridge_width,
			wall_thickness]);
}

module screwhole_tab() {
	difference() {
		hull() {
			cube([screwhole_tab_width, screwhole_tab_width / 2, wall_thickness]);
      		translate([
				screwhole_tab_width / 2,
				screwhole_tab_width / 2,
				0])
					cylinder(r = screwhole_tab_width / 2, h = wall_thickness, center = false, $fn = 40);
		}

		translate([
				screwhole_tab_width / 2,
				screwhole_tab_width / 2,
				0])
			cylinder(r = screwhole_diameter / 2, h = wall_thickness * 3, center = true, $fn = 30);
	}
}

module box() {
	// Bottom rectangle
	cube([
		wall_thickness + pcb_width + wall_thickness,
		wall_thickness + pcb_height + wall_thickness,
		wall_thickness]);
	
	// First long wall
	translate([0, 0, wall_thickness])
		cube([
			wall_thickness + pcb_width + wall_thickness,
			wall_thickness,
			pcb_thickness + inner_height	]);
	
	// Second long wall
	translate([0, pcb_height + wall_thickness, wall_thickness])
		cube([
			wall_thickness + pcb_width + wall_thickness,
			wall_thickness,
			pcb_thickness + inner_height	]);
	
	// First short wall, w/ hole for power cable
	difference() {
		translate([0, wall_thickness, wall_thickness])
			cube([
				wall_thickness,
				pcb_height,
				pcb_thickness + inner_height]);
		

		translate([wall_thickness * 2, 0, 0]) rotate([0, -90, 0]) hull() {
			translate([
				wall_thickness * 3 + pcb_thickness,
				((wall_thickness * 2 + pcb_height) / 2) - wire_diameter / 2,
				0])
				cylinder(r = wire_diameter / 2, h = wall_thickness * 3, $fn = 20);		
			translate([
				wall_thickness * 3 + pcb_thickness,
				((wall_thickness * 2 + pcb_height) / 2) + wire_diameter / 2,
				0])
				cylinder(r = wire_diameter / 2, h = wall_thickness * 3, $fn = 20);
		}
	}


	// Ridges
	translate([0, 0, wall_thickness + pcb_thickness]) ridge();
	translate([0, 0, pcb_thickness + inner_height - wall_thickness]) ridge();

	// Screwhole tabs
	
	translate([
		(wall_thickness + pcb_width + wall_thickness - screwhole_tab_width) / 2,
		wall_thickness + pcb_height + wall_thickness,
		0]) screwhole_tab();

	translate([
		(wall_thickness + pcb_width + wall_thickness + screwhole_tab_width) / 2,
		0,
		0]) rotate([0, 0, 180]) screwhole_tab();

	
	


}


module top_cover() {
	difference()	{		
		cube([
			wall_thickness + pcb_width + wall_thickness,
			wall_thickness + pcb_height + wall_thickness,
			wall_thickness]);

		for (x = [0,1,2,3,4]) {
			for (y = [0,1,2,3,4]) {
				translate([
					led_offset_x + (x * led_spacing),
					led_offset_y + (y * led_spacing),
					0])
					cylinder(r = led_hole_diameter / 2, h = wall_thickness * 3, center = true, $fn=40);
			}
		}
	}

	translate([0, 0, wall_thickness]) ridge();

}

module back_cover() {
	cube([
		wall_thickness + pcb_thickness + inner_height + wall_thickness,
		wall_thickness + pcb_height + wall_thickness,
		wall_thickness]);

	translate([0, 0, wall_thickness]) {
		translate([wall_thickness + pcb_thickness, wall_thickness, 0])
			cube([wall_thickness, pcb_height, ridge_width]);

		translate([pcb_thickness + inner_height - wall_thickness,  wall_thickness, 0])
			cube([wall_thickness, pcb_height, ridge_width]);
	}
}

// Assembly
//---------------------------------------------------------------------------------


module assembly() {
	box();

	translate([0, pcb_height + wall_thickness * 2 + screwhole_tab_width + 20, 0]) 
		top_cover();

	translate([pcb_width + wall_thickness * 4 + 20, 0]) back_cover();
}

translate([0, screwhole_tab_width, 0]) assembly();

