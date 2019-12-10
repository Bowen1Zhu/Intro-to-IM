import processing.serial.*;

Serial myPort;

//images
PImage grass;
PImage curb1;
PImage curb2;
PImage gasoline;
PImage life;
PImage coin;
PImage coins;
PImage game_over;
PImage highscore;
int car_total = 10;
PImage car_images[] = new PImage[car_total];
Car cars[] = new Car[car_total];
Car backup_cars[] = new Car[car_total];
boolean activated;                  //whether backup cars are activated (when the speed is too slow)

boolean start = false;              //whether the player has pushed the gas pedal to start the game
float v = 0;                        //velocity of the car
float a = 0;                        //acceleration of the car
float direction = 0;                //direction of the car

float dist = 0;                     //distance travelled
int MAX_GAS = 125;                  //maximum gas amount
float gas = MAX_GAS;                //the amount of gas left
int MAX_TWINKLE = 120;              //total time when the player won't lose after the extra life is triggered
int twinkle = 0;                    //the amount of time left before the effect of extra life stops; twinkle = MAX_TWINKLE means an extra life
int bonus = 0;                      //bonus collected just now, which will be added to total_bonus
int copy_bonus;                     //a copy of bonus collected just now, which will appear on the screen and won't decrease
int total_bonus = 0;                //total money collected

int gameover = 0;                   //0--game continues; 1--game ends and show score; 2--game ends and show scoreboard
long gameover_time;                 //elapsed time after gameover
Score top_scores[] = new Score[5];  //score array to store the five highest scores
int rank = 5;                       //variable to calculate the player's rank

//size constants
float grass_ypos = 10;
int grass_width = 100;
int curb_width = 30;
int drive_width = 100;
int line_width = 5;
int car_width = 70;
int car_length = 125;

//game elements
Gas g;
Life l;
Coin c;
myCar myCar;
int myCar_ypos = 550;                       //fix the car's y-position
int myCar_num = (int)random(0, car_total);  //randomize the appearance of the player's car
long car_change_interval = 0;               //elapsed time after the player changes the car's apprearance

//the player's car
class myCar {
  float xpos = random(140, 560);            //randomize the car's initial x-position
  //whether the car stays dangerously close to other cars or the curb
  boolean left_danger;
  boolean right_danger;
  boolean rear_danger;
  //array to store the data of the car's emissions
  CarEmission emissions[] = new CarEmission[30];
  //number of objects in the array
  int arr_size = 0;
  boolean light = false;                    //whether the headlights are on/off

  void update() {
    //keyboard control--uncomment this and delete the Serial parts to play with keyboard
    //if (keyPressed) {
    //  if (keyCode == LEFT) {
    //    if (direction <= 2) {
    //      direction --;
    //    } else {
    //      direction -= 3;
    //    }
    //    direction = constrain(direction, -60, 60);
    //  } else if (keyCode == RIGHT) {
    //    if (direction >= -2) {
    //      direction ++;
    //    } else {
    //      direction += 3;
    //    }
    //    direction = constrain(direction, -60, 60);
    //  } else if (keyCode == UP) {
    //    a += 0.005;
    //    a = constrain(a, 0, 0.2);
    //  } else if (keyCode == DOWN) {
    //    a -= 0.03;
    //  }
    //} else {
    //  a = 0;
    //}
    
    //update the car's x-position
    xpos += (direction * min(v, 15) * 0.01);
    
    //clear the radar detector
    left_danger = false;
    right_danger = false;
    rear_danger = false;

    //update car emissions
    for (int i = 0; i < arr_size; i ++) {
      emissions[i].update();
    }
    //delete the objects that have disappeared
    if (arr_size > 0) {
      while (emissions[0].alpha < 0) {  //the first object has disappeared
        arr_size --;
        //shift the remaining objects in the array
        for (int i = 0; i < arr_size; i ++) {
          emissions[i] = emissions[i + 1];
        }
        if (arr_size == 0) {
          break;
        }
      }
    }
    //generate car emissions if the car is accelerating
    if (a > 0) {
      if (frameCount % 2 == 0) {
        emissions[arr_size] = new CarEmission();
        arr_size ++;
      }
    }
  }

