import serial

ser = serial.Serial('/dev/cu.usbmodem14201',9600)

while True:
    temp = str(ser.readline())
    lines = temp[2:3]
    print(lines)
    with open('nosepoking.csv','a') as f:
        f.write(lines+','+'\n')
        

ser.close