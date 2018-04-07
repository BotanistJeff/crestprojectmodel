building_size=[50000,35000,12000];
apartment_depth=7000;
apartment_width=5000;
hallway_width=2000;
warehouse_size=[building_size.x-(apartment_depth+hallway_width),
                building_size.y-(apartment_depth+hallway_width),
                building_size.z];
wall_thick=200;
half_wall=wall_thick/2;
tab_size=2000;
margin=1;
floor_height = building_size.z/4;

module wall_tabs(inverse=false)
{
    for(y=[(inverse?0:tab_size) :tab_size*2:tab_size*12])
        translate([0,y])
            square([wall_thick+margin,tab_size+margin],center=true);
}
module place_wall(pos=[0,0,0],rot=0)
{
    translate(pos) rotate([90,0,rot])
        translate([0,0,-half_wall])
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
module normal_wall(length, inverse=false)
{
    difference() {
        translate([-wall_thick/2,0])
            square([length+wall_thick, building_size.z]);
        wall_tabs(inverse);
        translate([length,0]) wall_tabs(inverse);
    }
}
module north_wall()
{
    normal_wall(building_size.x);
}
module east_wall()
{
    normal_wall(building_size.y, inverse=true);
}
module south_wall()
{
    difference() {
        normal_wall(building_size.x);
        translate([warehouse_size.x,0]) wall_tabs();
    }
}
module west_wall()
{
    difference() {
        normal_wall(building_size.y, inverse=true);
        translate([warehouse_size.y,0]) wall_tabs(inverse=true);
    }
}
module north_int()
{
    normal_wall(warehouse_size.x);
}
module east_int ()
{
    normal_wall(warehouse_size.y, inverse=true);
}
module apartment_floor()
{
    offset(delta=half_wall) difference() {
        square([building_size.x,building_size.y]);
        translate([-(apartment_depth+hallway_width),
                   -(apartment_depth+hallway_width)])
            square([building_size.x,building_size.y]);

    }
}
module upright_wall()
{
    normal_wall(apartment_depth);
}
color("green") ground();

color("blue") place_wall(pos=[0,building_size.y,0]) north_wall();
place_wall(pos=[building_size.x,0,0],rot=90) east_wall();
color("red") place_wall() south_wall();
place_wall(rot=90) west_wall();

color("blue") place_wall(pos=[0,warehouse_size.y,0]) north_int();
place_wall(pos=[warehouse_size.x,0,0],rot=90) east_int();

for(z=[floor_height:floor_height:building_size.z-1])
    translate([0,0,z])
        color("purple") linear_extrude(wall_thick) apartment_floor();
for(y=[apartment_width:apartment_width:building_size.y-apartment_width])
    color("orange") place_wall([building_size.x-apartment_depth,y,0]) upright_wall();
for(x=[apartment_width:apartment_width:building_size.x-2*apartment_width])
    color("orange") place_wall([x,building_size.y-apartment_depth,0],rot=90) upright_wall();