  void check_pos() {
    float margin = 20 + abs(direction) / 2;
    if (xpos - margin / 2 < grass_width + curb_width || xpos + car_width + margin / 2 > width - grass_width - curb_width) {  //whether the car stays dangerously close to the curb
      //set the corresponding variable to true
      if (xpos - margin / 2 < grass_width + curb_width) {
        left_danger = true;
      } else {
        right_danger = true;
      }
      if (xpos + margin / 2 < grass_width + curb_width || xpos + car_width - margin / 2 > width - grass_width - curb_width) {  //whether the car has hit the curb
        //game ends
        gameover = 1;
        gameover_time = millis();
      }
    }
  }

  void show() {
    pushMatrix();
    if (twinkle % 12 < 6) {
      //draw the car
      translate(xpos, myCar_ypos);
      translate(car_width / 2, 0);
      rotate(radians(direction * min(v, 15) * 0.05));
      image(car_images[myCar_num], -car_width / 2, 0, car_width, car_length);
      rotate(-radians(direction * min(v, 15) * 0.05));
      translate(-car_width / 2, 0);
      //draw the emissions
      for (int i = 0; i < arr_size; i ++) {
        emissions[i].show();
      }
      //draw the headlights
      if (light) {
        noStroke();
        fill(255, 255, 255, 100);
        pushMatrix();
        //tweak its y-position according to the car's appearance
        if (myCar_num == 0 || myCar_num == 1) {
          translate(0, -2);
        } else if (myCar_num == 3 || myCar_num == 5) {
          translate(0, 2);
        } else if (myCar_num == 4) {
          translate(0, 4);
        } else if (myCar_num == 8) {
          translate(0, 5);
        } else if (myCar_num == 6 || myCar_num == 7) {
          translate(0, 6);
        }
        translate(34, 10);
        //draw the left headlight
        pushMatrix();
        rotate(radians(direction * min(v, 15) * 0.05));
        quad(-18, 1, -12, 0, -6, -30, -24, -30);
        popMatrix();
        //tweak the x-position of the right headlight according to the car's appearance
        if (myCar_num == 3 || myCar_num == 6 || myCar_num == 7 || myCar_num == 8) {
          translate(3, 0);
        } else if (myCar_num == 5) {
          translate(6, 0);
        } else if (myCar_num == 9) {
          translate(-2, 0);
        }
        //draw the right headlight
        pushMatrix();
        rotate(radians(direction * min(v, 15) * 0.05));
        quad(18, 1, 12, 0, 6, -30, 24, -30);
        popMatrix();
        popMatrix();
      }
    }
    
    //show the warnings
    if (twinkle < 12 || twinkle == MAX_TWINKLE) {
      if (left_danger) {
        fill(255, 0, 0);
        textSize(50);
        text("!", -10, 30);
        noFill();
        stroke(255, 0, 0);
        ellipse(-3, 12, 50, 50);
      }
      if (right_danger) {
        fill(255, 0, 0);
        textSize(50);
        text("!", car_width, 30);
        noFill();
        stroke(255, 0, 0);
        ellipse(car_width + 8, 12, 50, 50);
      }
      if (rear_danger) {
        fill(255, 0, 0);
        textSize(50);
        text("!", (car_width - 10) / 2, car_length + 30);
        noFill();
        stroke(255, 0, 0);
        ellipse(car_width / 2 + 3, car_length + 12, 50, 50);
      }
    }
    popMatrix();
  }
}

//other cars
class Car {
  //randomize the position and appearance of the car
  int car_num = myCar_num;
  float xpos = grass_width + curb_width + (int)(random(0, 5)) * (drive_width + line_width) + random(0, 25);
  float ypos;
  boolean backup;

  Car(int i, boolean _backup) {
    while (car_num == myCar_num) {  //make sure other cars look different from the player's car
      car_num = (int)random(0, car_total);
    }
    ypos = -180 - i * 180 + random(0, 25);
    backup = _backup;               //store whether it's a backup car
  }

