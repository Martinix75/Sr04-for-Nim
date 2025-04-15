import picostdlib
import picostdlib/pico/[stdio, time]
import picostdlib/hardware/[gpio]
import std/math


let sr04Ver* = "0.2.0" #libreria

type
  Measure* = enum #enumerazione per il sistema di misura.
    Cm, Inc #centimetri pollici
    
  Sr04* = object #oggetto sensore SR04
    trig, eco: Gpio #pin di trigger (innesco) e durata echo( distanza).
    distance: float #memorizza la distanza calcolata (cm o inc).
    #i_duration: AbsoluteTime #memorizza la durata dell'impulso dell'echo.
    u_measure: Measure #memorizza il sitema di misura usato.
    startTime, endTime: AbsoluteTime #variabiuli per il tempo di inizizio e fine impulso.

proc initSr04*(trig, eco: uint): Sr04 =
    let trig_c = trig.Gpio; trig_c.init(); trig_c.setDir(Out); trig_c.put(Low)
    let eco_c = eco.Gpio; eco_c.init(); eco_c.setDir(In); eco_c.pullDown()
    result = Sr04(trig: trig_c, eco: eco_c) #setta i valori iniziali.

proc pulse(self: var Sr04) = #funzione generica che crea la misura
    echo("chiamo misura")
    self.trig.put(High) #alza il pin del triger 0-->1.
    sleepUs(10) #attendi 10us.
    self.trig.put(Low) #porta a zero il trger per far partire la misura.
    while self.eco.get() == 0.Value: #aspetta che vada alto
        discard
    self.startTime = getAbsoluteTime() #prende il tempo appena va alto il pin
    while self.eco.get() == 1.Value: #aspetta finoa  quando il pin va basso
        discard
    self.endTime = getAbsoluteTime()

proc distance*(self: var Sr04; u_measure: Measure = Cm; round=1): float = #funzione a chiamata generica per la misura
    self.pulse() #chiama la funzione reale di misura
    if u_measure == Cm:
        result = round((diffUs(self.startTime, self.endTime).float / 58), round) #ritorna in cm
    elif u_measure == Inc:
        result = round((diffUs(self.startTime, self.endTime).float / 148.0), round)  #ritorna in inc
        
when isMainModule:
    stdioInitAll()
    var sens = initSr04(2, 3)
    while true:
        echo("Distanza --> ", $sens.distance(Cm,2) ," Cm")
        sleepMs(500)
