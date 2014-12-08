import ddf.minim.*;
import processing.serial.*;
import java.util.Arrays;

PrintWriter gameOutput;

Serial myPort;
boolean firstContact = false;
String myString;
float whiteVol = 0.0;
float blackVol = 0.0;
int reset = 0;

String curMove = "";

Minim minim1;
Minim minim2;
Minim minim3;
Minim minim4;
Minim minim5;
Minim minim6;
AudioPlayer player1;
AudioPlayer player2;
AudioPlayer player3;
AudioPlayer player4;
AudioPlayer player5;
AudioPlayer player6;

int score = 0;
boolean[] status = new boolean[11];
String[] tracks = {"n.mp3", "w1.wav", "w2.wav", "w3.wav", "b1.wav", "b2.wav", "b3.wav", "m1.wav", "m2.wav", "m3.wav", "m4.wav", "m5.wav", "parity.wav"};

char[] files = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
char[] ranks = {'1', '2', '3', '4', '5', '6', '7', '8'};


void allStatusTrue() {
  for (int i=0; i<11; i++) {
    status[i] = true;
  }
}

void playTracks(int s, int t1, int t2, int t3, int t4, int t5, int t6) {
  allStatusTrue();
  status[s] = false;
  
  player1.close();
  player2.close();
  player3.close();
  player4.close();
  player5.close();
  player6.close();
  player1 = minim1.loadFile(tracks[t1]);
  player2 = minim2.loadFile(tracks[t2]);
  player3 = minim3.loadFile(tracks[t3]);
  player4 = minim4.loadFile(tracks[t4]);
  player5 = minim5.loadFile(tracks[t5]);
  player6 = minim6.loadFile(tracks[t6]);
  player1.loop();
  player2.play();
  player3.loop();
  player4.loop();
  player5.loop();
  player6.loop();
  
  // print(s);
  // print(":");
  // print(" "+tracks[t1]+",");
  // print(tracks[t2]+",");
  // print(tracks[t3]+",");
  // println(tracks[t4]);
}

void serialEvent(Serial myPort) {
  myString = myPort.readStringUntil('\n');
  if (myString != null) {
    myString = trim(myString);
    //String sensors[] = split(myString, ',');
    //if (sensors.length == 3) {
      
      // whiteVol = map(int(sensors[0]), 1023, 0, -40.0, 6.0);
      // //print(whiteVol+",");
      // blackVol = map(int(sensors[1]), 1023, 0, -40.0, 6.0);
      // //print(blackVol+",");
      // reset = int(sensors[2]);
      // //println(reset);
      
    //} else if (sensors.length == 2 && !sensors[0].startsWith("1") && !sensors[0].startsWith("0")) {

    curMove = myString;
    gameOutput.println(curMove);
    gameOutput.flush();
    println(curMove);

    //}
    
  }
  
  // if (myString != null) {
  //   myString = trim(myString);
  //   if (firstContact == false) {
  //     if (myString.equals("hello")) {
  //       myPort.clear();
  //       firstContact = true;
  //       myPort.write('A');
  //     }
  //   }
  //   else {
  //     String sensors[] = split(myString, ',');
  //     // for (int i=0; i<sensors.length; i++) {
  //     //   print("Sensor " + i + ": " + sensors[i] + "\t");
  //     // }
  //     // println();
  //     if (sensors.length == 3) {
        
  //       boolean containsHello = false;
        
  //       for (int i=0; i<3; i++) {
  //         if (sensors[i].startsWith("hello")) {
  //           containsHello = true;
  //         }
  //       }
        
  //       if (!containsHello) {
  //         whiteVol = map(int(sensors[0]), 1023, 0, -40.0, 6.0);
  //         //print(whiteVol+",");
  //         blackVol = map(int(sensors[1]), 1023, 0, -40.0, 6.0);
  //         //print(blackVol+",");
  //         reset = int(sensors[2]);
  //         //println(reset);
  //       }
  //     }
  //     else if (sensors.length == 2) {
  //       if (!sensors[0].startsWith("hello")) {
  //         curMove = sensors[0];
  //         gameOutput.println(curMove);
  //         gameOutput.flush();
  //         println(curMove);
  //       }
  //       // whiteVol = map(int(sensors[1]), 1023, 0, -40.0, 6.0);
  //       // blackVol = map(int(sensors[2]), 1023, 0, -40.0, 6.0);
  //       // reset = int(sensors[3]);
  //     }
  //   }
  // }
}

