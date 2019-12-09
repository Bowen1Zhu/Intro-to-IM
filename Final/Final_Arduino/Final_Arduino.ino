int wheelPin = A0;
int gasPin = A1;
int brakePin = A2;

void setup() {
  Serial.begin(9600);
}

void loop() {
  // read the values from the sensors and map them to the range from -100 to 100
  int wheelValue = analogRead(wheelPin);
  if (wheelValue < 525) { //right turn
    wheelValue = map(wheelValue, 200, 525, 100, 0);
  } else {                //left turn
    wheelValue = map(wheelValue, 525, 800, 0, -100);
  }
//  Serial.println(wheelValue);
  int gasValue = analogRead(gasPin);
  gasValue = constrain(gasValue, 420, 900);
  gasValue = map(gasValue, 420, 900, 100, 0);
//  Serial.println(gasValue);
  int brakeValue = analogRead(brakePin);
  brakeValue = constrain(brakeValue, 365, 875);
  brakeValue = map(brakeValue, 365, 875, -100, 0);
//  Serial.println(brakeValue);
  int speedValue = gasValue + brakeValue; //the final acceleration value to be sent is the difference between the gas and brake readings
//  Serial.println(speedValue);

  // send the values in the following form: "wheelValue speedValue\n"
  Serial.print(wheelValue);
  Serial.print(" ");
  Serial.print(speedValue);
  Serial.print("\n");
  
  // wait a bit for the analog-to-digital converter to stabilize after the last reading
  delay(2);
}