  void update() {
    if (start) {
      ypos += ((v - 5) * (1 - abs(direction) / 150));  //update the car's y-position
    }
    //recycle the normal cars
    if (!backup && ypos > 2 * height) {                //if the car falls behind
      ypos -= 2 * (height + 180);                      //reposition it in the front
      xpos = grass_width + curb_width + (int)(random(0, 5)) * (drive_width + line_width) + random(0, 25);  //randomize its x-position again
    }
  }

  void check_pos() {
    if (ypos > myCar_ypos - car_length && ypos < myCar_ypos + car_length) {
      if (xpos > myCar.xpos - car_width && xpos < myCar.xpos + car_width) {  //whether this car is dangerously close to the player
        //set the corresonding variable the true
        if (ypos >= myCar_ypos + car_length / 2) {
          myCar.rear_danger = true;
        } else if (xpos < myCar.xpos) {
          myCar.left_danger = true;
        } else {
          myCar.right_danger = true;
        }
        float margin = 20 + abs(direction) / 2.5;
        if (ypos - margin > myCar_ypos - car_length && ypos + margin < myCar_ypos + car_length) {
          if (xpos - margin > myCar.xpos - car_width && xpos + margin < myCar.xpos + car_width) {  //whether this car has been hit by the player
            //game ends
            gameover = 1;
            gameover_time = millis();
          }
        }
      }
    }
  }

  void show() {
    //draw the car
    image(car_images[car_num], xpos, ypos, car_width, car_length);
  }
}

class CarEmission {
  float xpos = car_width * 0.75;
  float ypos = car_length;
  float xv = random(-0.6, 0.6);  //horizontal velocity
  float yv = random(0, 1.2);     //vertical velocity
  int alpha = 255;               //transparency

  void update() {
    xpos += xv;
    ypos += yv;
    alpha -= 8;
  }

  void show() {
    noStroke();
    fill(80, alpha);
    ellipse(xpos, ypos, 10, 10);
  }
}

class Gas {
  int size = 70;
  //randomize the position of the next gas
  float xpos = grass_width + curb_width + (int)(random(0, 5)) * (drive_width + line_width) + random(0, 25);
  float ypos = random(-height * 1.5, -height / 1.5);

  Gas(boolean initial) {
    //set its initial value
    if (initial) {
      ypos = -height * 3;
    }
  }

  void update() {
    //update its y-position
    ypos += (v * (1 - abs(direction) / 150));
  }
  
  boolean check_pos() {  //return true if it needs to be reinitialized, false otherwise
    if (ypos - 40 > myCar_ypos - size && ypos + 15 < myCar_ypos + car_length) {
      if (xpos - 15 > myCar.xpos - size && xpos + 15 < myCar.xpos + car_width) {  //if it is reached by the player
        //add half of the maximum gas
        gas += MAX_GAS / 2;
        if (gas > MAX_GAS) {  //if gas exceeds the maximum
          //convert it to money
          bonus = (int)gas - MAX_GAS;
          copy_bonus = bonus;
          gas = MAX_GAS;
        }
        return true;  //it needs to be reinitialized
      }
    }
    if (ypos > height) {  //if it falls below the screen
      return true;  //it needs to be reinitialized
    }
    return false;
  }

  void show() {
    //draw the icon
    image(gasoline, xpos, ypos, size, size);
  }
}

class Life {
  int size = 70;
  //randomize the position of the next extra life
  float xpos = grass_width + curb_width + (int)(random(0, 5)) * (drive_width + line_width) + random(0, 25);
  float ypos = random(-height * 5, -height * 4);

  Life(boolean initial) {
    //set its initial value
    if (initial) {
      ypos = -height * 4;
    }
  }
  
  void update() {
    //update its y-position
    ypos += (v * (1 - abs(direction) / 150));
  }

  boolean check_pos() {  //return true if it needs to be reinitialized, false otherwise
    if (ypos - 40 > myCar_ypos - size && ypos + 15 < myCar_ypos + car_length) {
      if (xpos - 15 > myCar.xpos - size && xpos + 15 < myCar.xpos + car_width) {  //if it is reached by the player
        //record the extra life
        twinkle = MAX_TWINKLE;
        return true;  //it needs to be reinitialized
      }
    }
    if (ypos > height) {  //if it falls below the screen
      return true;  //it needs to be reinitialized
    }
    return false;
  }

