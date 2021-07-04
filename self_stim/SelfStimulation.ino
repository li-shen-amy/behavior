const int InputPin=13;  // pin connected to infrared beam to detect nosepoke
const int PowerPin=6; // pin connected to stimulation
const int DetectInt=500;  // interval for detection
const int RewardDur=1000; // reward duration 
const int OnDur=20; // Stimulus On duration
const int OffDur=30; // Stimulus Off duration

unsigned long detectMillis=0;
unsigned long previousMillis=0;
unsigned long beginMillis=0;
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
     while (currentMillis - beginMillis <= RewardDur){
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
