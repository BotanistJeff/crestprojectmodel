building_size=[50000,35000,12000];
wall_thick=200;
half_wall=wall_thick/2;

module ground()
{
    translate([-5000,-5000,-10])
        cube([building_size.x+10000,
              building_size.y+10000,
              10]);
}
module north_wall()
{
    translate([0,building_size.y,0]) rotate([90,0,0])
        translate([-half_wall,0,-half_wall])
            linear_extrude(wall_thick) {
                square([building_size.x+wall_thick,
                        building_size.z]);
            }
}
module east_wall()
{
    translate([building_size.x,0,0])
        rotate([90,0,90])
            translate([-half_wall,0,-half_wall])
               linear_extrude(wall_thick) {
                    square([building_size.y+wall_thick,
                            building_size.z]);
           }
}
module south_wall()
{
    rotate([90,0,0])
        translate([-half_wall,0,-half_wall])
            linear_extrude(wall_thick) {
                square([building_size.x+wall_thick,
                        building_size.z]);
            }
}
module west_wall()
{
    rotate([90,0,90])
        translate([-half_wall,0,-half_wall])
            linear_extrude(wall_thick) {
                square([building_size.y+wall_thick,
                        building_size.z]);
            }
}
color("green") ground();
color("blue") north_wall();
east_wall();
color("red") south_wall();
west_wall();
