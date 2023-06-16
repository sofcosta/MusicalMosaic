/*
 
 Interactive Evolutionary System - Evolving visual and sound compositions along side each other
 
 Masters in Design and Multimedia
 University of Coimbra
 2022/2023
 @author: Sofia Torres Costa
 
 */
import processing.sound.*;

import processing.video.*;
import java.awt.*;

import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

DeepVision vision = new DeepVision(this);
ULFGFaceDetectionNetwork network;
ResultList<ObjectDetectionResult> detections;

Capture video;

int population_size = 10;
int elite_size = 1;
int tournament_size = 3;
float crossover_rate = 0.7;
float mutation_rate = 0.3;
int resolution = 500;

Population pop;
PVector[][] grid;
Individual hovered_indiv = null;

int nOfParam = 7;
int nOfShapes = 4;
int nOfColors = 3;
//float[] aux;
Boolean auxBool;

SinOsc sinOsc;
TriOsc triOsc;
Pulse sawOsc;
Env env;

float[] baseFreq = {65.41, 69.30, 73.42, 77.78, 82.41, 87.31, 92.50, 98.00, 103.83, 110.00, 116.54, 123.47};
int[] octMult = {1, 2, 4, 8};

float[] frequencies = {261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88};

int[] nota = new int[nOfShapes];
float[] amp = new float[nOfShapes];
int[] onda = new int[nOfShapes];
float[] dur = new float[nOfShapes];
float[] pan = new float[nOfShapes];
int[] oct = new int[nOfShapes];


int[] counter = new int[population_size];
int[] noteNumber = new int[population_size];

boolean pause = false;
float timer = 0;

void settings() {
  size(int(displayWidth * 0.9), int(displayHeight * 0.8));
  //size(1080, 720);
  pixelDensity(displayDensity());
  smooth(8);
}

