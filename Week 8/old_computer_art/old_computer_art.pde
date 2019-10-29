int pos1 = 80;          //initial x-value of the left slider, which controls the step size of Perlin noise
int ofs1 = 0;           //offset for left slider
int pos2 = 430;         //initial x-value of the right slider, which controls the color ratio of the picture
int ofs2 = 0;           //offset for right slider
int i = 0;              //variable used to increment input of Perlin noise
boolean mouse = false;  //true if mouse is pressing the bar, false otherwise
boolean mov_left;       //true if left slider is moved, false if right slider is moved

void setup() {
  size(600, 600);  
  make_picture();               //generate initial picture
}

void draw() {
  //draw the console at the bottom
  pushMatrix();
  translate(0, 500);            //the origin is now at the lower left corner of the picture
  draw_console();
  
  //if bar is pressed, update its position
  if (mouse) {
    if (mov_left) {            //if left bar is moved, update left bar
      pos1 = mouseX + ofs1;
      pos1 = constrain(pos1, 80, 240);
      fill(100);
      rect(pos1, 30, 10, 40);
    } else {                   //if right bar is moved, update right bar
      pos2 = mouseX + ofs2;
      pos2 = constrain(pos2, 350, 510);
      fill(100);
      rect(pos2, 30, 10, 40);
    }
  }
  popMatrix();
}

//This is where the picture is drawn.
void make_picture() {
  float step = map(pos1, 80, 240, 0.05, 0.005);    //step size is determined by the left slider
  float ratio = map(pos2, 350, 510, 0.6, 0.4);     //color ratio is determined by the right slider
  for (int y = 0; y <= 500; y += 1) {
    for (int x = 0; x <= width; x += 1) {
      float r = noise(i + x * step, i + y * step); //random number generated through Perlin noise
      if (r < ratio) {                             //if random value < ratio -- black dot
        stroke(0);
      } else {                                     //otherwise -- white dot
        stroke(255);
      }
      //point(x, y);
      rect(x, y, 1, 1);                            //rect() draws faster than point()
    }
  }
  i += 20;                                         //change Perlin noise input so that every picture is different
  //saveFrame();
}

void draw_console() {
  //grey boundary
  noStroke();
  fill(110);
  rect(0, 0, width, 10);
  //white background
  fill(255);
  rect(0, 10, width, 90);
  //texts below the sliders
  fill(0);
  textSize(15);
  text("discrete", 60, 85);
  text("continuous", 215, 85);
  text("black", 340, 85);
  text("white", 510, 85);
  //lines of the sliders
  stroke(0);
  line(80, 50, 250, 50);
  line(350, 50, 520, 50);
  //bars of the sliders
  fill(225);
  rect(pos1, 30, 10, 40);
  rect(pos2, 30, 10, 40);
}

void mousePressed() {
  if (mouseY > 530 && mouseY < 570) {
    if (mouseX >= pos1 && mouseX <= pos1 + 10) {        //left bar is pressed
      mouse = true;
      mov_left = true;
      ofs1 = pos1 - mouseX;                             //store the relative position of the mouse to the left side of the bar
    } else if (mouseX >= pos2 && mouseX <= pos2 + 10) { //right bar is pressed
      mouse = true;
      mov_left = false;
      ofs2 = pos2 - mouseX;                             //store the relative position of the mouse to the left side of the bar
    }
  }
}

void mouseReleased() {
  //if (mouse) {     //without the if condition, a new picture will be drawn whenever a click is detected
    mouse = false;
    make_picture();  //draw a new picture
  //}
}
