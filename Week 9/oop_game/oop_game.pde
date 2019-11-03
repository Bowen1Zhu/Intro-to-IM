/* Feed My Dog
 * Collect all the bones and bring them to your dog.
 * Avoid wolves on your way.
 * You get three lives. Accumulate as many bones as you can.
 * Control: ↑
 *         ←↓→ to move; click to start/pause/resume.
 */

int MAX_POS = 11;                //12x12 grids in total
Bucket myBucket;
Dog myDog;
int remaining_bones;             //number of remaining bones
int collected_bones;             //number of bones collected
boolean circle_bone;             //whether there are remaining bones that need to be circled when myBucket arrives at myDog
Bone bones[] = new Bone[3];
int wolf_num;                    //number of wolves (between 15 and 25)
Wolf wolves[] = new Wolf[25];
boolean start = false;           //whether the game has started
int countdown = 3;               //number of seconds left before starting the next round
boolean pause = true;            //whether the game has paused
boolean lose = false;            //whether the player has hit a wolf
int lives = 3;                   //number of lives left
int total_bones = 0;             //total number of bones collected during the whole game
int red = 255;                   //how red the central rectangle of the button is
//images
PImage bone;
PImage half_bone1;
PImage half_bone2;
PImage half_bone3;
PImage dog;
PImage dog_face;
PImage sad_dog;
PImage wolf;

//****** definition of all classes ******
class Bucket {
  //myBucket is initialized at one of the four corners
  int bucket_xpos = ((int)random(0, 2)) * MAX_POS;
  int bucket_ypos = ((int)random(0, 2)) * MAX_POS;
  //Bucket() {}

  void update() {
    if (keyCode == LEFT) {
      bucket_xpos --;
    } else if (keyCode == RIGHT) {
      bucket_xpos ++;
    } else if (keyCode == UP) {
      bucket_ypos --;
    } else if (keyCode == DOWN) {
      bucket_ypos ++;
    }
    bucket_xpos = constrain(bucket_xpos, 0, MAX_POS);
    bucket_ypos = constrain(bucket_ypos, 0, MAX_POS);
  }

  void check_pos() {
    //check if player collects new bones
    for (int i = 0; i < remaining_bones; i ++) {
      if (bucket_xpos == bones[i].xpos && bucket_ypos == bones[i].ypos) {
        total_bones ++;
        collected_bones ++;
        remaining_bones --;
        //delete the collected bone from the array
        for (int j = i; j < remaining_bones; j ++) {
          bones[j] = bones[j + 1];
        }
      }
    }
    //check if player arrives at myDog
    if (bucket_xpos == myDog.xpos && bucket_ypos == myDog.ypos) {
      if (remaining_bones == 0) {  //player arrives with all bones collected--win
        countdown = 3;
        win_page();
      } else {                     //player arrives with some bones left--lose
        circle_bone = true;
        lives --;
        countdown = 3;
        background(255, 192, 203);
        show_all();
        draw_bar();
      }
    }
  }

  void show() {
    fill(255);
    pushMatrix();
    translate(bucket_xpos * 50 + 5, bucket_ypos * 50 + 5);
    //draw from bottom to top
    fill(255, 170, 0);
    quad(2, 12, 38, 12, 35, 42, 5, 42);
    rect(0, 10, 40, 5);
    arc(20, 15, 40, 8, radians(0), radians(180));
    fill(230, 153, 0);
    arc(20, 10, 40, 8, radians(0), radians(360));
    //if there are bones collected, draw them in the bucket
    if (collected_bones == 1) {
      image(half_bone1, 0, -10, 30, 30);
    } else if (collected_bones == 2) {
      image(half_bone1, -5, -10, 30, 30);
      pushMatrix();
      rotate(radians(-60));
      image(half_bone2, -2, 18, 24, 24);
      popMatrix();
    } else if (collected_bones == 3) {
      image(half_bone1, -5, -10, 30, 30);
      pushMatrix();
      rotate(radians(90));
      image(half_bone3, -10, -34, 24, 22);
      rotate(radians(-150));
      image(half_bone2, 0, 22, 24, 24);
      popMatrix();
    }
    popMatrix();
  }
}

