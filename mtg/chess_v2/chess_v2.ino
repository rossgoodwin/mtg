// in ports and out ports
int out[8] = {
  23, 22, 24, 26, 28, 30, 32, 34};
int in[8] = {
  40, 42, 44, 46, 48, 50, 52, 53};
  
int switchPin = 2;

char files[9] = "hgfedcba";
char ranks[9] = "12345678";

// board squares
String squares[64];

// square status arrays
int sqStatus[64];
int sqStatus1[64];

// origin and dest squares
String originSq;
String destSq;

// boolean move-in-progress
boolean moveinprogress = false;

// frame count starts at zero
//long count = 0;
unsigned long time = 0;
unsigned long checkTime1 = 0;
unsigned long checkTime2 = 0;
unsigned long checkTime3 = 0;
unsigned long checkTime4 = 0;

void setup() {
  // initialize pins
  for (int i=0; i<8; i++) {
    pinMode(out[i], OUTPUT);
    pinMode(in[i], INPUT_PULLUP);
  }
  
  pinMode(switchPin, INPUT);

  // initialize square status array with all values = 1
  for (int j=0; j<64; j++) {
    sqStatus[j] = 1;
    sqStatus1[j] = 1;
  }  

  // make board squares array
  for (int k=0; k<8; k++) {
    for (int l=0; l<8; l++) {
      squares[k*8+l] = files[k] + String(ranks[l]);
    }
  }  
  
  // begin serial communication
  Serial.begin(9600);
  establishContact();
}

void loop() {
  if (Serial.available() > 0) {
    // PUT ENTIRE LOOP() IN IF AVAILABLE STATEMENT
    
    // READ RECEIVED VALUE
    char receivedValue = Serial.read();
    
    // READ THE BOARD
    // maybe change N in count % N
    
    time = millis();
    
    if (time >= checkTime1) {
      boardCheck();
      checkTime1 = time + 1000;
    }

    // WAIT - REMOVE THIS BECAUSE OF POTS AND BUTTON
    // delay(500);

    // READ THE BOARD
    boardCheck1();

    // CHECK FOR CHANGES
    if (moveinprogress) {
      for (int i=0; i<64; i++) {
        if (sqStatus[i] == 1 && sqStatus1[i] == 0) {
          destSq = squares[i];
          //moveinprogress = false;
          Serial.print(originSq + destSq);
          Serial.print(",");
        }
      }
      moveinprogress = false;
    }
    else {
      for (int i=0; i<64; i++) {
        if (sqStatus[i] == 0 && sqStatus1[i] == 1) {
          originSq = squares[i];
          //moveinprogress = true;
        }
      }
      moveinprogress = true;
    }

    // POT AND BUTTON STUFF GOES HERE
    int sensorValue = analogRead(A0);
    Serial.print(sensorValue);
    Serial.print(",");
    //delay(1);
    sensorValue = analogRead(A1);
    Serial.print(sensorValue);
    Serial.print(",");
    //delay(1);
    sensorValue = digitalRead(switchPin);
    Serial.println(sensorValue);
    //delay(1);

    // Count increments by one
    //count++;
  }
}

void boardCheck() {
  // for each column...
  for (int i=0; i<8; i++) {
    // write a high signal
    digitalWrite(out[i], HIGH);
    // for each row...
    for (int j=0; j<8; j++) {
      // read signal and set square status array value = signal
      sqStatus[i*8+j] = digitalRead(in[j]);
    }
    // maintain a low signal
    digitalWrite(out[i], LOW);
  }
}

void boardCheck1() {
  // for each column...
  for (int i=0; i<8; i++) {
    // write a high signal
    digitalWrite(out[i], HIGH);
    // for each row...
    for (int j=0; j<8; j++) {
      // read signal and set square status array value = signal
      sqStatus1[i*8+j] = digitalRead(in[j]);
    }
    // maintain a low signal
    digitalWrite(out[i], LOW);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("hello");
    delay(300);
  }
}


