/**
 * Copyright 2019 Nathan Fairhurst.
 */

PIP_RADIUS = 3;
PIP_DEPTH = 2/3;
BOTTOM_TO_PIP_CENTER = 10;
BACK_TO_PIP_CENTER = 8;

FRONT_WALL_OFFSET = 3.5;
BACK_WALL_OFFSET = 4.75;

PRINTRBOT_WALL_THICKNESS = 1.5;
MICRO_SD_CARD_WIDTH = 11;
MICRO_SD_CARD_LENGTH = 15;
MICRO_SD_CARD_THICKNESS = 2/3;
MICRO_SD_CARD_PROTRUSION = 4;

SD_CARD_WIDTH = 24;
SD_CARD_LENGTH = 32;
SD_CARD_THICKNESS = 2.12;
SD_CARD_PROTRUSION = 9;

module card(width, length, thickness, tolerance) {
  cube([width + tolerance, length + tolerance, thickness + tolerance]);
}

module card_holder(
  card_width,
  card_length,
  card_thickness,
  card_protrusion,
  wall_thickness,
  is_positive,
  tolerance
) {
  if(is_positive == true)
    cube([
      wall_thickness * 2 + tolerance * 3 + card_width,
      wall_thickness * 2 + tolerance * 3 + card_thickness,
      wall_thickness + card_length - card_protrusion
    ]);
  else
    translate([wall_thickness + tolerance,
      wall_thickness + tolerance * 2 + card_thickness,
      wall_thickness + tolerance
    ])
      rotate([90, 0, 0])
        card(card_width, card_length, card_thickness, tolerance);
}

module printrbot_base(
  is_front,
  tolerance
) {
  depth_offset = is_front == true ? FRONT_WALL_OFFSET : BACK_WALL_OFFSET;

  side_height_offset = is_front == true ? 2.75 : 0;
  side_wall_height = 45;
  front_wall_length = 92;

  translate([0, -side_height_offset - PRINTRBOT_WALL_THICKNESS, 0])
    cube([PRINTRBOT_WALL_THICKNESS + tolerance, 400, side_wall_height]);
  translate([-front_wall_length / 2, -PRINTRBOT_WALL_THICKNESS, depth_offset])
    cube([
      front_wall_length / 2,
      PRINTRBOT_WALL_THICKNESS + tolerance,
      side_wall_height - depth_offset * 2
    ]);
  if (!is_front) {
    translate([-PRINTRBOT_WALL_THICKNESS, -side_height_offset - PRINTRBOT_WALL_THICKNESS, depth_offset])
      cube([PRINTRBOT_WALL_THICKNESS + tolerance, 400, side_wall_height - depth_offset * 2]);
    translate([PRINTRBOT_WALL_THICKNESS + tolerance, BACK_TO_PIP_CENTER, BOTTOM_TO_PIP_CENTER])
      rotate([0,90,0])
        cylinder(PIP_DEPTH, PIP_RADIUS, PIP_RADIUS);
  }
}


module bracket(length, width, height, height_at_truncation) {
  true_length = length / (height - height_at_truncation) * height;

  difference() {
    polyhedron(
      points=[[0, width / 2, 0],[0,0, height],[0, -width / 2,0],[true_length,0,0]],
      faces=[[0,1,2],[2,1,3],[3,1,0],[3,0,2]]
    );
    translate([length,-width/2,0])
      cube([true_length - length, width, height_at_truncation]);
  }
}

module foot(is_front, tolerance) {
  base_thickness = 4;
  foot_wall_thickness = 4;
  difference() {
    translate([0,0,-base_thickness])
      cylinder(12,10,10);
    printrbot_base(is_front, tolerance);
  }
}

module foot_with_wing(tolerance) {
  bottom_clearance = 4;
  wing_length = 64;

  foot(true, tolerance);
  translate([PRINTRBOT_WALL_THICKNESS + tolerance, 0, -bottom_clearance])
    bracket(wing_length, 30, 20, bottom_clearance);
  translate([PRINTRBOT_WALL_THICKNESS + tolerance + wing_length, 0, -bottom_clearance])
    cylinder(bottom_clearance, 8, 0);
}

foot_with_wing(0.3);

/*
card_holder(
  SD_CARD_WIDTH,
  SD_CARD_LENGTH,
  SD_CARD_THICKNESS,
  SD_CARD_PROTRUSION,
  1,
  0.3
);
*/