class Bone {
  int xpos = (int)random(0, MAX_POS + 1);
  int ypos = (int)random(0, MAX_POS + 1);
  Bone(int num) {
    //prevent the bone from showing up in the same grid as myBucket or myDog
    while ((xpos == myBucket.bucket_xpos && ypos == myBucket.bucket_ypos) || (xpos == myDog.xpos && ypos == myDog.ypos)) {
      ypos = (int)random(0, MAX_POS + 1);
    }
    //prevent the bone from showing up in the same grid as another bone
    for (int i = 0; i < num; i ++) {
      while (xpos == bones[i].xpos && ypos == bones[i].ypos) {
        xpos = (int)random(0, MAX_POS + 1);
      }
    }
  }

  void show() {
    image(bone, xpos * 50, ypos * 50, 50, 60);
    //circle the bone if it's left out
    if (circle_bone) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      ellipse(xpos * 50 + 25, ypos * 50 + 30, 55, 55);
      stroke(0);
      strokeWeight(1);
    }
  }
}

class Dog {
  //myDog is initialized at the corner opposite to myBucket
  int xpos = MAX_POS - myBucket.bucket_xpos;
  int ypos = MAX_POS - myBucket.bucket_ypos;
  //Dog() {}

  void show() {
    image(dog, xpos * 50, ypos * 50, 44, 60);
  }
}

class Wolf {
  float xpos = random(0, width);
  float ypos = random(0, height);
  boolean collide = false;        //whether the wolf has hit myBucket
  Wolf() {
    //prevent the wolf from starting too close to myBucket
    while (xpos >= (myBucket.bucket_xpos - 1) * 50 && xpos <= (myBucket.bucket_xpos + 2) * 50 
      && ypos >= (myBucket.bucket_ypos - 2) * 50 && ypos <= (myBucket.bucket_ypos + 3) * 50) {
      ypos = random(-height, -100);
    }
  }

  void update() {
    //random movement downwards
    xpos += random(-1, 1);
    ypos += random(0, 2);
    //reappear on the top if it moves below the bottom
    if (ypos > height + 50) {
      ypos = -50;
    }
  }

  void show() {
    image(wolf, xpos, ypos, 50, 50);
    //cirlce the wolf if it has hit myBucket
    if (collide) {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      ellipse(xpos + 24, ypos + 23, 52, 52);
      stroke(0);
      strokeWeight(1);
    }
  }

  void detect_collision() {
    if (dist(xpos + 7, ypos, myBucket.bucket_xpos * 50, myBucket.bucket_ypos * 50) < 40) {
      collide = true;
      countdown = 3;
      show_all();
      //boolean lose is used to prevent decrementing lives for multiple times when myBucket hits more than one wolf
      lose = true;
      //lives --;
    }
  }
}  
//****** end of all the classes ******


void setup() {
  size(600, 650);
  bone = loadImage("bone.png");
  half_bone1 = loadImage("half-bone_1.png");
  half_bone2 = loadImage("half-bone_2.png");
  half_bone3 = loadImage("half-bone_3.png");
  dog = loadImage("dog.png");
  dog_face = loadImage("dog_face.png");
  sad_dog = loadImage("sad_dog.png");
  wolf = loadImage("wolf.png");
}

void draw() {
  background(255, 192, 203);      //pink background
  if (lives == 0) {               //check if game over
    start = false;
    pause = true;
    delay(1000);
  }
  if (start) {
    //3-second countdown before game starts
    if (countdown >= 0) {
      if (countdown == 3) {
        initialize();             //reinitialize after each life is lost
      }
      show_all();                 //draw all the elements during countdown
      fill(255, 0, 0);
      textSize(150);
      text(countdown, 260, 350);  //show the seconds left before game starts
      countdown --;
      delay(1000);
    } else if (countdown == -1) { //extra decrementation just to block keypress when countdown is -1
      countdown --;
    } else {
      //after game starts, draw all the elements and meanwhile update and check their position
      myDog.show();
      for (int i = 0; i < remaining_bones; i++) {
        bones[i].show();
      }
      for (int i = 0; i < wolf_num; i++) {
        if (countdown < -1 && !pause) {
          wolves[i].update();
        }
        wolves[i].show();
        wolves[i].detect_collision();
      }
      //decrement lives here for only once to prevent "double kill"
      if (lose) {
        lives --;
        lose = false;
      }
      myBucket.show();
    }
  } else {
    if (lives <= 0) {
      game_over_page();
    } else {
      home_page();
    }
  }
  draw_bar();  //draw the bar at the bottom
}