  void show() {
    //draw the icon
    image(life, xpos, ypos, size, size);
  }
}

class Coin {
  int size = 90;
  //randomize the position of the next extra life
  float xpos = grass_width + curb_width + (int)(random(0, 5)) * (drive_width + line_width) + random(-8, 20);
  float ypos = random(-height * 2, -height);

  void update() {
    //update its y-position
    ypos += (v * (1 - abs(direction) / 150));
  }

  boolean check_pos() {  //return true if it needs to be reinitialized, false otherwise
    if (ypos - 50 > myCar_ypos - size && ypos + 25 < myCar_ypos + car_length) {
      if (xpos - 25 > myCar.xpos - size && xpos + 25 < myCar.xpos + car_width) {  //if it is reached by the player
        //add $100
        bonus = 100;
        copy_bonus = bonus;
        return true;  //it needs to be reinitialized
      }
    }
    if (ypos > height) {  //if it falls below the screen
      return true;  //it needs to be reinitialized
    }
    return false;
  }

  void show() {
    //draw the icon
    image(coin, xpos, ypos, size, size);
  }
}

class Score {
  String name = null;
  int score = 0;
}


void setup() {
  size(780, 768);
  //load images
  grass = loadImage("grass.png");
  curb1 = loadImage("curb1.png");
  curb2 = loadImage("curb2.png");
  gasoline = loadImage("gas.png");
  life = loadImage("life.png");
  coin = loadImage("coin.png");
  coins = loadImage("coin stack.png");
  game_over = loadImage("game over.png");
  highscore = loadImage("highscore.png");
  //load images from "car1.png" to "car10.png"
  for (int i = 0; i < car_total; i ++) {
    String str = "car" + (i + 1) + ".png";
    car_images[i] = loadImage(str);
  }
  
  //initialize cars
  myCar = new myCar();
  for (int i = 0; i < car_total; i ++) {
    cars[i] = new Car(i, false);
  }
  for (int i = 0; i < car_total; i ++) {
    backup_cars[i] = new Car(i, true);
  }
  //initialize elements
  g = new Gas(true);
  l = new Life(true);
  c = new Coin();
  //initialize five empty scores
  for (int i = 0; i < 5 ; i ++) {
    top_scores[i] = new Score();
  }
  
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');  //don't generate a serialEvent() until a newline character
}

