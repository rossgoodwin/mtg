int out[8] = {22, 24, 26, 28, 30, 32, 34, 36};
int in[8] = {23, 25, 27, 29, 31, 33, 35, 37};
int solenoidPins[4] = {50, 51, 52, 53};
int ledPins[2] = {2, 3};

char files[9] = "abcdefgh";
char ranks[9] = "12345678";

String squares[64];

int sqStatus1[64];
int sqStatus2[64];

boolean moveInProgress = false;
boolean moveEnded = false;
boolean part1 = false;

boolean whitesMove = true;

String originSq1;
String originSq2;
String trueOriginSq;
String destSq;
String moveStr = "x0x0";
String prevMoveStr = "x0x0";

void setup() {
  for (int i=0; i<8; i++) {
    pinMode(out[i], OUTPUT);
    pinMode(in[i], INPUT_PULLUP);
  }
  
  for (int i=0; i<4; i++) {
    pinMode(solenoidPins[i], OUTPUT);
  }
  
  for (int i=0; i<2; i++) {
    pinMode(ledPins[i], OUTPUT);
  }
  
  for (int j=0; j<64; j++) {
    sqStatus1[j] = 1;
    sqStatus2[j] = 1;
  }  
  
  for (int k=0; k<8; k++) {
    for (int l=0; l<8; l++) {
      squares[k*8+l] = String(files[k]) + String(ranks[l]);
    }
  }  
  
  Serial.begin(9600);
//  establishContact();
}

void loop() {  
  char receivedValue = Serial.read();
  
  boardCheck1();
  delay(1);
  boardCheck2();
  int diffSq = arrayCompare();
  
  while (diffSq == 64) {
    if (Serial.available() > 0) {
       char received = Serial.read();
       if (received == 'x') {
         fireSolenoids();
       }
    }
    delay(1);
    boardCheck2();
    diffSq = arrayCompare();
  }

  record(diffSq);   
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

void boardCheck2() {
  // for each column...
  for (int i=0; i<8; i++) {
    // write a high signal
    digitalWrite(out[i], HIGH);
    // for each row...
    for (int j=0; j<8; j++) {
      // read signal and set square status array value = signal
      sqStatus2[i*8+j] = digitalRead(in[j]);
    }
    // maintain a low signal
    digitalWrite(out[i], LOW);
  }
}

int arrayCompare() {
  
  boolean difference = false;
  int sqDiff = 64;
  
  for (int i=0; i<64; i++) {
    if (sqStatus1[i] != sqStatus2[i]) {
      difference = true;
      sqDiff = i;
      //Serial.println("diff,detetected,foo,bar");
    }
  }
  
  if (difference) {
    if (sqStatus2[sqDiff] == 1) {
      moveInProgress = true;
    } else {
      moveInProgress = false;
      moveEnded = true;
    }
  }
    
  return sqDiff;
  
}

void record(int ds) {
  
  if (moveInProgress && !part1) {
    
    part1 = true;
    originSq1 = squares[ds];
    
  } else if (moveInProgress && part1) {
    
    part1 = false;
    originSq2 = squares[ds];
    
  } else if (!moveInProgress && moveEnded) {
    
    destSq = squares[ds];
    part1 = false;
    moveEnded = false;
    
    if (originSq1 == destSq) {
      trueOriginSq = originSq2;
    } else if (originSq2 == destSq) {
      trueOriginSq = originSq1;
    } else {
      trueOriginSq = originSq1;
    }
    
    prevMoveStr = moveStr;
    moveStr = trueOriginSq + destSq;
    
    if (moveStr.length() == 4 && moveStr != prevMoveStr && trueOriginSq != destSq) {
      Serial.println(moveStr);
      if (whitesMove) {
        ledBlack();
        whitesMove = false;
      } else {
        ledWhite();
        whitesMove = true;
      }
    }
    
  }
  
}

void fireSolenoids() {
  for (int x=0; x<200; x++) {
    for (int i=0; i<4; i++) {
      ledBlack();
      digitalWrite(solenoidPins[i], HIGH);
      delay(10);
      ledWhite();
      digitalWrite(solenoidPins[i], LOW);
      delay(10);
    }
  }
}

void ledBlack() {
  digitalWrite(ledPins[0], HIGH);
  digitalWrite(ledPins[1], LOW);
}

void ledWhite() {
  digitalWrite(ledPins[1], HIGH);
  digitalWrite(ledPins[0], LOW);
}



//void establishContact() {
//  while (Serial.available() <= 0) {
//    Serial.println("hello");
//    delay(300);
//  }
//}