void initialize() {
  myBucket = new Bucket();
  myDog = new Dog();
  remaining_bones = (int)random(1, 4);  //randomize the total number of bones (1-3) that will show up in the next round
  collected_bones = 0;
  circle_bone = false;
  for (int i = 0; i < remaining_bones; i++) {
    bones[i] = new Bone(i);
  }
  wolf_num = (int)random(15, 26);       //randomize the total number of wolves (15-25) that will show up in the next round
  for (int i = 0; i < wolf_num; i++) {
    wolves[i] = new Wolf();
  }
}

void show_all() {
  //draw all the game elements
  myDog.show();
  for (int i = 0; i < remaining_bones; i++) {
    bones[i].show();
  }
  for (int i = 0; i < wolf_num; i++) {
    wolves[i].show();
  }
  myBucket.show();
}

void draw_bar() {
  //draw the bar at the bottom
  pushMatrix();
  translate(0, 610);      //set the origin to the top left corner of the bar
  fill(150);
  rect(0, 0, width, 40);  //background of the bar
  
  //draw the start/pause/resume button except during countdown
  if (countdown == 3 || countdown < 0) {
    fill(150, 0, 0);
    rect(0, 0, 75, 40);   //the edge of the button is darker then the center
    if (red < 255) {
      red += 2;           //gradually restore the bright red color of the central rectangle when mouse no longer hovers
    }
    if (mouseX > 6 && mouseX < 69 && mouseY > 616 && mouseY < 644) {
      red = 210;          //make the central rectangle darker when mouse hovers
    }
    fill(red, 0, 0);
    rect(6, 6, 63, 28);   //draw the central rectangle with the current redness
    fill(0);
    //decide which word to show up on the button according to the current state
    if (start) {
      if (pause) {
        textSize(15);
        text("Resume", 10, 25);
      } else {
        textSize(18);
        text("Pause", 13, 26);
      }
    } else {
      textSize(19);
      text("Start", 16, 27);
    }
  }
  
  //show the number of lives left
  line(330, 0, 330, 40);  //left border line
  for (int pos = 450; pos > 450 - lives * 50; pos -= 50) {
    image(dog_face, pos, 3, 40, 35);
  }
  line(510, 0, 510, 40);  //right border line
  
  //show the total number of bones collected
  image(bone, 530, -6, 40, 55);
  fill(0);
  textSize(20);
  text(total_bones, 575, 28);
  popMatrix();
}

void home_page() {
  stroke(255);
  noFill();
  rect(150, 150, 300, 70);
  stroke(0);
  textSize(40);
  text("Feed My Dog", 175, 200);
  image(dog, 170, 270, 150, 200);
  pushMatrix();
  rotate(radians(-10));
  image(bone, 260, 430, 100, 100);
  popMatrix();
}

void win_page() {
  background(255, 192, 203);
  image(dog, 170, 200, 150, 200);
  pushMatrix();
  rotate(radians(-10));
  image(bone, 260, 360, 100, 100);
  popMatrix();
  draw_bar();
}

void game_over_page() {
  if (lives == 0) {  //when game_over_page() is called for the 1st time: draw the game over page and prepare to call delay() in the next draw() iteration
    lives --;        //distinguish the 2nd time from the 1st time
    //draw the game over page
    image(sad_dog, 200, 250, 180, 240);
    image(bone, 210, 100, 100, 100);
    textSize(40);
    if (total_bones < 10) {
      text(total_bones, 337, 165);
    } else {
      text(total_bones, 325, 165);
    }
    noFill();
    stroke(255, 205, 215);
    rect(310, 100, 80, 100);
    stroke(0);
  } else {           //when game_over_page() is called for the 2nd time: delay for 5 seconds and reset variables
    lives = 3;
    total_bones = 0;
    delay(5000);     //keep the canvas from the previous draw() iteration, namely the game over page, for 5 seconds
  }
}

void keyPressed() {
  if (start && !pause && countdown < -1) {
    myBucket.update();
    myBucket.check_pos();
  }
}

void mousePressed() {
  if (mouseX > 6 && mouseX < 69 && mouseY > 616 && mouseY < 644 && lives > 0) {
    start = true;
    pause = !pause;
  }
}