void draw() {
  if (gameover == 0 || twinkle > 0) {  //if game is not over or there's an extra life to save the player
    if (gameover != 0) {  //if the game is over, then use the extra life
      twinkle --;     //decrement twinkle
      gas = MAX_GAS;  //fuel up the car
      gameover = 0;   //set gameover back to zero
    }
    if (twinkle > 0 && twinkle != MAX_TWINKLE) {  //if twinkle is decreasing, which means the extra life is being used
      twinkle --;  //decrement it till zero
    }

    background(45, 45, 60);  //clear the screen
    
    if (!start && a > 0) {   //if the game hasn't started and the gas pedal is pushed
      start = true;  //start the game
    }

    //update velocity
    v += a;
    // 1x friction for real velocity below 120KPH
    // 2x friction for real velocity between 120-150KPH
    // 3x friction for real velocity above 150KPH
    if (v < 13.33) {
      v -= 0.01;
    } else if (v < 16.67) {
      v -= 0.02;
    } else {
      v -= 0.03;
    }
    //set speed limit--200KPH
    v = constrain(v, 0, 22.222222);
    //increase the distance travelled
    dist += v * 0.05;
    if (gas > 0) {
      //decrease the amount of gas left
      if (v > 0) {
        //for speed below 30KPH, gas is consumed at a rate proportional to speed
        if (v < 3.33) {
          gas -= (0.05 + map(v, 0, 3.33, 0, 0.05));
        } else {
          // 1x gas consumption rate for the first 500m
          // 1.25x gas consumption rate for the next 500m
          // 1.5x gas consumption rate after the first 1km
          if (dist < 500) {
            gas -= 0.1;
          } else if (dist < 1000) {
            gas -= 0.125;
          } else {
            gas -= 0.15;
          }
        }
      } else {  //if the car is not moving, set its direction back to zero
        direction = 0;
      }
    } else {  //the player runs out of gas
      //game ends
      gameover = 1;
      gameover_time = millis();
    }

    if (bonus > 0) {
      //add the bonus to the total
      //the more the bonus, the faster it is added
      if (bonus > 50) {
        bonus -= 6;
        total_bonus += 6;
      } else if (bonus > 2) {
        bonus -= 2;
        total_bonus += 2;
      } else {
        total_bonus += bonus;
        bonus = 0;
      }
    }

    update_road();
    //process gas
    g.update();
    if (g.check_pos()) {
      g = new Gas(false);
    }
    g.show();
    //process extra life when the player hasn't collected one
    if (twinkle == 0) {
      l.update();
      if (l.check_pos()) {
        l = new Life(false);
      }
      l.show();
    }
    //process coin
    c.update();
    if (c.check_pos()) {
      c = new Coin();
    }
    c.show();
    //process the player's car
    myCar.update();
    myCar.check_pos();

    if (start && v <= 5) {  //if the player is driving more slowly than other cars
      if (!activated) {  //if backup cars are not activated yet
        //activate them
        for (int i = 0; i < car_total; i ++) {
          backup_cars[i].ypos = 2 * height + i * 180 + random(0, 25);
        }
        activated = true;
      }
      //update backup cars which will come from behind to urge the player
      for (int i = 0; i < car_total; i ++) {
        backup_cars[i].update();
        backup_cars[i].check_pos();
        backup_cars[i].show();
      }
    } else {  //the driver is driving faster than other cars; no need to activate backup cars
      if (backup_cars[0].ypos < height) {
        //keep updating backup cars until they fall below the screen
        for (int i = 0; i < car_total; i ++) {
          backup_cars[i].update();
          backup_cars[i].check_pos();
          backup_cars[i].show();
        }
      } else {
        //deactivate backup cars after they fall below the screen so that they can be reactivated in the future
        activated = false;
      }
    }

    //process normal cars
    for (int i = 0; i < car_total; i ++) {
      cars[i].update();
      cars[i].check_pos();
      cars[i].show();
    }
    
    //draw the player's car
    myCar.show();

    //update the background y-position
    grass_ypos += (v * (1 - abs(direction) / 150));
    //recycle the image so that it will reappear from the top
    if (grass_ypos >= height) {
      grass_ypos = 0;
    }
    
    //draw sidebars
    side_bar();
  } else {  //the game is really over
    if (millis() - gameover_time < 2000) {
      if (millis() - gameover_time < 1000) {
        //in the first two seconds, show the gameover page
        tint(0, 0, 200, 10);
        image(game_over, 190, 150, 400, 300);
        noTint();
        strokeWeight(16);
        stroke(50, 50, 150, 100);
        noFill();
        rect(182, 142, 416, 316, 25);
      }
    } else {
      int score = (int)dist + total_bonus;  //the total score is the sum of the distance travelled and the money collected
      if (gameover == 1 || millis() - gameover_time < 3000) {
        //show the player's score before the player presses the keyboard; show the score for at least one second even if keyboard is pressed earlier
        show_score(score);
      } else {
        //show the scoreboard after at least three seconds and after the player presses the keyboard
        update_show_scoreboard(score);
      }
    }
  }
  //println(mouseX + " " + mouseY);
}

void update_road() {
  //draw background twice to cover the whole screen
  //draw background from y-position grass_ypos-height to grass_ypos
  grass_ypos -= height;
  image(grass, 0, grass_ypos, grass_width, height);
  image(curb1, grass_width, grass_ypos, curb_width, height);
  image(grass, width - grass_width, grass_ypos, grass_width, height);
  image(curb2, width - grass_width - curb_width, grass_ypos, curb_width, height);
  //draw background from y-position grass_ypos to grass_ypos+height
  grass_ypos += height;
  image(grass, 0, grass_ypos, grass_width, height);
  image(curb1, grass_width, grass_ypos, curb_width, height);
  image(grass, width - grass_width, grass_ypos, grass_width, height);
  image(curb2, width - grass_width - curb_width, grass_ypos, curb_width, height);

  //draw the lines on the road
  strokeWeight(5);
  stroke(255);
  for (float line_ypos = grass_ypos % drive_width - drive_width; line_ypos < height; line_ypos += drive_width) {
    for (int line_xpos = grass_width + curb_width + drive_width; line_xpos <= 545; line_xpos += drive_width + line_width) {
      line(line_xpos, line_ypos, line_xpos, line_ypos + 35);
    }
  }
}