void setup() {  
  // String[] ghostdotpy = {"python", "/Users/rg/Projects/mtg/mtg/mtg/ghost.py"};
  // exec(ghostdotpy);
  
  size(displayWidth, displayHeight);
  
  gameOutput = createWriter("game.txt");
  
  String portName = "/dev/cu.wchusbserial1410";
  myPort = new Serial(this, portName, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');
  
  minim1 = new Minim(this);
  minim2 = new Minim(this);
  minim3 = new Minim(this);
  minim4 = new Minim(this);
  minim5 = new Minim(this);
  minim6 = new Minim(this);
  
  allStatusTrue();
  
  player1 = minim1.loadFile("n.mp3");
  player2 = minim2.loadFile("n.mp3");
  player3 = minim3.loadFile("n.mp3");
  player4 = minim4.loadFile("n.mp3");
  player5 = minim5.loadFile("n.mp3");
  player6 = minim6.loadFile("n.mp3");
  player1.loop();
  player2.loop();
  player3.loop();
  player4.loop();
  player5.loop();
  player6.loop();
}

void draw() {
  String scoreString[] = loadStrings("score.txt");
  if (scoreString.length >= 1) {
    score = int(scoreString[0]);
  }
  
  String mateString[] = loadStrings("checkmate.txt");
  if (int(mateString[0]) == 1) {
    myPort.write('x');
  }
  //println(score);
  
  // status 0: score <= -450
  if (score <= -450 && status[0]) {
    playTracks(0, 5, 11, 0, 0, 0, 0);
  }
  // status 1: -350 >= score > -450
  else if (score <= -350 && score > -450 && status[1]) {
    playTracks(1, 4, 10, 0, 0, 0, 0);
  }
  // status 2: -250 >= score > -350
  else if (score <= -250 && score > -350 && status[2]) {
    playTracks(2, 6, 9, 0, 0, 0, 0);
  }
  // status 3: -150 >= score > -250
  else if (score <= -150 && score > -250 && status[3]) {
    playTracks(3, 5, 8, 0, 0, 0, 0);
  }
  // status 4: -50 >= score > -150
  else if (score <= -50 && score > -150 && status[4]) {
    playTracks(4, 4, 7, 0, 0, 0, 0);
  }
  // status 5: -50 < score < 50
  else if (abs(score) < 50 && status[5]) {
    playTracks(5, 12, 0, 0, 0, 0, 0); //<>//
  }
  // status 6: 50 <= score < 150
  else if (score >= 50 && score < 150 && status[6]) {
    playTracks(6, 1, 7, 0, 0, 0, 0);
  }
  // status 7: 150 <= score < 250
  else if (score >= 150 && score < 250 && status[7]) {
    playTracks(7, 2, 8, 0, 0, 0, 0);
  }
  // status 8: 250 <= score < 350
  else if (score >= 250 && score < 350 && status[8]) {
    playTracks(8, 3, 9, 0, 0, 0, 0);
  }
  // status 9: 350 <= score < 450
  else if (score >= 350 && score < 450 && status[9]) {
    playTracks(9, 2, 10, 0, 0, 0, 0);
  }
  // status 10: score >= 450
  else if (score >= 450 && status[10]) {
    playTracks(10, 3, 11, 3, 0, 0, 0);
  }
  
  // set gain based on potentiometer input
  player1.setGain(whiteVol);
  player2.setGain(whiteVol);
  player3.setGain(whiteVol);
  player4.setGain(blackVol);
  player5.setGain(blackVol);
  player6.setGain(blackVol);
  
  if (reset == 1) {
    allStatusTrue();
  }
  
  // DISPLAY BOARD, CUR MOVE, BEST MOVE
  background(245);
  
  noStroke();
  fill(188, 154, 105);
  triangle(10, 10, 690, 10, 350, 350);
  fill(127, 104, 71);
  triangle(10, 690, 350, 350, 690, 690);
  fill(156, 129, 86);
  triangle(10, 10, 350, 350, 10, 690);
  triangle(690, 10, 350, 350, 690, 690);
  
  noStroke();
  for (int i=0; i<8; i++) {
    for (int j=0; j<8; j++) {
      if ((i % 2 == 1 && j % 2 == 0) || (i % 2 == 0 && j % 2 == 1)) {
        fill(84, 167, 87);
      } else {
        fill(243, 240, 213);
      }
      rectMode(CORNER);
      rect(30 + i * 80, 30 + j * 80, 80, 80);
    }
  }
  
  fill(233, 233, 234);
  for (int i=0; i<8; i++) {
    textAlign(CENTER, TOP);
    text(Character.toUpperCase(files[i]), 70 + 80 * i, 670);
    textAlign(RIGHT, CENTER);
    text(ranks[7 - i], 25, 70 + 80 * i);
  }
  
  // display curMove
  if (!curMove.equals("") && !curMove.startsWith("1") && !curMove.startsWith("0")) {
    char originFile = curMove.charAt(0); 
    char originRank = curMove.charAt(1);
    char destFile = curMove.charAt(2);
    char destRank = curMove.charAt(3);
    int originFileIndex = Arrays.binarySearch(files, originFile);
    int originRankIndex = Arrays.binarySearch(ranks, originRank);
    int destFileIndex = Arrays.binarySearch(files, destFile);
    int destRankIndex = Arrays.binarySearch(ranks, destRank);
    noStroke();
    fill(255,0,0);
    rectMode(CORNER);
    rect(30+originFileIndex*80, 670-(originRankIndex+1)*80, 80, 80);
    rect(30+destFileIndex*80, 670-(destRankIndex+1)*80, 80, 80);
  }
  
  // display bestMove
  String bestMove[] = loadStrings("bestmove.txt");
  if (bestMove.length >= 1 && !bestMove[0].equals("")) {
    char originFile = bestMove[0].charAt(0); 
    char originRank = bestMove[0].charAt(1);
    char destFile = bestMove[0].charAt(2);
    char destRank = bestMove[0].charAt(3);
    int originFileIndex = Arrays.binarySearch(files, originFile);
    int originRankIndex = Arrays.binarySearch(ranks, originRank);
    int destFileIndex = Arrays.binarySearch(files, destFile);
    int destRankIndex = Arrays.binarySearch(ranks, destRank);
    noStroke();
    fill(212,146,255);
    rectMode(CORNER);
    rect(30+originFileIndex*80, 670-(originRankIndex+1)*80, 80, 80);
    rect(30+destFileIndex*80, 670-(destRankIndex+1)*80, 80, 80);
  }
  
}

void keyPressed() {
  gameOutput.flush();
  gameOutput.close();
  exit();
}
