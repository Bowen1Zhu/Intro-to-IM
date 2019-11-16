const int buttonPins[4] = {2, 3, 4, 5};         //pin numbers of up, left, down, right buttons, respectively
int buttonStates[4] = {0, 0, 0, 0};             //state of each button
int buzzerPin = 9;
byte data;                                      //incoming serial byte: 0--start 1--win 2--lose
int totals[3] = {6, 3, 4};                      //total number of notes in each melody: 0--start melody; 1--win melody; 2--lose melody
int total = 0;                                  //total number of notes to be played
int count = 0;                                  //number of melody played
long next_time;                                 //time when the next melody should be played
//start melody
int start[6] = {262, 262, 392, 523, 392, 523};  //C4, C4, G4, C5, G4, C5
int start_duration[6] = {100, 100, 100, 300, 100, 300};
//win melody
int win[3] = {262, 392, 523};                   //C4, G4, C5
int win_duration[3] = {100, 100, 300};
//lose melody
int lose[4] = {196, 131, 196, 131};             //G3, C3, G3, C3
int lose_duration[4] = {250, 250, 250, 250};

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < 4; i ++) {
    pinMode(buttonPins[i], INPUT_PULLUP);
  }
}

void loop() {
  if (check_all_buttons_pressed()) {            //if player has justed pressed all the button, start/pause/resume
    Serial.write(4);
  } else {
    for (int i = 0; i < 4; i ++) {              //otherwise, move position
      if (!digitalRead(buttonPins[i])) {
        Serial.write(i);
      }
    }
  }
  set_buttonStates();
  delay(150);

  if (Serial.available()) {                     //if a signal to play a melody is received
    data = Serial.read();                       //read a byte from the serial port
    total = totals[data];                       //store the total number of notes to be played
    next_time = millis();                       //play the first note immediately
    count = 0;                                  //clear the number of notes played
  }
  if (count < total && millis() >= next_time) { //if it's time to play the next melody
    play_melody();
  }
}

bool check_all_buttons_pressed() {
  //check if all four buttons are pressed
  for (int i = 0; i < 4; i ++) {
    if (digitalRead(buttonPins[i])) {
      return false;
    }
  }
  //check if not all the buttons were pressed
  for (int i = 0; i < 4; i ++) {
    if (buttonStates[i] == 0) {
      return true;
    }
  }
  return false;
}

void set_buttonStates() {
  for (int i = 0; i < 4; i ++) {
    buttonStates[i] = !digitalRead(buttonPins[i]);
  }
}

void play_melody() {
  if (data == 0) {        //start melody
    tone(buzzerPin, start[count], start_duration[count]);
    next_time = millis() + start_duration[count];
    count ++;
  } else if (data == 1) { //win melody
    tone(buzzerPin, win[count], win_duration[count]);
    next_time = millis() + win_duration[count];
    count ++;
  } else if (data == 2) { //lose melody
    tone(buzzerPin, lose[count], lose_duration[count]);
    next_time = millis() + lose_duration[count];
    count ++;
  }
}