void side_bar() {
  //speed
  noStroke();
  fill(0, 200);
  rect(320, 15, 140, 50, 10);
  textSize(30);
  int real_v = (int)(v * 9);  //real velocity = velocity x 9
  if (real_v < 120) {
    fill(255);  //speed meter will turn red for speed above 120KPH
  } else {
    fill(255, 0, 0);
  }
  if (real_v < 10) {
    text(real_v, 350, 50);
  } else if (real_v < 100) {
    text(real_v, 340, 50);
  } else {
    text(real_v, 328, 50);
  }
  fill(255);
  text("KPH", 388, 50);

  //distance
  fill(0, 200);
  if (dist < 1000) {
    rect(665, 15, 120, 50, 10);
    fill(255);
    if (dist < 10) {
      text((int)dist, 710, 50);
    } else if (dist < 100) {
      text((int)dist, 695, 50);
    } else {
      text((int)dist, 680, 50);
    }
  } else if (dist < 10000) {
    rect(640, 15, 145, 50, 10);
    fill(255);
    text((int)dist / 1000 + "," + nf((int)dist % 1000, 3), 653, 50);  //insert comma into the number
  } else {
    rect(625, 15, 160, 50, 10);
    fill(255);
    text((int)dist / 1000 + "," + nf((int)dist % 1000, 3), 635, 50);  //insert comma into the number
  }
  text("m", 740, 50);

  //bonus
  textSize(28);
  fill(0, 200);
  if (total_bonus < 1000) {
    rect(665, 80, 120, 50, 10);
    if (bonus > 0) {
      fill(255, 170, 0);  //the number will turn yellow when money is being added
    } else {
      fill(255);
    }
    if (total_bonus < 10) {
      text(total_bonus, 710, 115);
    } else if (total_bonus < 100) {
      text(total_bonus, 695, 115);
    } else {
      text(total_bonus, 680, 115);
    }
  } else {
    rect(650, 80, 145, 50, 10);
    if (bonus > 0) {
      fill(255, 170, 0);  //the number will turn yellow when money is being added
    } else {
      fill(255);
    }
    text((int)total_bonus / 1000 + "," + nf((int)total_bonus % 1000, 3), 655, 115);  //insert comma into the number
  }
  image(coins, 743, 90, 30, 30);
  textSize(26);
  if (bonus > 0) {  //if there is money to be added
    fill(0, 200);
    //show copy_bonus because this variable doesn't decrease as bonus does
    if (copy_bonus < 100) {
      rect(665, 140, 74, 45, 10);
      fill(255);
      text("+" + copy_bonus, 675, 172);
    } else {
      rect(665, 140, 86, 45, 10);
      fill(255);
      text("+" + copy_bonus, 670, 172);
    }
  }

  //gas
  fill(0, 180);
  rect(0, 15, 130, 55);
  fill(0, 150);
  rect(130, 15, 60, 55, 0, 10, 10, 0);
  image(gasoline, -5, 12, 60, 60);
  strokeWeight(4);
  if (gas > MAX_GAS / 4) {
    stroke(0);
  } else {
    stroke(150, 0, 0);  //the rectangle will turn red when the player doesn't have enough gas
  }
  fill(255, 0, 0, 50);
  rect(44, 34, 130, 24);
  noStroke();
  fill(255, 0, 0);
  rect(47, 37, gas, 19);  //display the amount of gas left

  //life
  fill(0, 180);
  rect(-10, 85, 90, 70, 10);
  if (twinkle % 12 > 6 || twinkle == MAX_TWINKLE) {  //the life icon will twinkle along with the car when the extra life is triggered
    image(life, 3, 85, 72, 72);
  }
}

