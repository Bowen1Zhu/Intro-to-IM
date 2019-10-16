boolean saved = false;

void setup() {
  size(500, 500);
  background(135, 206, 255);  //skyblue
}

void draw() {  
  //***** start of Neck & Body *****
  //upper part of neck
  fill(255, 219, 172);
  stroke(180);
  strokeWeight(1);
  beginShape();
  curveVertex(195, 357);
  curveVertex(195, 357);
  curveVertex(197, 385);
  curveVertex(195, 410);
  curveVertex(195, 410);
  curveVertex(300, 410);
  curveVertex(300, 410);
  curveVertex(298, 385);
  curveVertex(300, 357);
  curveVertex(300, 357);
  endShape();
  //clothes
  fill(25, 25, 112);
  stroke(80);
  beginShape();
  curveVertex(196, 400);
  curveVertex(196, 400);
  curveVertex(70, 435);
  curveVertex(45, 500);
  curveVertex(45, 500);
  curveVertex(455, 500);
  curveVertex(455, 500);
  curveVertex(430, 435);
  curveVertex(299, 400);
  curveVertex(299, 400);
  endShape();
  stroke(70);
  line(102, 490, 103, 500);
  line(400, 490, 399, 500);
  //lower part of neck
  fill(255, 219, 172); 
  stroke(80); 
  arc(247, 391, 125, 75, radians(16), radians(164));
  //***** end of Neck & Body *****
  
  //***** start of Face *****
  //lower part of face
  stroke(180);
  beginShape();
  curveVertex(155, 240);
  curveVertex(155, 240);
  curveVertex(162, 300);
  curveVertex(184, 345);
  curveVertex(220, 375);
  curveVertex(247, 382);
  curveVertex(274, 375);
  curveVertex(312, 345);
  curveVertex(332, 300);
  curveVertex(339, 240);
  curveVertex(339, 240);
  endShape();
  //upper part of face
  noStroke();
  arc(247, 240, 185, 192, radians(180), radians(360));
  //***** end of Face *****
  
  //***** start of Ears *****
  //left ear
  stroke(170);
  strokeWeight(1);
  fill(255, 214, 160);
  beginShape();
  curveVertex(155, 240);
  curveVertex(155, 240);
  curveVertex(150, 235);
  curveVertex(148, 236);
  curveVertex(145, 240);
  curveVertex(149, 262);
  curveVertex(154, 282);
  curveVertex(160, 290);
  curveVertex(160, 290);
  endShape();
  //right ear
  stroke(180);
  beginShape();
  curveVertex(339, 240);
  curveVertex(339, 240);
  curveVertex(345, 235);
  curveVertex(347, 237);
  curveVertex(349, 240);
  curveVertex(345, 265);
  curveVertex(339, 285);
  curveVertex(334, 291);
  curveVertex(334, 291);
  endShape();
  //***** end of Ears *****
  
  //***** start of Mouth *****
  //upper lip
  noStroke();
  fill(227, 73, 86);
  arc(247, 337, 46, 15, radians(-175), radians(5));
  fill(255, 219, 172);
  strokeWeight(2.5);
  beginShape();
  curveVertex(238, 329);
  curveVertex(238, 329);
  curveVertex(244, 331);
  curveVertex(247, 332);
  curveVertex(250, 331);
  curveVertex(256, 329);
  curveVertex(256, 329);
  endShape();
  //lower lip
  fill(227, 93, 106);
  arc(245, 336, 45, 20, radians(110), radians(180));
  arc(250, 336, 45, 20, radians(5), radians(72));
  quad(243, 338, 237, 346, 258, 346, 253, 338);
  fill(255, 255, 255, 50);
  rect(235, 339, 10, 4, 2, 2, 2, 2);
  //upper lip
  stroke(227, 73, 86);
  line(237, 336, 254, 336);
  //shadow
  stroke(0, 100);
  strokeWeight(2.5);
  beginShape();
  curveVertex(223, 337);
  curveVertex(223, 337);
  curveVertex(222, 337);
  curveVertex(222, 335);
  curveVertex(224, 335);
  curveVertex(234, 336);
  curveVertex(240, 337);
  curveVertex(246, 338);
  curveVertex(252, 337);
  curveVertex(258, 336);
  curveVertex(270, 336);
  curveVertex(272, 336);
  curveVertex(272, 338);
  curveVertex(272, 338);
  endShape();
  stroke(0, 50);
  strokeWeight(2);
  beginShape();
  curveVertex(243, 346);
  curveVertex(243, 346);
  curveVertex(253, 346);
  curveVertex(253, 346);
  endShape();
  //***** end of Mouth *****
  
  //***** start of Nose *****
  fill(255, 219, 172);
  strokeWeight(1);
  stroke(50);
  arc(231, 300, 11.5, 11.5, radians(60), radians(240));
  arc(264, 300, 11.6, 11.6, radians(-60), radians(120));
  arc(226, 290, 15, 10, radians(0), radians(60));
  arc(269, 290, 15, 10, radians(120), radians(180));
  fill(0, 0, 0, 120);
  arc(237, 304, 7, 3, radians(180), radians(360));
  arc(258, 304, 7, 3, radians(180), radians(360));
  fill(0, 0, 0, 50);
  arc(247.5, 304, 12, 5, radians(0), radians(180));
  noStroke();
  fill(0, 0, 0, 120);
  ellipse(237, 305, 8, 3);
  ellipse(258, 305, 8, 3);
  stroke(50);
  line(234, 290, 239, 272);
  line(260, 290, 254, 272);
  noFill();
  arc(239, 266, 3, 10, radians(-45), radians(90));
  arc(254, 246, 3, 50, radians(90), radians(140));
  //***** end of Nose *****
  
  //***** start of Eyes *****
  //upper part of left eye
  fill(255, 255, 255);
  arc(210, 242, 26, 18, radians(-90), radians(30));
  arc(209, 238, 26, 9, radians(195), radians(270));
  noFill();
  arc(189, 235, 16, 3, radians(0), radians(60));
  arc(194, 240, 11, 5, radians(180), radians(270));
  //lower part of left eye
  fill(255, 255, 255);
  arc(210, 243, 25, 8, radians(0), radians(150));
  arc(200, 240, 15, 12, radians(100), radians(180));
  noStroke();
  rect(194, 237, 7, 3);
  //left eyeball
  fill(99, 78, 52);
  stroke(50);
  arc(208, 238, 15, 15, radians(-30), radians(210));
  triangle(208, 238, 201, 235, 208, 233);
  triangle(208, 238, 208, 233, 214, 234);
  fill(0, 0, 0);
  ellipse(207, 237, 8, 8);
  fill(255, 255, 255);
  quad(203, 234, 203, 236, 207, 237, 207, 234);
  //upper part of right eye
  fill(255, 255, 255);
  arc(285, 243, 28, 19, radians(160), radians(270));
  arc(285, 237, 33, 7, radians(270), radians(350));
  noFill();
  arc(305, 235, 10, 4, radians(90), radians(120));
  arc(305, 240, 10, 4, radians(285), radians(355));
  //lower part of right eye
  fill(255, 255, 255);
  arc(286, 243, 32, 10, radians(15), radians(180));
  arc(296, 239, 17, 13, radians(10), radians(70));
  noStroke();
  rect(285, 237, 17, 7);
  //right eyeball
  fill(99, 78, 52);
  triangle(280, 234, 291, 233, 286, 240);    
  stroke(50);
  arc(286, 239, 15, 15, radians(-50), radians(220));
  fill(0, 0, 0);
  ellipse(285, 238, 8.5, 8.5);
  fill(255, 255, 255);
  quad(281, 235, 281, 237, 285, 238, 285, 235);
  //***** end of Eyes *****
  
  //***** start of Eyebrows *****
  //left eyebrow
  fill(0, 0, 0, 200);
  quad(197, 221, 196, 215, 226, 217, 224, 222);
  fill(0, 0, 0, 180);
  quad(196, 215, 197, 221, 189, 223, 185, 223);
  //right eyebrow
  fill(0, 0, 0, 200);
  quad(296, 221, 297, 215, 266, 218, 268, 223.5);
  fill(0, 0, 0, 180);
  quad(297, 215, 296, 221, 308, 224, 311, 224);
  //***** end of Eyebrows *****
  
  //***** start of Hair *****
  //sides
  fill(15, 200);
  beginShape();
  vertex(155, 240);
  vertex(161, 200);
  vertex(173, 185);
  vertex(176, 170);
  vertex(247, 170);
  vertex(316, 170);
  vertex(321, 185);
  vertex(333, 200);
  vertex(339, 240);
  vertex(339, 241);
  vertex(343, 174);
  vertex(150, 174);
  vertex(155, 241);
  endShape();
  //top
  fill(15);
  arc(247, 175, 192, 140, radians(180), radians(360));
  stroke(135, 206, 255);
  strokeWeight(2);
  beginShape();
  curveVertex(220, 103);
  curveVertex(220, 103);
  curveVertex(237, 105);
  curveVertex(244, 107);
  curveVertex(251, 105);
  curveVertex(268, 103);
  curveVertex(268, 103);
  endShape();
  fill(135, 206, 255);
  triangle(244, 106, 227, 102, 261, 102);
  strokeWeight(3);
  stroke(15);
  fill(15, 255);
  beginShape();
  vertex(246, 108);
  vertex(246, 108);
  vertex(252, 103);
  vertex(254, 102);
  vertex(252, 107);
  vertex(252, 107);
  endShape();
  beginShape();
  vertex(244, 109);
  vertex(244, 109);
  vertex(234, 104);
  vertex(230, 103);
  vertex(233, 106);
  vertex(233, 106);
  endShape();
  //front
  stroke(10, 200);
  fill(15);
  beginShape();
  curveVertex(175, 172);
  curveVertex(175, 172);
  curveVertex(175, 188);
  curveVertex(200, 179);
  curveVertex(201, 189);
  curveVertex(232, 179);
  curveVertex(233, 191);
  curveVertex(271, 179);
  curveVertex(272, 193);
  curveVertex(315, 180);
  curveVertex(316, 175);
  curveVertex(316, 175);
  endShape();
  //***** end of Hair *****
  
  if (!saved) {
    saveFrame("self portrait.png");
    saved = true;
  }
  
  //locate_position();        //debugging purpose
}

void locate_position() {
  println("cursor at ( " + mouseX + ", " + mouseY + ")");
}
