const int InputPin=13;
const int DetectInt=500;
const int WaterDur=1000;
const int OnDur=20;
const int OffDur=30;
unsigned long detectMillis=0;
unsigned long previousMillis=0;
unsigned long beginMillis=0;
unsigned int PowerPin=6;
unsigned long currentMillis=0;
//unsigned int EnablePin=12;
void setup() {
  // put your setup code here, to run once:
  pinMode(InputPin, INPUT);
  // pinMode(EnablePin, INPUT);
  pinMode(PowerPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  //if (digitalRead(EnablePin) == HIGH){
  // put your main code here, to run repeatedly:
   currentMillis = millis();
   while (currentMillis - detectMillis <= DetectInt){
    currentMillis = millis();
    //Serial.println(currentMillis);
   }
   detectMillis=currentMillis;
   
   if (digitalRead(InputPin) == HIGH){
    Serial.println("1");
    beginMillis= millis();
        currentMillis = millis();
     while (currentMillis - beginMillis <= WaterDur){
          previousMillis = millis();
          analogWrite(PowerPin,255);
    currentMillis = millis();
     while (currentMillis - previousMillis <= OnDur){
       currentMillis = millis();
     }
      previousMillis = millis();
       analogWrite(PowerPin,0);
        currentMillis = millis();
     while (currentMillis - previousMillis <= OffDur){
       currentMillis = millis();
     }
    //Serial.println(currentMillis);
   }
   }
   else {
     analogWrite(PowerPin,0);
    Serial.println("0");   
   }
  //}
}
