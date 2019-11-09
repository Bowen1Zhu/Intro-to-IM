//Visualization of UAE's Trade Partners in Asia
//Source of Data: https://wits.worldbank.org/CountryProfile/en/Country/ARE/Year/2016/TradeFlow/EXPIMP#
PImage map;
int IMG_HEIGHT = 600;
int TITLE_HEIGHT = 71;
PFont myFont;
Table table;
int total;                                //total number of countries
float min_ex = MAX_FLOAT;                 //minimum export value
float max_ex = MIN_FLOAT;                 //maximum export value
float min_im = MAX_FLOAT;                 //minimum import value
float max_im = MIN_FLOAT;                 //maximum import value
float min_pos_diff = MAX_FLOAT;           //minimum net exports
float max_pos_diff = MIN_FLOAT;           //maximum net exports
float min_neg_diff = MAX_FLOAT;           //minimum net imports
float max_neg_diff = MIN_FLOAT;           //maximum net imports
Country[] countries;
int selected_country = -1;                //current country selected by the user; -1: no country selected
float zoom = 0.8;                         //these are the variables used when zooming in
int center_x;                             //center of translation, measured in the original coordinate system
int center_y;
int original_x;                           //original position of the mouse
int original_y;
int shift_x = 0;                          //distance of mouse movement since last mouse press
int shift_y = 0;
int mouse_x;                              //equivalent position of the mouse in the original coordinate system without zooming in
int mouse_y;                              //so that we can compute the distance between the mouse and a country when zooming in
boolean left_edge = false;                //whether the edges of the map have been reached
boolean right_edge = false;
boolean upper_edge = false;
boolean lower_edge = false;
boolean zoom_in = true;                   //whether the map is zoomed in
int mode = 0;                             //dataset being displayed; 0: Total trade balance; 1: Export only; 2: Import only
int[] colors = {150, 150, 150, 150};      //current colors of the four buttons at the bottom


class Country {
  String name;                            //name of the country
  float ex, im, exp, imp, diff;           //export/import values of the country
  int xpos, ypos;                         //position of the country
  int alpha = 100;                        //transparency of the circle
  float diameter, current_diameter = 0;   //diameter of the circle
  //Country() {}

  void draw_circle() {
    if (check_selection()) {              //if the mouse hovers over the circle, increase the circle's alpha value
      alpha = 150;
    }
    if (alpha > 100) {                    //if the mouse no longer hovers, gradually decrease the alpha value
      alpha -= 5;
    }
    //set the diameter and color of the circle according to the mode selected
    if (mode == 0) {
      if (diff >= 0) {
        diameter = map(pow(diff, 0.7), pow(min_pos_diff, 0.7), pow(max_pos_diff, 0.7), 10, 100);
        fill(0, 0, 255, alpha);           //blue if exports > imports
      } else {
        diameter = map(pow(abs(diff), 0.7), pow(min_neg_diff, 0.7), pow(max_neg_diff, 0.7), 10, 100);
        fill(255, 0, 0, alpha);           //red if exports < imports
      }
    } else if (mode == 1) {
      diameter = map(pow(ex, 0.75), pow(min_ex, 0.75), pow(max_ex, 0.75), 10, 100);
      fill(0, 0, 255, alpha);
    } else {
      diameter = map(pow(im, 0.65), pow(min_im, 0.65), pow(max_im, 0.65), 10, 100);
      fill(255, 0, 0, alpha);
    }
    boolean stable = true;                //whether the diameter is still changing
    //if current diameter no longer changes, then stable is true, and make sure current diameter is exactly the value that we calculated above
    if (current_diameter < diameter) {
      current_diameter += 5;
      stable = !stable;
    }
    if (current_diameter > diameter) {
      current_diameter -= 5;
      stable = !stable;
    }
    if (stable) {
      current_diameter = diameter;
    }
    //finally, draw the circle
    stroke(0);
    ellipse(xpos, ypos, current_diameter, current_diameter);
  }