void setup() {
  pop = new Population();
  grid = calculateGrid(population_size, 0, 0, width, height, 30, 10, 30, true);

  //for (int i = 0; i < nOfShapes*population_size; i++) {
  //  aux[i] = random(1);
  //}

  sinOsc = new SinOsc(this);
  triOsc = new TriOsc(this);
  sawOsc = new Pulse(this);
  env = new Env(this);

  video = new Capture(this, width, height);
  video.start();

  //println("creating network...");
  network = vision.createULFGFaceDetectorRFB320();

  //println("loading model...");
  network.setup();

  //println("inferencing...");
  detections = network.run(video);
  println("Done!");

  //for (ObjectDetectionResult detection : detections) {
  //  System.out.println(detection.getClassName() + "\t[" + detection.getConfidence() + "]");
  //}

  textSize(constrain(grid[0][0].z * 0.1, 11, 14));
  textAlign(CENTER, TOP);

  for (int i=0; i<population_size; i++) {
    counter[i] = 0;
    noteNumber[i] = 0;
  }

  frameRate(20);
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  int auxTime = int(frameRate*3);
  //background(240);
  background(0);
  detections = network.run(video);
  hovered_indiv = null; // Temporarily clear selected individual

  int row = 0, col = 0;
  for (int i = 0; i < pop.getSize(); i++) {
    float x = grid[row][col].x;
    float y = grid[row][col].y;
    float d = grid[row][col].z;

    for (ObjectDetectionResult detection : detections) {
      float faceX = width-detection.getCenterX();
      float faceY = detection.getCenterY();

      // Check if current individual is hovered by the cursor
      noFill();
      //if (mouseX > x && mouseX < x + d && mouseY > y && mouseY < y + d) {
      if (faceX > x && faceX < x + d && faceY > y && faceY < y + d) {
        hovered_indiv = pop.getIndiv(i);
        counter[i]++;
        stroke(0);
        strokeWeight(3);
        rect(x, y, d, d);
        if (counter[i] > auxTime-1) {
          float currentFit = hovered_indiv.getFitness();
          hovered_indiv.setFitness(constrain(currentFit+=0.005, 0, 1));
          hovered_indiv.getNoteValues();
          if (counter[i] >= auxTime && counter[i] < auxTime+1) {
            //println("--------------");
            //for (int j=0; j<4; j++)
            //  println("nota: " + nota[j] + "; amp: " + amp[j] + "; onda: "+onda[j]+"; dur: " + dur[j] + "; pan: " + pan[j] + "; oct: " + oct[j]);
            //println("1: "+counter[i]);
            playNote(nota[0], amp[0], onda[0], dur[0], oct[0], pan[0], 0);
          } else if (counter[i] >= auxTime+(dur[0]*frameRate)*1.5 && counter[i] < auxTime+(dur[0]*frameRate)*1.5+1) {
            //println("2: "+counter[i]);
            playNote(nota[1], amp[1], onda[1], dur[1], oct[1], pan[1], 0);
          } else if (counter[i] >= auxTime+(dur[0]*frameRate+dur[1]*frameRate)*1.5 && counter[i] < auxTime+(dur[0]*frameRate+dur[1]*frameRate)*1.5+1) {
            //println("3: "+(auxTime+(dur[0]*frameRate+dur[1]*frameRate)*1.5));
            playNote(nota[2], amp[2], onda[2], dur[2], oct[2], pan[2], 0);
          } else if (counter[i] >= auxTime+(dur[0]*frameRate+dur[1]*frameRate+dur[2]*frameRate)*1.5 && counter[i] < auxTime+(dur[0]*frameRate+dur[1]*frameRate+dur[2]*frameRate)*1.5+1) {
            //println("4: "+ (auxTime+(dur[0]*frameRate+dur[1]*frameRate+dur[2]*frameRate)*1.5));
            playNote(nota[3], amp[3], onda[3], dur[3], oct[3], pan[3], 0);
          }
        }
        //if (counter[i] == 61) {
        //  // play sound
        //  //if (hovered_indiv != null) {
        //  //  hovered_indiv.getNoteValues();
        //  //  for (int j=0; j<nOfShapes; j++) {
        //  //    if (j == 0) playNote(nota[j], amp[j], onda[j], dur[j], oct[j], pan[j], 0);
        //  //    else playNote(nota[j], amp[j], onda[j], dur[j], oct[j], pan[j], int(dur[j-1]*1000));
        //  //    if (j == 3) delay(int(dur[j]*1000));
        //  //  }
        //  //}
        //}
        // } else if (pop.getIndiv(i).getFitness() > 0) {
      } else {
        counter[i] = 0;
        noteNumber[i] = 0;
        //stroke(100, 255, 100);
        //strokeWeight(map(pop.getIndiv(i).getFitness(), 0, 1, 3, 6));
        //rect(x, y, d, d);
      }
    }
    // Draw phenotype of current individual
    image(pop.getIndiv(i).getPhenotype(resolution), x, y, d, d);

    float ang = map(counter[i], 0, frameRate*3, 0, TWO_PI);
    noStroke();
    fill(0);
    arc(x+20, y+20, 15, 15, -PI/2, ang-PI/2, PIE);

    // Draw fitness of current individual
    fill(255);
    noStroke();
    //text(nf(pop.getIndiv(i).getFitness(), 0, 2), x + d / 2, y + d + 2);
    rect(x, y+d+1, pop.getIndiv(i).getFitness()*d, 5);

    // Go to next grid cell
    col += 1;
    if (col >= grid[row].length) {
      row += 1;
      col = 0;
    }
  }

  if (pause == false) {
    timer+=3;
    if (timer>width) {
      pop.evolve();
      timer = 0;
      for (int i=0; i<population_size; i++) {
        counter[i] = 0;
        noteNumber[i] = 0;
      }
    }
  }
  fill(255);
  //rect(0, height-10, timer, 10);
  
  float ang = map(timer, 0, width, 0, TWO_PI);
   
  arc(50, height-50, 50, 50, -PI/2, ang-PI/2, PIE);
    
  textAlign(LEFT);
  text("Press space to pause evolution", 100, height-50);
  text("Press 's' to skip", 100, height-30);

  for (ObjectDetectionResult detection : detections) {
    float x = width-detection.getCenterX();
    float y = detection.getCenterY();
    
    noFill();
    stroke(255, 0, 0);
    ellipse(x, y, 10, 10);
  }

  surface.setTitle("FPS: " + Math.round(frameRate));
}

