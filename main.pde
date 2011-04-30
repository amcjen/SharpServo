#include <Servo.h> 

#define A_SERVO_PIN 10
#define B_SERVO_PIN 11

#define A_EYE_PIN 0
#define B_EYE_PIN 1

#define VOLTS_PER_UNIT .0049F        // (.0049 for 10 bit A-D)

#define SERVO_SMOOTHER_LENGTH 55

Servo aServo;
Servo bServo;

int aServoSmoother[SERVO_SMOOTHER_LENGTH];
int bServoSmoother[SERVO_SMOOTHER_LENGTH];

void setup() { 
  aServo.attach(A_SERVO_PIN);
  bServo.attach(B_SERVO_PIN);
  
  for (int i=0; i<SERVO_SMOOTHER_LENGTH; ++i) {
    aServoSmoother[i] = 0;
    bServoSmoother[i] = 0;
  }
  
  Serial.begin(9600);
} 

void loop() { 

 int distance;
 int smoothedServoValue;
 int servoPosition;
   
 distance = readDistance(B_EYE_PIN);
 smoothedServoValue = getSmoothedServoValue(distance, bServoSmoother);
 servoPosition = map(constrain(smoothedServoValue, 20, 400), 20, 400, 20, 120);
 bServo.write(servoPosition);

/* 
// Debug output if you want to see what's going on
 Serial.print(distance);
 Serial.print(':');
 Serial.print(smoothedServoValue);
 Serial.print(':');
 Serial.println(servoPosition);
 */

 distance = readDistance(A_EYE_PIN);
 smoothedServoValue = getSmoothedServoValue(distance, aServoSmoother);
 servoPosition = map(constrain(smoothedServoValue, 20, 400), 20, 400, 20, 120);
 aServo.write(180-servoPosition);

/* 
// Debug output if you want to see what's going on
 Serial.print(distance, DEC);
 Serial.print(':');
 Serial.print(smoothedServoValue, DEC);
 Serial.print(':');
 Serial.println(servoPosition, DEC);
*/

 delay(10);
} 

int convertToUnitDistance(int sensorVoltage, char unit='c') {
  float volts;
  
  volts = (float)sensorVoltage * VOLTS_PER_UNIT;
  
  if (volts < .2) {
    volts = .2;
  }
  
  switch (unit) {
     case 'i':
      return round(23.897 * pow(volts, -1.1907));
      break;
     case 'c':
      return round(60.495 * pow(volts, -1.1904));
      break;
     default:
      return volts;
  }
}

int readDistance(int eyePin) {
  return convertToUnitDistance(analogRead(eyePin));
}

int getSmoothedServoValue(float distance, int *smoother) {  
  int arraySum = 0;
 
  for (int i=0; i<SERVO_SMOOTHER_LENGTH; ++i) {
    arraySum += smoother[i];
    smoother[i] = smoother[i+1];
  }
  
  smoother[SERVO_SMOOTHER_LENGTH-1] = distance;
  arraySum += distance;
  
  return (int)(arraySum / SERVO_SMOOTHER_LENGTH);
}