  boolean check_selection() {
    //if zoomed-in, compare the position of the country with the position of the mouse measured in the original coordinate system
    if (zoom_in) {
      if (dist(xpos, ypos, mouse_x, mouse_y) <= current_diameter / 2) {
        return true;
      }
    } else {    //otherwise, simply compare it with mouseX and mouseY
      if (dist(xpos, ypos, mouseX, mouseY) <= current_diameter / 2) {
        return true;
      }
    }
    return false;
  }

  void show_detail() {
    if (zoom_in) {
      textFont(myFont, 10);
      if (mode == 0) {
        //use blue if exports > imports, red otherwise
        if (diff >= 0) {
          fill(0, 0, 255, 225);
        } else {
          fill(255, 0, 0, 225);
        }
        stroke(0);
        triangle(xpos, ypos, xpos + 7, ypos + 3, xpos + 7, ypos + 11);
        rect(xpos + 7, ypos - 20, 145, 57, 7);
        noStroke();
        quad(xpos + 6, ypos + 3, xpos + 8, ypos + 4, xpos + 8, ypos + 11, xpos + 6, ypos + 8);
        fill(0);
        text(name, xpos + 11, ypos - 6);
        text("Export $" + nfc((int)ex) + "k", xpos + 11, ypos + 6);
        text("Import $" + nfc((int)im) + "k", xpos + 11, ypos + 18);
        if (diff >= 0) {
          text("Balance of Trade $" + nfc((int)diff) + "k", xpos + 11, ypos + 30);
        } else {
          text("Balance of Trade -$" + nfc(abs((int)diff)) + "k", xpos + 11, ypos + 30);
        }
      } else if (mode == 1) {
        stroke(0);
        fill(0, 0, 255, 225);
        triangle(xpos, ypos, xpos + 7, ypos + 3, xpos + 7, ypos + 11);
        rect(xpos + 7, ypos - 15, 132, 45, 7);
        noStroke();
        quad(xpos + 6, ypos + 3, xpos + 8, ypos + 4, xpos + 8, ypos + 11, xpos + 6, ypos + 8);
        fill(0);
        text(name, xpos + 11, ypos - 1);
        text("Export $" + nfc((int)ex) + "k", xpos + 11, ypos + 11);
        text("Export Partner Share " + String.format("%.2f", exp) + "%", xpos + 11, ypos + 23);
      } else {
        stroke(0);
        fill(255, 0, 0, 225);
        triangle(xpos, ypos, xpos + 7, ypos + 3, xpos + 7, ypos + 11);
        rect(xpos + 7, ypos - 15, 135, 45, 7);
        noStroke();
        quad(xpos + 6, ypos + 3, xpos + 8, ypos + 4, xpos + 8, ypos + 11, xpos + 6, ypos + 8);
        fill(0);
        text(name, xpos + 11, ypos - 1);
        text("Import $" + nfc((int)im) + "k", xpos + 11, ypos + 11);
        text("Import Partner Share " + String.format("%.2f", imp) + "%", xpos + 11, ypos + 23);
      }
    } else {    //if not zoomed-in, draw everything twice as big in the same position
      textFont(myFont, 20);
      //use blue if exports > imports, red otherwise
      if (mode == 0) {
        if (diff >= 0) {
          fill(0, 0, 255, 225);
        } else {
          fill(255, 0, 0, 225);
        }
        stroke(0);
        triangle(xpos, ypos, xpos + 14, ypos + 6, xpos + 14, ypos + 22);
        rect(xpos + 14, ypos - 40, 290, 114, 14);
        noStroke();
        quad(xpos + 12, ypos + 6, xpos + 16, ypos + 8, xpos + 16, ypos + 22, xpos + 12, ypos + 16);
        fill(0);
        text(name, xpos + 22, ypos - 12);
        text("Export $" + nfc((int)ex) + "k", xpos + 22, ypos + 12);
        text("Import $" + nfc((int)im) + "k", xpos + 22, ypos + 36);
        if (diff >= 0) {
          text("Balance of Trade $" + nfc((int)diff) + "k", xpos + 22, ypos + 60);
        } else {
          text("Balance of Trade -$" + nfc(abs((int)diff)) + "k", xpos + 22, ypos + 60);
        }
      } else if (mode == 1) {
        stroke(0);
        fill(0, 0, 255, 225);
        triangle(xpos, ypos, xpos + 14, ypos + 6, xpos + 14, ypos + 22);
        rect(xpos + 14, ypos - 30, 264, 90, 14);
        noStroke();
        quad(xpos + 12, ypos + 6, xpos + 16, ypos + 8, xpos + 16, ypos + 22, xpos + 12, ypos + 16);
        fill(0);
        text(name, xpos + 22, ypos - 2);
        text("Export $" + nfc((int)ex) + "k", xpos + 22, ypos + 22);
        text("Export Partner Share " + String.format("%.2f", exp) + "%", xpos + 22, ypos + 46);
      } else {
        stroke(0);
        fill(255, 0, 0, 225);
        triangle(xpos, ypos, xpos + 14, ypos + 6, xpos + 14, ypos + 22);
        rect(xpos + 14, ypos - 30, 270, 90, 14);
        noStroke();
        quad(xpos + 12, ypos + 6, xpos + 16, ypos + 8, xpos + 16, ypos + 22, xpos + 12, ypos + 16);
        fill(0);
        text(name, xpos + 22, ypos - 2);
        text("Import $" + nfc((int)im) + "k", xpos + 22, ypos + 22);
        text("Import Partner Share " + String.format("%.2f", imp) + "%", xpos + 22, ypos + 46);
      }
    }
  }
}