void keyReleased() {
  if (key == CODED) {
    if (hovered_indiv != null) {
      // Change fitness of the selected (hovered) individual
      float fit = hovered_indiv.getFitness();
      if (keyCode == UP) {
        fit = min(fit + 0.1, 1);
      } else if (keyCode == DOWN) {
        fit = max(fit - 0.1, 0);
      } else if (keyCode == RIGHT) {
        fit = 1;
      } else if (keyCode == LEFT) {
        fit = 0;
      }
      hovered_indiv.setFitness(fit);
    }
    //} else if (key == 'f') {
    //  // Set fitness of clicked individual to 1
    //  if (hovered_indiv != null) {
    //    if (hovered_indiv.getFitness() < 1) {
    //      hovered_indiv.setFitness(1);
    //    } else {
    //      hovered_indiv.setFitness(0);
    //    }
    //  }
  } else if (key == 's') {
    // Evolve (generate new population)
    pop.evolve();
    timer = 0;
    for (int i=0; i<population_size; i++) {
      counter[i] = 0;
      noteNumber[i] = 0;
    }
  } else if (key == ' ') {
    pause=!pause;
  } else if (key == 'i') {
    // Initialise new population
    pop.initialize();
  } else if (key == 'e') {
    // Export selected individual
    if (hovered_indiv != null) {
      hovered_indiv.export();
    }
  }
}

void mouseReleased() {
  //// Set fitness of clicked individual to 1
  //if (hovered_indiv != null) {
  //  if (hovered_indiv.getFitness() < 1) {
  //    hovered_indiv.setFitness(1);
  //  } else {
  //    hovered_indiv.setFitness(0);
  //  }
  //}
  if (hovered_indiv != null) {
    hovered_indiv.getNoteValues();
    for (int i=0; i<nOfShapes; i++) {
      if (i == 0) playNote(nota[i], amp[i], onda[i], dur[i], oct[i], pan[i], 0);
      else playNote(nota[i], amp[i], onda[i], dur[i], oct[i], pan[i], int(dur[i-1]*1000));
      if (i == 3) delay(int(dur[i]*1000));
    }
  }
}

void playNote(int n, float a, int o, float d, int oct, float p, int delay) {
  if (o == 0) {
    //delay(delay);
    sinOsc.freq(baseFreq[n]*octMult[oct]);
    sinOsc.pan(p);
    //sinOsc.freq(frequencies[n]);
    env.play(sinOsc, 0.001, 0.004, a, d);
  } else if (o == 1) {
    //delay(delay);
    triOsc.freq(baseFreq[n]*octMult[oct]);
    triOsc.pan(p);
    //triOsc.freq(frequencies[n]);
    env.play(triOsc, 0.001, 0.004, a, d);
  } else if (o == 2) {
    //delay(delay);
    sawOsc.freq(baseFreq[n]*octMult[oct]);
    sawOsc.pan(p);
    //sawOsc.freq(frequencies[n]);
    env.play(sawOsc, 0.001, 0.004, a, d);
  }
}

// Calculate grid of square cells
PVector[][] calculateGrid(int cells, float x, float y, float w, float h, float margin_min, float gutter_h, float gutter_v, boolean align_top) {
  int cols = 0, rows = 0;
  float cell_size = 0;
  while (cols * rows < cells) {
    cols += 1;
    cell_size = ((w - margin_min * 2) - (cols - 1) * gutter_h) / cols;
    rows = floor((h - margin_min * 2) / (cell_size + gutter_v));
  }
  if (cols * (rows - 1) >= cells) {
    rows -= 1;
  }
  float margin_hor_adjusted = ((w - cols * cell_size) - (cols - 1) * gutter_h) / 2;
  if (rows == 1 && cols > cells) {
    margin_hor_adjusted = ((w - cells * cell_size) - (cells - 1) * gutter_h) / 2;
  }
  float margin_ver_adjusted = ((h - rows * cell_size) - (rows - 1) * gutter_v) / 2;
  if (align_top) {
    margin_ver_adjusted = min(margin_hor_adjusted, margin_ver_adjusted);
  }
  PVector[][] positions = new PVector[rows][cols];
  for (int row = 0; row < rows; row++) {
    float row_y = y + margin_ver_adjusted + row * (cell_size + gutter_v);
    for (int col = 0; col < cols; col++) {
      float col_x = x + margin_hor_adjusted + col * (cell_size + gutter_h);
      positions[row][col] = new PVector(col_x, row_y, cell_size);
    }
  }
  return positions;
}
