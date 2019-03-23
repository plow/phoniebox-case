
use <raspberrypi.scad>;

w_wall = 13;
w_wall_out = 18;
w_wall_in = 4;
w_speaker = 68.5;

rfid_reader_w = 105;
rfid_reader_d = 70;
rfid_reader_h = 14;

w_pi_chamber = 55;
w_speakers = 2*w_speaker + 2*.5;
w_in = w_speakers + w_wall + w_wall_in + w_pi_chamber;
h_in = w_speaker + rfid_reader_h + 7.5; // min. 90
d_in = 162;

// case

color("Yellow") BottomPlate();
//color("Orange") TopPlate();
color("Cyan") LeftWall();
color("Green") RightWall();
color("Violet") FrontWall(55);
//color("Pink") RearWall();

translate([0, rfid_reader_d, 0]) WallRetainer();
translate([0, rfid_reader_d, 0]) SpeakerBackWall();
translate([w_speakers, 0, 0]) SpeakerSideWall();


// inner setup

rfid_reader_base_h = 7;
translate([0, 0, w_speaker]) AddPart(rfid_reader_w, rfid_reader_d, 7, "SPACER: RFID reader base");
translate([rfid_reader_w, 0, w_speaker]) AddPart(w_speakers-rfid_reader_w, 15, rfid_reader_h+rfid_reader_base_h, "SPACER: RFID reader base spacer front");
translate([rfid_reader_w, rfid_reader_d-15, w_speaker]) AddPart(w_speakers-rfid_reader_w, 15, rfid_reader_h+rfid_reader_base_h, "SPACER: RFID reader base spacer back");


// hardware

speaker_l_pos = .3;
translate([speaker_l_pos, 0.001, 0]) Speaker();
speaker_r_pos = speaker_l_pos + .4 + w_speaker ;
translate([speaker_r_pos, 0.001, 0]) Speaker();
rotate([-90, 0, 90]) translate([w_in-156, -29, -w_in+5])  Raspi();

translate([rfid_reader_w, 0, w_speaker+rfid_reader_base_h]) rotate([0, 0, 90]) RfidReader();


// modules

module AddPart(x, y, z, descr) {
  cube([x, y, z]);
  echo(descr);
  echo(x=x, y=y, z=z);
}

module BottomPlate() {
  translate([0,0,-w_wall_out]) AddPart(w_in, d_in, w_wall_out, "OUTER_WALL bottom");
}

module LeftWall() {
  translate([-w_wall_out, 0, -w_wall_out]) AddPart(w_wall_out, d_in, h_in+w_wall_out, "OUTER_WALL left");
}

module RightWall() {
  translate([w_in, 0, -w_wall_out]) AddPart(w_wall_out, d_in, h_in+w_wall_out, "OUTER_WALL right");
}

module RearWall() {
  translate([-w_wall_out, d_in, -w_wall_out]) AddPart(w_in+2*w_wall_out, w_wall_out, h_in+w_wall_out, "OUTER_WALL rear");
}

module TopPlate() {
  r_push_button = 12;
  r_push_button_nut = 16;
  push_button_dist = 2*r_push_button_nut + 2;
  
  // hatch half opened
  translate([-w_wall_out, rfid_reader_d, h_in]) rotate([0, -45, 0]) cube([w_speakers+w_wall_out+w_wall_in, d_in-rfid_reader_d+w_wall_out, w_wall_out]);
    
  difference() {
    translate([-w_wall_out,-w_wall_out,h_in]) AddPart(w_in+2*w_wall_out, d_in+2*w_wall_out, w_wall_out, "OUTER_WALL top");
    
    // hatch
    translate([-w_wall_out-.5, rfid_reader_d, h_in-.5]) cube([w_speakers+w_wall_out+w_wall_in+.5, d_in-rfid_reader_d+w_wall_out+1, w_wall_out+1]);
    
    // power button hole
    y_button_pos = r_push_button_nut + 6;
    x_button_pos = w_speakers+w_wall_in+w_wall+r_push_button_nut+5;
    translate([x_button_pos, y_button_pos, h_in-1]) 
      cylinder(w_wall_out+2, r_push_button, r_push_button);
    
    // power cable slot
    slot_w = 6;
    translate([x_button_pos+10, y_button_pos-slot_w/2, h_in-1]) 
      cube([20, slot_w, w_wall_out+2]);
      
    // volume up/down, play/pause button holes
    y_button_pos_others = r_push_button_nut + 55;
    for (i=[0:2])
      translate([x_button_pos, y_button_pos_others+i*push_button_dist, h_in-1])
      cylinder(w_wall_out+2, r_push_button, r_push_button);
  }
}

module FrontWall(opening=50) {
  left_speaker_center = [.5+w_speaker/2, 0, w_speaker/2];
  radius_push_buttons = 12;
  pi_chamber_center = [w_speakers+w_wall_in+w_wall+radius_push_buttons+5, 0, 18];
  push_button_dist = 2*radius_push_buttons + 5;
  
  difference() {
    translate([-w_wall_out, -w_wall_out, -w_wall_out]) AddPart(w_in+2*w_wall_out, w_wall_out, h_in+w_wall_out, "OUTER_WALL front");
    translate(left_speaker_center-[0, w_wall_out+1, opening/2]) cube([w_speaker+.5, w_wall_out+2, opening]);
    rotate([90, 0, 0]) translate([left_speaker_center.x, left_speaker_center.z, left_speaker_center.y-1]) cylinder(w_wall_out+2, opening/2, opening/2);
    rotate([90, 0, 0]) translate([left_speaker_center.x+.5+w_speaker, left_speaker_center.z, left_speaker_center.y-1]) cylinder(w_wall_out+2, opening/2, opening/2); 
  }
}