void setup() {
  size(835, 670);
  center_x = width/2;
  center_y = height/2;
  map = loadImage("Asia_map.jpg");
  myFont = createFont("Georgia", 36);
  read_data();
}

void draw() {
  background(255);
  if (zoom_in || zoom > 1.01) {                       //if zoomed-in, or if zoomed-out but hasn't fully restored the position
    mouse_x = mouseX;                                 //we need to keep track of the equivalent position of the mouse in the original coordinate system without zooming in
    mouse_y = mouseY;
    //constrain the center of translation so that the user cannot drag beyond the scope of the map
    if (left_edge) {
      center_x = 0;
    } else if (right_edge) {
      center_x = width;
    }
    if (upper_edge) {
      center_y = 0;
    } else if (lower_edge) {
      center_y = IMG_HEIGHT;
    }
    //when the user is dragging the map, we need to keep track of the distance shifted
    if (mousePressed) {
      shift_x = (mouseX - original_x);
      shift_y = (mouseY - original_y);
    }
    pushMatrix();
    translate(0, TITLE_HEIGHT);                       //set the origin to the upper left corner of the map
    mouse_y += TITLE_HEIGHT;                          //update the equivalent position of the mouse
    //to prevent the map from shifting out of its scope, we discuss 3x3=9 possible situations regarding its position--the last one is the normal case
    if (center_x - shift_x <= 0) {                    //if the left edge of the map is reached, ...
      left_edge = true;
      right_edge = false;
      if (center_y - shift_y <= 0) {                  //... and if the upper edge of the map is reached
        upper_edge = true;
        lower_edge = false;
        translate_and_draw(0, 0);
      } else if (center_y - shift_y >= IMG_HEIGHT) {  //... and if the lower edge of the map is reached
        lower_edge = true;
        upper_edge = false;
        translate_and_draw(0, IMG_HEIGHT);
      } else {                                        //... and if neither the upper edge nor the lower edge is reached
        upper_edge = false;
        lower_edge = false;
        translate_and_draw(0, center_y);
      }
    } else if (center_x - shift_x >= width) {         //if the right edge of the map is reached, ...
      right_edge = true;
      left_edge = false;
      if (center_y - shift_y <= 0) {                  //... and if the upper edge of the map is reached
        upper_edge = true;
        lower_edge = false;
        translate_and_draw(width, 0);
      } else if (center_y - shift_y >= IMG_HEIGHT) {  //... and if the lower edge of the map is reached
        lower_edge = true;
        upper_edge = false;
        translate_and_draw(width, IMG_HEIGHT);
      } else {                                        //... and if neither the upper edge nor the lower edge is reached
        upper_edge = false;
        lower_edge = false;
        translate_and_draw(width, center_y);
      }
    } else {                                          //if neither the left edge nor the right edge is reached, ...
      left_edge = false;
      right_edge = false;
      if (center_y - shift_y <= 0) {                  //... and if the upper edge of the map is reached
        upper_edge = true;
        lower_edge = false;
        translate_and_draw(center_x, 0);
      } else if (center_y - shift_y >= IMG_HEIGHT) {  //... and if the lower edge of the map is reached
        lower_edge = true;
        upper_edge = false;
        translate_and_draw(center_x, IMG_HEIGHT);
      } else {                                        //... and if neither the upper edge nor the lower edge is reached (in the middle--normal case)
        upper_edge = false;
        lower_edge = false;
        translate_and_draw(center_x, center_y);
      }
    }
    popMatrix();
    //gradually increment/decrement zoom after the user clicks Zoom In/Out (1 <= zoom <= 2)
    if (zoom_in) {
      if (zoom < 1.99) {
        zoom += 0.04;
      }
    } else {
      zoom -= 0.04;
    }
  } else {           //if zoomed-out and has fully restored the position
    //no translation is needed, simply draw title, map, and circles
    image(map, 0, TITLE_HEIGHT, width, IMG_HEIGHT);
    fill(0);
    textFont(myFont, 36);
    text("UAE's Trade Partners in Asia", 180, 48);
    draw_circles_and_show_detail();
  }
  draw_buttons();    //lastly, draw the four buttons at the bottom
}

