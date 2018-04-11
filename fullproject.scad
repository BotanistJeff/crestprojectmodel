building_size=[50000,35000,12000];
apartment_depth=7000;
apartment_width=5000;
hallway_width=2000;
A2_sheet=[59400,42000];
warehouse_size=[building_size.x-(apartment_depth+hallway_width),
                building_size.y-(apartment_depth+hallway_width),
                building_size.z];
wall_thick=500;
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
    difference() {
        translate([(building_size.x-A2_sheet.x)/2,(building_size.y-A2_sheet.y)/2])
            square([A2_sheet.x,A2_sheet.y]);

        //notches for door walls
        for(x=[apartment_width/2:apartment_width:building_size.x-apartment_depth-1000])
            translate([x,building_size.y-apartment_depth])
                square([1000+margin,wall_thick+margin], center=true);
        for(y=[apartment_width/2:apartment_width:building_size.y-apartment_depth-100])
            translate([building_size.x-apartment_depth,y])
                square([wall_thick+margin,1000+margin], center=true);

        //notches for exterior walls
        for(x=[apartment_width/2:apartment_width:building_size.x-apartment_width/2])
            translate([x,0]) square([2000+margin,wall_thick+margin], center=true);
        for(x=[apartment_width/2:apartment_width:building_size.x-apartment_width/2])
            translate([x,building_size.y]) square([2000+margin,wall_thick+margin], center=true);
        for(y=[apartment_width/2:apartment_width:building_size.y-apartment_width/2])
            translate([0,y]) square([wall_thick+margin,2000+margin], center=true);
        for(y=[apartment_width/2:apartment_width:building_size.y-apartment_width/2])
            translate([building_size.x,y]) square([wall_thick+margin,2000+margin], center=true);

        //notches for warehouse walls
        for(x=[apartment_width/2:apartment_width:building_size.x-apartment_depth-hallway_width])
            translate([x,warehouse_size.y]) square([2000+margin,wall_thick+margin], center=true);
        for(y=[apartment_width/2:apartment_width:building_size.y-apartment_depth-hallway_width])
            translate([warehouse_size.x,y]) square([wall_thick+margin,2000+margin], center=true);
    }
}
module normal_wall(length, inverse=false)
{
    difference() {
        translate([-wall_thick/2,half_wall])
            square([length+wall_thick, building_size.z-half_wall]);
        wall_tabs(inverse);
        translate([length,0]) wall_tabs(inverse);
    }
}

module window_wall(length, inverse=false)
{
    difference() {
        normal_wall(length, inverse);
        // Windows
        for(y=[floor_height*5/8:floor_height:building_size.z-1])
            for(x=[apartment_width/2:apartment_width:length-apartment_width/2])
                translate([x,y])
                    square([apartment_width/2,floor_height*1/2], center=true);
        // Tabs for flooring piece
        for(y=[floor_height:floor_height:building_size.z-1])
            for(x=[apartment_width/2:apartment_width:length-apartment_width/2])
                translate([x,y]) square([2000+margin,wall_thick+margin], center=true);
    }
}
module north_wall()
{
    difference() {
        union() {
            difference() {
                window_wall(building_size.x);
                // Tabs for divider walls
                for(x=[apartment_width:apartment_width:building_size.x-apartment_width*2]) {
                    for(y=[building_size.z/8:building_size.z/4:building_size.z])
                        translate([x,y])
                            square([wall_thick+margin,building_size.z/8+margin],center=true);
                }
            }
            translate([apartment_width*8.5,floor_height*5/8])
                square([apartment_width/2+10,floor_height*1/2+10], center=true);
        }
        translate([apartment_width*8.5,0])
            square([1000,2000*2], center=true);
    }
    for(x=[apartment_width/2:apartment_width:building_size.x-apartment_width/2])
        translate([x,0]) square([2000,wall_thick+margin], center=true);
}
module east_wall()
{
    difference() {
        window_wall(building_size.y, inverse=true);
        // Tabs for divider walls
        for(x=[apartment_width:apartment_width:building_size.y-apartment_width]) {
            for(y=[building_size.z/8:building_size.z/4:building_size.z])
                translate([x,y])
                    square([wall_thick+margin,building_size.z/8+margin],center=true);
        }
    }
    for(x=[apartment_width/2:apartment_width:building_size.y-apartment_width/2])
        translate([x,0]) square([2000,wall_thick+margin], center=true);
}
module warehouse_wall(length, inverse=false)
{
    warehouse_length = length - apartment_depth - hallway_width;
    difference() {
        normal_wall(length, inverse);
        // Fire Escape Wall tabs
        translate([warehouse_length-4000,0]) wall_tabs(inverse);
        // Interior Wall tabs
        translate([warehouse_length,0]) wall_tabs(inverse);
        for(y=[floor_height:floor_height:building_size.z-1])
            translate([length-(apartment_depth+hallway_width)/2,y])
                square([2000+margin,wall_thick+margin],center=true);
        for(y=[floor_height/2:floor_height:building_size.z-1])
            translate([length-apartment_depth,y])
                square([wall_thick+margin,floor_height/2+margin], center=true);
        // Fire escape doors
        translate([warehouse_length+hallway_width/2,0]) square([1000,2000*2], center=true);
        translate([warehouse_length-hallway_width/2,0]) square([1000,2000*2], center=true);
    }
}
module south_wall()
{
    difference() {
        warehouse_wall(building_size.x);
    }
    for(x=[apartment_width/2:apartment_width:building_size.x-apartment_width/2])
        translate([x,0]) square([2000,wall_thick+margin], center=true);
}
module west_wall()
{
    difference() {
        warehouse_wall(building_size.y, inverse=true);
    }
    for(x=[apartment_width/2:apartment_width:building_size.y-apartment_width/2])
        translate([x,0]) square([2000,wall_thick+margin], center=true);
}
module interior_warehouse_wall(length, inverse=false)
{
    difference() {
        normal_wall(length, inverse);
        // apartment floor tabs
        for(y=[floor_height:floor_height:building_size.z-1]) {
            for(x=[apartment_width/2:apartment_width:length])
                translate([x,y]) square([2000+margin,wall_thick+margin], center=true);
        }
        // Fire escape doors
        for(y=[half_wall+1000:floor_height:building_size.z-1])
            translate([apartment_width/4,y]) square([1000,2000], center=true);
        // Fire escape wall tabs
        translate([4000,0]) wall_tabs(inverse);
        // Elevator shaft wall tabs
        translate([length-5000,0]) wall_tabs(inverse);
    }
    // tabs into floor
    for(x=[apartment_width/2:apartment_width:length])
        translate([x,0]) square([2000,wall_thick+margin], center=true);
}
module north_int()
{
    difference() {
        interior_warehouse_wall(warehouse_size.x);
        // Elevator doors
        for(y=[half_wall+1000:floor_height:building_size.z-1])
            translate([warehouse_size.x-2500,y]) square([2000,2000], center=true);
    }
}
module east_int()
{
    difference() {
        interior_warehouse_wall(warehouse_size.y, inverse=true);
    }
}
module fire_escape_wall(inverse=false)
{
    normal_wall(4000, inverse);
}
module elevator_wall(inverse=false)
{
    normal_wall(5000, inverse);
}
module apart_doors(length)
{
    difference() {
        offset(delta=-half_wall)
            square([length, floor_height]);
        for(x=[apartment_width/4:apartment_width:length])
            translate([x,0]) square([1000,2000*2], center=true);
    }
    for(x=[apartment_width:apartment_width:length-1000])
        translate([x,floor_height]) square([1000,wall_thick+margin], center=true);
    for(x=[apartment_width*2/4:apartment_width:length-1000])
        translate([x,0]) square([1000,wall_thick+margin], center=true);
}
module apart_north_doors()
{
    apart_doors(building_size.x-apartment_depth);
    translate([building_size.x-apartment_depth,floor_height/2])
        square([wall_thick+margin,floor_height/2-margin], center=true);
    translate([0,floor_height/2])
        square([wall_thick+margin,floor_height/2-margin], center=true);
}