module Speaker() {
  cable_len = 10;
  cable_height = 15;
  woofer_radius = 7;
  
  color("Gray")
  difference() {
    cube(w_speaker);
      
    rotate([90, 0, 0]) 
    translate([w_speaker/2, 30, -w_speaker-1])
    cylinder(20, woofer_radius, woofer_radius);
      
    translate([w_speaker/2, -22, w_speaker/2])
    sphere(w_speaker/2);
  }
      
  color("LightGray")
  rotate([90, 0, 0])
  translate([w_speaker/2, cable_height, -w_speaker-cable_len])
  cylinder(cable_len, 2, 2);
}

module Raspi() {
  pi3();
  
  // RFID reader cable
  translate([44, 1, 10])
  rotate([0, 90, 0])  
  color("Pink") cylinder(55, 3, 3);
    
  // Speaker cable
  translate([44, 20, 10])
  rotate([0, 90, 0])
  color("Pink") cylinder(30, 3, 3);
    
  // Power plug
  translate([-31.5, -29.6, 2.5])
  rotate([90, 0, 0])
  color("Pink") cylinder(55, 3, 3);
    
  // Audio out plug
  translate([11, -30, 3.5])
  rotate([90, 0, 0])
  color("Pink") cylinder(35, 3, 3);
}

module RfidReader() {
  cable_len = 45;
  color("Brown")
  cube([rfid_reader_d, rfid_reader_w, rfid_reader_h]);
  color("Brown")
  rotate([90, 0, 0])
  translate([rfid_reader_d/2, rfid_reader_h/2, 0])
  cylinder(cable_len, 5, 5);
}

module WallRetainer() {
  color("Turquoise")
  translate([w_wall, w_wall_in, 0]) AddPart(w_speakers-2*w_wall, w_wall, w_wall, "WALL_RETAINER speaker back-wall retainer bottom"); // mounted on base plate
  color("SteelBlue")
  translate([0, w_wall_in, 0]) AddPart(w_wall, w_wall, h_in, "WALL_RETAINER speaker back-wall retainer left"); // mounted on left wall
  color("DodgerBlue")
  translate([w_speakers-w_wall, w_wall_in, 0]) AddPart(w_wall, w_wall, h_in, "WALL_RETAINER speaker back-wall retainer right"); // mounted on side wall
  color("Turquoise")
  translate([w_speakers+w_wall_in, w_wall-rfid_reader_d, 0]) AddPart(w_wall, d_in-2*w_wall, w_wall, "WALL_RETAINER speaker side-wall retainer bottom right");
  color("Turquoise") // mounted on base plate
  translate([w_speakers+w_wall_in, -rfid_reader_d/2+5, h_in-w_wall]) AddPart(w_wall, d_in-rfid_reader_d/2-5-w_wall, w_wall, "WALL_RETAINER speaker side-wall retainer top right"); // mounted on top plate
  color("Turquoise")
  translate([w_speakers-w_wall, w_wall+w_wall_in, 0]) AddPart(w_wall, d_in-rfid_reader_d-2*w_wall-w_wall_in, w_wall, "WALL_RETAINER speaker side-wall retainer bottom left"); // mounted on base plate
  color("SteelBlue")
  translate([w_speakers+w_wall_in, -rfid_reader_d, 0]) AddPart(w_wall, w_wall, h_in, "WALL_RETAINER speaker side-wall retainer front"); // mounted on front wall
  color("SteelBlue")
  translate([w_speakers-w_wall, -rfid_reader_d+d_in-w_wall, 0]) AddPart(w_wall, w_wall, h_in, "WALL_RETAINER speaker side-wall retainer back left"); // mounted on back wall
  color("SteelBlue")
  translate([w_speakers+w_wall_in, -rfid_reader_d+d_in-w_wall, 0]) AddPart(w_wall, w_wall, h_in, "WALL_RETAINER speaker side-wall retainer back right"); // mounted on back wall
}

module SpeakerBackWall() {
  opening_w = 20;  
  color("SkyBlue")
  difference() {
    AddPart(w_speakers, w_wall_in, h_in, "INNER_WALL: speaker back-wall");
    
    // woofer hole left
    translate([w_speakers/4-opening_w/2, -1, 0])
    cube([opening_w, w_wall_in+2, 40]);
  
    translate([w_speakers/4*3-opening_w/2, -1, 0])
    cube([opening_w, w_wall_in+2, 40]);    
  }
}

module SpeakerSideWall() {
  color("Blue")    
  difference() {
    AddPart(w_wall_in, d_in, h_in, "INNER_WALL: speaker side-wall");
    
    translate([-.5, rfid_reader_d-.5, 0])  
    cube([w_wall_in+1, .5, h_in+1]);
      
    opening_hi = 15;
    translate([-1, 0, w_speaker+7])
    cube([w_wall_in+2, rfid_reader_d/2+5, opening_hi]);
      
    opening_lo_w = 25;
    opening_lo_h = 30;
    translate([-.5,rfid_reader_d+w_wall_in+w_wall+10,0])
    cube([w_wall_in+1, opening_lo_w, opening_lo_h]);
  }
}