void read_data() {
  table = loadTable("WITS-Partner.csv", "header");
  total = table.getRowCount();
  countries = new Country[total];
  for (int i = 0; i < total; i++) {
    //initialize each country and its data
    countries[i] = new Country();
    TableRow row = table.getRow(i);
    countries[i].name = row.getString("Partner Name");
    countries[i].ex = row.getFloat("Export (US$ Thousand)");
    countries[i].im = row.getFloat("Import (US$ Thousand)");
    countries[i].diff = countries[i].ex - countries[i].im;
    countries[i].exp = row.getFloat("Export Partner Share (%)");
    countries[i].imp = row.getFloat("Import Partner Share (%)");
    countries[i].xpos = row.getInt("capital xpos");
    countries[i].ypos = row.getInt("capital ypos");
    //record the maximum and minimum values among all coutries
    if (countries[i].ex < min_ex) {
      min_ex = countries[i].ex;
    } else if (countries[i].ex > max_ex) {
      max_ex = countries[i].ex;
    }
    if (countries[i].im < min_im) {
      min_im = countries[i].im;
    } else if (countries[i].im > max_im) {
      max_im = countries[i].im;
    }
    if (countries[i].diff >= 0) {
      if (countries[i].diff < min_pos_diff) {
        min_pos_diff = countries[i].diff;
      } else if (countries[i].diff > max_pos_diff) {
        max_pos_diff = countries[i].diff;
      }
    } else {
      if (abs(countries[i].diff) < min_neg_diff) {
        min_neg_diff = abs(countries[i].diff);
      } else if (abs(countries[i].diff) > max_neg_diff) {
        max_neg_diff = abs(countries[i].diff);
      }
    }
  }
}

void translate_and_draw(int xval, int yval) {
  //if the map hasn't reached its left or right edge, shift the map horizontally according to the mouse movement in x-direction
  if (!left_edge && !right_edge) {
    translate(shift_x, 0);
  }
  //if the map hasn't reached its upper or lower edge, shift the map vertically according to the mouse movement in y-direction
  if (!upper_edge && !lower_edge) {
    translate(0, shift_y);
  }
  //shift the map and zoom in/out according to the original center of translation
  //meanwhile, keep track of the equivalent mouse position in the original coordinate system
  translate(xval, yval);
  mouse_x += xval;
  mouse_y += yval;
  scale(zoom);
  mouse_x /= zoom;
  mouse_y /= zoom;
  translate(-xval, -yval);
  //draw the map and the title
  image(map, 0, 0, width, IMG_HEIGHT);
  fill(0);
  textFont(myFont, 36);
  text("UAE's Trade Partners in Asia", 180, -20);
  //draw circles and show details of a country, if it's selected
  translate(0, -TITLE_HEIGHT);
  draw_circles_and_show_detail();
}

