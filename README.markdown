OVERVIEW
=========
SharpServo is a small Arduino program that pairs servo control to the Sharp IR range sensors, and manages the voltage issues typical for the Sharp IR packages.

	
Original Usage
-------------------
The original need of this project was to be able to control a servo automatically, based on how far away a person (or large object) was from the Sharp IR sensor.  As a person approached the sensor, the servo would move in one direction, and as they departed, the servo would move the opposite direction.  The codebase calibrated the entire range of the Sharp IR sensor to the 180 degree movement of a typical hobby servo.  

	
The Sharp IR Range Sensor Detail
--------------------------------
For this project, I used the Sharp long-range infrared proximity sensor, model GP2Y0A02YK0F.  It can acquire and track ranges from 15cm to 150cm, with an analog output from 2.8v to 0.4v, respectively.

Overall, the range sensor works very well, as long as it's not pointing into direct sunlight, or pointing at a very reflective surface such as a mirror or window.  I added a filtering cap across the terminals close to the sensor to clear up noise, but other than that, very stable and highly-recommended!


Code Details
-------------------------
The code in the repo was managing two sensors and two servos, with each sensor driving a single servo.  Of course you could expand this to the maximum number of pins available on the Arduino, or get a multiplexer and drive hundreds of servos and sensors. :)

I also added some servo-smoothing code to help alleviate the sometimes jumpy movement a servo can exhibit, based on the volume and delta of PCM data it receives.  It's a basic smoothing function that loads up the last N values into an array and then averages out the sum of the elements of the array.  It's simple, but effective. 55 is the current length of the smoothing buffer array, and seems to work well, but adjust to your taste (and Arduino clockspeed!) 