void show_score(int score) {
  noStroke();
  fill(20, 0, 100);
  rect(190, 150, 400, 300, 15);
  fill(255, 255, 0);
  textSize(50);
  if (score >= top_scores[4].score) {
    text("SCORE", 315, 235);
    pushMatrix();
    translate(400, 145);
    rotate(radians(22));
    image(highscore, 0, 0, 150, 50);  //indicate that it's among the five best scores
    popMatrix();
  } else {
    text("SCORE", 315, 230);
  }
  
  fill(255);
  textSize(40);
  if (dist < 10) {
    text((int)dist, 395, 300);
  } else if (dist < 100) {
    text((int)dist, 375, 300);
  } else if (dist < 1000) {
    text((int)dist, 350, 300);
  } else if (dist < 10000) {
    text((int)dist / 1000 + "," + nf((int)dist % 1000, 3), 313, 300);  //insert comma into the number
  } else {
    text((int)dist / 1000 + "," + nf((int)dist % 1000, 3), 295, 300);  //insert comma into the number
  }
  text("m", 430, 300);
  
  if (total_bonus < 10) {
    text(total_bonus, 395, 350);
  } else if (total_bonus < 100) {
    text(total_bonus, 377, 350);
  } else if (total_bonus < 1000) {
    text(total_bonus, 352, 350);
  } else {
    text((int)total_bonus / 1000 + "," + nf((int)total_bonus % 1000, 3), 312, 350);  //insert comma into the number
  }
  image(coins, 433, 315, 42, 42);
  
  stroke(255);
  strokeWeight(5);
  line(285, 370, 500, 370);
  if (score < 10) {
    text(score, 395, 418);
  } else if (score < 100) {
    text(score, 377, 418);
  } else if (score < 1000) {
    text(score, 352, 418);
  } else {
    text((int)score / 1000 + "," + nf((int)score % 1000, 3), 312, 418);  //insert comma into the number
  }
  
  strokeWeight(16);
  stroke(50, 50, 150, 100);
  noFill();
  rect(182, 142, 416, 316, 25);
}

void update_show_scoreboard(int score) {
  if (rank == 5) {  //the rank hasn't been computed yet
    rank = 4;  //mark the rank as computed
    //compute the rank
    while (rank >= 0) {
      if (score >= top_scores[rank].score) {
        rank --;
      } else {
        break;
      }
    }
    if (rank < 4) {  //the score is among the five best ones
      //shift the scores smaller than the new score
      for (int i = 4; i > rank + 1; i --) {
        top_scores[i].name = top_scores[i - 1].name;
        top_scores[i].score = top_scores[i - 1].score;
      }
      //store the new score
      top_scores[rank + 1].score = score;
      top_scores[rank + 1].name = "";
    }
    //these only need to be drawn once:
    noStroke();
    fill(20, 0, 100);
    rect(190, 100, 400, 410, 15);
    fill(255, 255, 0);
    textSize(30);
    text("RANKING BOARD", 275, 150);
    fill(255);
    textSize(22);
    text("Rank       Score        Name", 240, 190);
    strokeWeight(16);
    stroke(50, 50, 150, 240);
    noFill();
    rect(182, 92, 416, 425, 25);
  }
  //background of each score
  strokeWeight(45);
  for (int i = 225; i <= 465; i += 60) {
    line(240, i, 540, i);
  }
  //write the data
  textSize(25);
  for (int i = 0; i < 5; i ++) {
    if (i == rank + 1) {
      fill(255, 255, 0);  //if the new score is among the five best ones, show it in yellow
    } else {
      fill(255);
    }
    if (top_scores[i].name != null) {
      //write the rank
      text(i + 1, 257, 236 + i * 60);
      //write the score
      if (top_scores[i].score < 1000) {
        text(top_scores[i].score, 345, 236 + i * 60);
      } else {
        text((int)top_scores[i].score / 1000 + "," + nf((int)top_scores[i].score % 1000, 3), 335, 236 + i * 60);  //insert comma into the number
      }
      //write the name
      float w = textWidth(top_scores[i].name);
      text(top_scores[i].name, 482 - w / 2, 236 + i * 60);
    } else {  //if there are less then five scores, there's no need to write more
      break;
    }
  }
}

