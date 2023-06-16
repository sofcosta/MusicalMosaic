import processing.pdf.*; // Needed to export PDFs

// This class represents and encodes an individual
// -> Visual Representation of sequence of musical notes
class Individual {
  int nGenes = nOfParam * nOfShapes + nOfColors;

  float[] genes = new float[nGenes];
  float fitness = 0;

  // Create a random individual
  Individual() {
    randomize();
  }

  // Create an individual with the given genes
  Individual(float[] genes_init) {
    for (int i=0; i<genes_init.length; i++) {
      genes[i] = genes_init[i];
    }
  }

  // Set all genes to random values
  void randomize() {
    for (int i = 0; i < genes.length; i++) {
      genes[i] = random(0, 1);
    }
  }

  // One-point crossover operator
  Individual onePointCrossover(Individual partner) {
    Individual child = new Individual();
    int crossover_point = int(random(1, genes.length - 1));
    for (int i = 0; i < genes.length; i++) {
      if (i < crossover_point) {
        child.genes[i] = genes[i];
      } else {
        child.genes[i] = partner.genes[i];
      }
    }
    return child;
  }

  // Mutation operator
  void mutate() {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) <= mutation_rate) {
        genes[i] = random(1); // Replace gene with a random one
        //genes[i] = constrain(genes[i] + random(-0.1, 0.1), 0, 1); // Adjust the value of the gene
      }
    }
  }

  // Set the fitness value
  void setFitness(float fitness) {
    this.fitness = fitness;
  }

  // Get the fitness value
  float getFitness() {
    return fitness;
  }

  // Get a clean copy
  Individual getCopy() {
    Individual copy = new Individual(genes);
    copy.fitness = fitness;
    return copy;
  }

  // Get the image of the individual
  PImage getPhenotype(int resolution) {
    PGraphics canvas = createGraphics(resolution, resolution);
    canvas.beginDraw();
    canvas.colorMode(HSB, 360, 100, 100);
    canvas.background(360);
    canvas.noFill();
    canvas.strokeWeight(canvas.height * 0.005);
    calculateShapes(canvas, canvas.width / 2, canvas.height / 2, canvas.width);
    canvas.endDraw();
    return canvas;
  }

  void calculateShapes(PGraphics canvas, float x, float y, float w) {
    Shape[] shapes = new Shape[(genes.length-nOfColors)/nOfParam+nOfColors];
    int[] colors = {round(genes[0]*360), round(genes[1]*360), round(genes[2]*360)};
    canvas.pushMatrix();
    canvas.translate(x, y);
    canvas.beginDraw();
        
    for (int i = nOfColors; i < nOfShapes + nOfColors; i++) {  // runs through all shapes
      int aux = nOfParam*(i-3)+3;
      int forma = round(genes[aux]*11);
      int size = round(genes[aux+1]*w/8 + w/30);
      int cor = colors[round(genes[aux+2]*2)];
      int rep = round(genes[aux+3]*3) + 1;
      float posx = genes[aux+4]*(w-(size*0.5+(size*0.25)*rep)*2)+(size*0.5+(size*0.25)*rep);
      float posy = genes[aux+5]*(w-(size*0.5+(size*0.25)*rep)*2)+(size*0.5+(size*0.25)*rep);
      float auxOri = genes[aux+6];
      //println("x: "+posx+"; y: "+posy+"; forma: " + forma + "; size: " + size + "; tim: " + cor + "; dur: " + rep);
      auxBool = true;
      shapes[i] = new Shape(posx, posy, forma, size, cor, rep, auxOri);
      shapes[i].drawShape(canvas);
    }
    canvas.endDraw();
    canvas.popMatrix();
  }

  void getNoteValues() {
    for (int i = nOfColors; i < nOfShapes + nOfColors; i++) {  // runs through all shapes
      int aux = nOfParam*(i-3)+3;
      nota[i-nOfColors] = round(genes[aux]*11);
      amp[i-nOfColors] = genes[aux+1];
      onda[i-nOfColors] = round(genes[aux+2]*2);
      dur[i-nOfColors] = genes[aux+3];
      pan[i-nOfColors] = genes[aux+4]*2-1;
      oct[i-nOfColors] = octMult.length-1-int(genes[aux+5]*octMult.length);
      //println("nota: " + nota[i-nOfColors] + "; amp: " + amp[i-nOfColors] + "; onda: "+onda[i-nOfColors]+"; dur: " + dur[i-nOfColors] + "; pan: " + pan[i-nOfColors] + "; oct: " + oct[i-nOfColors]);
    }
  }

  // Export image (png), vector (pdf) and genes (txt) of this individual
  void export() {
    String output_filename = year() + "-" + nf(month(), 2) + "-" + nf(day(), 2) + "-" +
      nf(hour(), 2) + "-" + nf(minute(), 2) + "-" + nf(second(), 2);
    String output_path = sketchPath("outputs/" + output_filename);

    println("Exporting harmonograph to: " + output_path);

    getPhenotype(2000).save(output_path + ".png");

    PGraphics pdf = createGraphics(500, 500, PDF, output_path + ".pdf");
    pdf.beginDraw();
    pdf.colorMode(HSB, 360, 100, 100);
    pdf.background(360);
    pdf.noFill();
    //pdf.strokeWeight(pdf.height * 0.001);
    pdf.strokeWeight(pdf.height * 0.0025);
    calculateShapes(pdf, pdf.width*0.5, pdf.height / 2, pdf.width*0.5);
    pdf.dispose();
    pdf.endDraw();

    String[] output_text_lines = new String[genes.length];
    for (int i = 0; i < genes.length; i++) {
      output_text_lines[i] = str(genes[i]);
    }
    saveStrings(output_path + ".txt", output_text_lines);
  }
}
