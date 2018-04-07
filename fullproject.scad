building_size=[50000,35000,12000];
wall_thick=200;
half_wall=wall_thick/2;
tab_size=2000;
margin=1;

module wall_tabs(inverse=false)
{
    for(y=[(inverse?0:tab_size) :tab_size*2:tab_size*12])
        translate([0,y])
            square([wall_thick*2+margin,tab_size+margin],center=true);
}
module place_wall(pos=[0,0,0],rot=0)
{
    translate(pos) rotate([90,0,rot])
        translate([-half_wall,0,-half_wall])
            linear_extrude(wall_thick)
                children();
}
module ground()
{
    translate([-5000,-5000,-10])
        cube([building_size.x+10000,
              building_size.y+10000,
              10]);
}
module north_wall()
{
    difference() {
        square([building_size.x+wall_thick,
                building_size.z]);
        wall_tabs();
        translate([building_size.x+wall_thick,0]) wall_tabs();
    }
}
module east_wall()
{
    difference() {
        square([building_size.y+wall_thick,
                building_size.z]);
        wall_tabs(inverse=true);
        translate([building_size.y+wall_thick,0])
            wall_tabs(inverse=true);
    }
}
module south_wall()
{
    difference() {
        square([building_size.x+wall_thick,
                building_size.z]);
        wall_tabs();
        translate([building_size.x+wall_thick,0]) wall_tabs();
    }
}
module west_wall()
{
    difference() {
        square([building_size.y+wall_thick,
                building_size.z]);
        wall_tabs(inverse=true);
        translate([building_size.y+wall_thick,0])
            wall_tabs(inverse=true);
    }
}
color("green") ground();
color("blue") place_wall(pos=[0,building_size.y,0])
    north_wall();
place_wall(pos=[building_size.x,0,0],rot=90) east_wall();
color("red") place_wall() south_wall();
place_wall(rot=90) west_wall();
