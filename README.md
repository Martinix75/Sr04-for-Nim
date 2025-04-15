# Distance sensor library SR04 written in NIM for PR2040
This library allows the operation of the SR04 sensor, with your PR2040 and NIM. Its use is really simple.
Copy the SR04.NIM file in your business directors (or in a folder where you put the various addictions). Once this is done, the library in your program with:
# impoort sr04

Now to use it, just initialize the object with:
#var sens = initSr04(trig=2, echo=3) 

Where (in this case) the PIN (Gpio) 2 will be the Trigger (starting impulse) and 3 (Gpio) will be the pin on which the echo of the impulse arrives.
The real measure of the distance will be calculated by the procedure:
# distance(Cm,2)
that the distance returns (Float) between the sensor and an object. This distance will be back in centimeters if the first topic is "cm" in inch if "inc".
The second topic (in this case 2) will be the significant figures after the comma.

Small example:
```Nim
stdioInitAll()
var sens = initSr04(2, 3)
while true:
  echo("Distance --> ", $sens.distance(Cm,2) ," Cm")
  sleepMs(500)
```