void draw_circles_and_show_detail() {
  //draw circles for all countries
  for (int i = 0; i < total; i++) {
    countries[i].draw_circle();
  }
  //if a country is selected, show its information
  if (selected_country != -1) {
    countries[selected_country].show_detail();
  }
}

void draw_buttons() {
  //the button corresponding to the selected mode is always pressed
  colors[mode] = 100;
  //if the mouse hovers over a button, increase its darkness as well
  if (mouseX > 19 && mouseX < 96) {
    if (mouseY > 522 && mouseY < 551) {
      colors[0] = 100;
    } else if (mouseY > 572 && mouseY < 601) {
      colors[1] = 100;
    } else if (mouseY > 622 && mouseY < 651) {
      colors[2] = 100;
    }
  }
  if (mouseX > 715 && mouseX < 805 && mouseY > 620 && mouseY < 647) {
    colors[3] = 100;
  }
  //draw the Zoom In/Out button
  stroke(0);
  fill(90);
  rect(710, 615, 100, 37);
  fill(colors[3]);
  rect(715, 620, 90, 27);
  line(710, 615, 715, 620);
  line(810, 615, 805, 620);
  line(710, 652, 715, 647);
  line(810, 652, 805, 647);
  fill(0);
  if (zoom_in) {
    textFont(myFont, 19);
    text("Zoom Out", 718, 640);
  } else {
    textFont(myFont, 20);
    text("Zoom In", 722, 640);
  }
  //draw the mode button
  textFont(myFont, 20);
  for (int i = 0; i < 3; i ++) {
    fill(100);
    rect(15, 518, 85, 37);
    fill(colors[i]);
    rect(19, 522, 77, 29);
    line(15, 518, 19, 522);
    line(100, 518, 96, 522);
    line(15, 555, 19, 551);
    line(100, 555, 96, 551);
    fill(0);
    if (i == 0) {
      text("Total", 34, 544);
    } else if (i == 1) {
      text("Export", 27, 543);
    } else {
      text("Import", 26, 543);
    }
    translate(0, 50);
  }
  //if the mouse no longer hovers, gradually decrease its darkness
  for (int i = 0; i < 4; i ++) {
    if (colors[i] < 150) {
      colors[i] += 5;
    }
  }
}

void mousePressed() {
  //immediately after mouse press, record the original position of the mouse before it drags the map
  original_x = mouseX;
  original_y = mouseY;
  //check if any of the buttons is pressed by the mouse
  //if yes, switch to the corresponding state and no need to check selection of a country
  if (mouseX > 19 && mouseX < 96) {
    if (mouseY > 522 && mouseY < 551) {
      mode = 0;
      return;
    } else if (mouseY > 572 && mouseY < 601) {
      mode = 1;
      return;
    } else if (mouseY > 622 && mouseY < 651) {
      mode = 2;
      return;
    }
  }
  if (mouseX > 715 && mouseX < 805 && mouseY > 620 && mouseY < 647) {
    zoom_in = !zoom_in;
    return;
  }
  //if no button is pressed, check if any of the country is selected
  //if multiple circles are pressed, we choose the smallest one so that every country can be selected
  float min_diameter = MAX_FLOAT;
  for (int i = 0; i < total; i++) {
    if (countries[i].check_selection()) {
      if (countries[i].diameter < min_diameter) {
        min_diameter = countries[i].diameter;
        selected_country = i;
      }
    }
  }
  //if no country is selected, erase the original selected country if there is one
  if (min_diameter == MAX_FLOAT) {
    selected_country = -1;
  }
}

void mouseReleased() {
  //when the user stops dragging, update the new center position and clear the distance shifted
  if (!left_edge && !right_edge) {
    center_x -= shift_x;
    shift_x = 0;
  }
  if (!upper_edge && !lower_edge) {
    center_y -= shift_y;
    shift_y = 0;
  }
}
