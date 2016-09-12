/*
 * This is the CS-11M program template. Change this text to 
 * be the title of the assignment and a short description 
 * of what it does. 
 *  
 * Author: Michael Matera
 * Date: 8/16/2016
 * 
 */

// Pin 13 is the LED on your Arduino. This gives it a name.
int led = 13; 

void setup() {
  pinMode(led, OUTPUT);  
}


void loop() {
  digitalWrite(led, HIGH);
  delay(500);
  digitalWrite(led, LOW);
  delay(500);
}

