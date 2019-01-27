/**
 * Copyright 2019 Nathan Fairhurst.
 */

PRINTRBOT_WALL_THICKNESS = 1.5;

module printrbot_base(
  tolerance
) {
  front_depth_offset = 3.5;
  side_height_offset = 2.75;
  side_wall_height = 45;
  front_wall_length = 92;

  translate([0, -side_height_offset - PRINTRBOT_WALL_THICKNESS, 0])
    cube([PRINTRBOT_WALL_THICKNESS + tolerance, 400, side_wall_height]);
  translate([-front_wall_length / 2, -PRINTRBOT_WALL_THICKNESS, front_depth_offset])
    cube([
      front_wall_length / 2,
      PRINTRBOT_WALL_THICKNESS + tolerance,
      side_wall_height - front_depth_offset * 2
    ]);
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

module foot(tolerance) {
  base_thickness = 4;
  foot_wall_thickness = 4;
  difference() {
    translate([0,0,-base_thickness])
      cylinder(12,10,10);
    printrbot_base(tolerance);
  }
}

foot(0.3);
translate([PRINTRBOT_WALL_THICKNESS + 0.3, 0, -4])
  bracket(64,30,20,4);
translate([PRINTRBOT_WALL_THICKNESS + 0.3 + 80 - 16, 0, -4])
  cylinder(4,8,8);
