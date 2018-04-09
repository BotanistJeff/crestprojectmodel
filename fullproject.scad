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
    difference() {
        normal_wall(building_size.x);
        for(y=[floor_height:floor_height:building_size.z-1]) {
            for(x=[apartment_width/2:apartment_width:building_size.x-apartment_width/2])
                translate([x,y]) square([2000+margin,wall_thick+margin], center=true);
        for(x=[apartment_width:apartment_width:building_size.x-apartment_width*2]) {
            for(y=[building_size.z/8:building_size.z/4:building_size.z])
                translate([x,y])
                    square([wall_thick+margin,building_size.z/8+margin],center=true);
            }
        }
    }
}
module east_wall()
{
    difference() {
        normal_wall(building_size.y, inverse=true);
        for(y=[floor_height:floor_height:building_size.z-1]) {
            for(x=[apartment_width/2:apartment_width:building_size.y-apartment_width/2])
                translate([x,y]) square([2000+margin,wall_thick+margin], center=true);
        for(x=[apartment_width:apartment_width:building_size.y-apartment_width]) {
            for(y=[building_size.z/8:building_size.z/4:building_size.z])
                translate([x,y])
                    square([wall_thick+margin,building_size.z/8+margin],center=true);
            }
        }
    }
}
module south_wall()
{
    difference() {
        normal_wall(building_size.x);
        translate([warehouse_size.x,0]) wall_tabs();
        for(y=[floor_height:floor_height:building_size.z-1]) {
            translate([building_size.x-(apartment_depth+hallway_width)/2,y])
                square([2000+margin,wall_thick+margin],center=true);
        }
    }
}
module west_wall()
{
    difference() {
        normal_wall(building_size.y, inverse=true);
        translate([warehouse_size.y,0]) wall_tabs(inverse=true);
        for(y=[floor_height:floor_height:building_size.z-1]) {
            translate([building_size.y-(apartment_depth+hallway_width)/2,y])
                square([2000+margin,wall_thick+margin],center=true);
        }
    }
}
module north_int()
{
    difference() {
        normal_wall(warehouse_size.x);
        for(y=[floor_height:floor_height:building_size.z-1]) {
            for(x=[apartment_width/2:apartment_width:warehouse_size.x])
                translate([x,y]) square([2000+margin,wall_thick+margin], center=true);
        }
    }
}
module east_int ()
{
    difference() {
        normal_wall(warehouse_size.y, inverse=true);
        for(y=[floor_height:floor_height:building_size.z-1]) {
            for(x=[apartment_width/2:apartment_width:warehouse_size.y])
                translate([x,y]) square([2000+margin,wall_thick+margin], center=true);
        }
    }
}
module apart_north_doors()
{
    offset(delta=-half_wall) square([building_size.x-apartment_depth,
                                    floor_height]);
}

module apart_east_doors()
{
    offset(delta=-half_wall) square([building_size.y-apartment_width+wall_thick,
                                    floor_height]);
}

module apartment_floor()
{
    difference() {
        offset(delta=-(half_wall)) difference() {
            square([building_size.x,building_size.y]);
            translate([-(apartment_depth+hallway_width),
                       -(apartment_depth+hallway_width)])
                square([building_size.x,building_size.y]);
        }

        // slots for interior wall placement
        for(y=[apartment_width:apartment_width:building_size.y-apartment_width])
            translate([building_size.x,y]) square([apartment_depth,wall_thick+margin], center=true);
        for(x=[apartment_width:apartment_width:building_size.x-apartment_width*2])
            translate([x,building_size.y]) square([wall_thick+margin,apartment_depth], center=true);
    }
    // support tabs out to east wall
    for(y=[apartment_width/2:apartment_width:building_size.y-apartment_width/2])
        translate([building_size.x,y]) square([wall_thick+margin,2000], center=true);
    // support tabs out to north wall
    for(x=[apartment_width/2:apartment_width:building_size.x-apartment_width/2])
        translate([x,building_size.y]) square([2000,wall_thick+margin], center=true);
    // support tab on south wall
    translate([building_size.x-(apartment_depth+hallway_width)/2,0])
        square([2000,wall_thick+margin], center=true);
    // support tab on west wall
    translate([0,building_size.y-(apartment_depth+hallway_width)/2])
        square([wall_thick+margin,2000], center=true);
    // support tabs on interior east wall
    for(y=[apartment_width/2:apartment_width:warehouse_size.y])
        translate([warehouse_size.x,y]) square([wall_thick+margin,2000], center=true);
    // support tabs on interior north wall
    for(x=[apartment_width/2:apartment_width:warehouse_size.x])
        translate([x,warehouse_size.y]) square([2000,wall_thick+margin], center=true);

}
module upright_wall()
{
    difference() {
        translate([half_wall,0])
            square([apartment_depth, building_size.z]);
        translate([apartment_depth,0])
            for(y=[0:building_size.z/4:building_size.z])
                translate([0,y])
                    square([wall_thick+margin,building_size.z/8+margin],center=true);
        // slots for interior wall placement
        for(y=[floor_height:floor_height:building_size.z-1])
            translate([0,y]) square([apartment_depth,wall_thick+margin], center=true);
    }
}
color("green") ground();

color("blue") place_wall(pos=[0,building_size.y,0]) north_wall();
place_wall(pos=[building_size.x,0,0],rot=90) east_wall();
color("red") place_wall() south_wall();
place_wall(rot=90) west_wall();

color("blue") place_wall(pos=[0,warehouse_size.y,0]) north_int();
place_wall(pos=[warehouse_size.x,0,0],rot=90) east_int();

// Interior apartment door walls, one per floor
for(z=[0:floor_height:building_size.z-1]) {
    color("cyan") place_wall([0,building_size.y-apartment_depth,z])
        apart_north_doors();
    color("cyan") place_wall([building_size.x-apartment_depth,0,z], rot=90)
        apart_east_doors();
}

for(z=[floor_height:floor_height:building_size.z-1])
    translate([0,0,z-half_wall])
        color("purple") linear_extrude(wall_thick) apartment_floor();
for(y=[apartment_width:apartment_width:building_size.y-apartment_width])
    color("orange") place_wall([building_size.x-apartment_depth,y,0]) upright_wall();
for(x=[apartment_width:apartment_width:building_size.x-2*apartment_width])
    color("orange") place_wall([x,building_size.y-apartment_depth,0],rot=90) upright_wall();