void reinitialize() {
  //reinitialize the follwing variables before the next game:
  myCar_num = (int)random(0, car_total);
  myCar = new myCar();
  for (int i = 0; i < car_total; i ++) {
    cars[i] = new Car(i, false);
  }
  for (int i = 0; i < car_total; i ++) {
    backup_cars[i] = new Car(i, true);
  }
  activated = false;
  g = new Gas(true);
  l = new Life(true);
  c = new Coin();
  start = false;
  v = 0;
  a = 0;
  direction = 0;
  dist = 0;
  gas = MAX_GAS;
  bonus = 0;
  total_bonus = 0;
  gameover = 0;
  rank = 5;
}

void keyPressed() {
  if (keyCode != LEFT && keyCode != RIGHT && keyCode != UP && keyCode != DOWN) {
    if (gameover == 0) {
      myCar.light = !myCar.light;  //the keyboard is the headlight switch during the game
    } else if (gameover == 1) {
      gameover ++;  //press the keyboard after the player's score is shown to proceed to the scoreboard
    } else if (gameover == 2) {
      if (key == '\n' && millis() - gameover_time > 3000) {
        reinitialize();  //press enter when the scoreboard is shown to restart the game
      }
      //if the new score is among the five best ones, the player can type in his/her name on the scoreboard
      if (rank < 4) {
        if (keyCode == 8) {
          if (top_scores[rank + 1].name.length() > 0) {
            top_scores[rank + 1].name = top_scores[rank + 1].name.substring(0, top_scores[rank + 1].name.length() - 1);  //press backspace to delete a character, if there's any
          }
        } else {
          top_scores[rank + 1].name += key;
        }
      }
    }
  } else {
    //the player can select the car's appearance before the game using LEFT and RIGHT on the keyboard 
    if (!start) {
      if (keyCode == LEFT) {
        if (myCar_num == 0) {
          myCar_num = car_total;
        }
        myCar_num --;
      } else if (keyCode == RIGHT) {
        if (myCar_num == car_total - 1) {
          myCar_num = -1;
        }
        myCar_num ++;
      }
      for (int i = 0; i < car_total; i ++) {
        cars[i] = new Car(i, false);
      }
      for (int i = 0; i < car_total; i ++) {
        backup_cars[i] = new Car(i, true);
      }
    }
  }
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    int i = inString.indexOf(" ");
    //parse the pedal value from Arduino
    String pedals = inString.substring(i + 1, inString.length() - 1);
    a = parseInt(pedals);
    if (a < 0 && v > 3.33) {
      a *= 3;  //the brake is more sensitive when speed is above 30KPH
    }
    a /= 600;
    
    //parse the wheel value from Arduino
    inString = inString.substring(0, i);
    float d = parseInt(inString);
    if (start) {
      //restoring direction is easier than increasing direction
      if (direction / d < 0) {
        if (abs(direction) > 20) {
          d *= 2;
        }
        d *= 3;
      } else if (abs(direction) > 20) {
        d /= 2;
      }
      d /= 300;
      direction += d;
      direction = constrain(direction, -60, 60);  //prevent the direction from becoming too large
    } else if (millis() - car_change_interval > 1000) {
      //before the game starts, the player can select the car's appearance every second by rotating the steering wheel to one end
      if (d > 90) {
        if (myCar_num == car_total - 1) {
          myCar_num = -1;
        }
        myCar_num ++;
        car_change_interval = millis();
        for (int j = 0; j < car_total; j ++) {
          cars[j] = new Car(j, false);
        }
        for (int j = 0; j < car_total; j ++) {
          backup_cars[j] = new Car(j, true);
        }
      } else if (d < -90) {
        if (myCar_num == 0) {
          myCar_num = car_total;
        }
        myCar_num --;
        car_change_interval = millis();
        for (int j = 0; j < car_total; j ++) {
          cars[j] = new Car(j, false);
        }
        for (int j = 0; j < car_total; j ++) {
          backup_cars[j] = new Car(j, true);
        }
      }
    }
  }
}