module apart_east_doors()
{
    difference() {
        apart_doors(building_size.y-apartment_width+wall_thick);
        translate([building_size.y-apartment_depth,floor_height/2])
            square([wall_thick+margin,floor_height/2+margin], center=true);
    }
    translate([0,floor_height/2])
        square([wall_thick+margin,floor_height/2-margin], center=true);
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


        for(x=[apartment_width/2:apartment_width/2:building_size.x-apartment_depth-1000])
            translate([x,building_size.y-apartment_depth])
                square([1000,wall_thick+margin], center=true);
        for(y=[apartment_width/2:apartment_width/2:building_size.y-apartment_depth-100])
            translate([building_size.x-apartment_depth,y])
                square([wall_thick+margin,1000], center=true);
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
        translate([half_wall,half_wall])
            square([apartment_depth, building_size.z-half_wall]);
        translate([apartment_depth,0])
            for(y=[0:building_size.z/4:building_size.z])
                translate([0,y])
                    square([wall_thick+margin,building_size.z/8+margin],center=true);
        // slots for interior wall placement
        for(y=[floor_height:floor_height:building_size.z-1])
            translate([0,y]) square([apartment_depth,wall_thick+margin], center=true);
    }
}
translate([0,0,-half_wall])
    color("green") linear_extrude(wall_thick) ground();

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
    color("salmon") place_wall([building_size.x-apartment_depth,0,z], rot=90)
        apart_east_doors();
}

// Fire Escapes
color("blue") place_wall([0,warehouse_size.y-4000]) fire_escape_wall();
place_wall([4000,warehouse_size.y-4000], rot=90) fire_escape_wall(inverse=true);
color("blue") place_wall([warehouse_size.x-4000,4000]) fire_escape_wall();
place_wall([warehouse_size.x-4000,0], rot=90) fire_escape_wall(inverse=true);
// Elevator shaft
color("blue") place_wall([warehouse_size.x-5000,warehouse_size.y-5000]) elevator_wall();
place_wall([warehouse_size.x-5000,warehouse_size.y-5000], rot=90) elevator_wall(inverse=true);

for(z=[floor_height:floor_height:building_size.z-1])
    translate([0,0,z-half_wall])
        color("purple") linear_extrude(wall_thick) apartment_floor();
for(y=[apartment_width:apartment_width:building_size.y-apartment_width])
    color("orange") place_wall([building_size.x-apartment_depth,y,0]) upright_wall();
for(x=[apartment_width:apartment_width:building_size.x-2*apartment_width])
    color("orange") place_wall([x,building_size.y-apartment_depth,0],rot=90) upright_wall();
