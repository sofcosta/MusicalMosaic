// This class represents a single note or shape
class Shape {
  float x, y;
  int size;             // Tamanho -> (amplitude)
  int c;                // Cor -> escolhe entre 3 cores (forma da onda)
  int shapeForm;        // Forma -> número da função (nota)
  int shapeRepetition;  // Número de repetições da mesma forma (duração)
  float auxOri;         // Variável auxiliar para saber orientação da repetição

  Shape(float x, float y, int shapeForm, int size, int c, int shapeRepetition, float auxOri) { //
    this.x = x;
    this.y = y;
    this.shapeForm = shapeForm;
    this.size = size;
    this.c = c;
    this.shapeRepetition = shapeRepetition;
    this.auxOri = auxOri;
  }

  void drawShape(PGraphics canvas) {
    canvas.stroke(c, 100, 100);
    canvas.noFill();
    canvas.strokeJoin(ROUND);
    canvas.strokeCap(ROUND);
    int [] inc = new int[2];
    //float aux = random(1);
    
    // get repetition orientation
    if (auxOri < 0.125) {
      inc[0] = 1;
      inc[1] = -1;
    } else if (auxOri > 0.125 && auxOri < 0.25) {
      inc[0] = 1;
      inc[1] = 0;
    } else if (auxOri > 0.25 && auxOri < 0.375) {
      inc[0] = 1;
      inc[1] = 1;
    } else if (auxOri > 0.375 && auxOri < 0.5) {
      inc[0] = -1;
      inc[1] = -1;
    } else if (auxOri > 0.5 && auxOri < 0.625) {
      inc[0] = -1;
      inc[1] = 0;
    } else if (auxOri > 0.625 && auxOri < 0.75) {
      inc[0] = -1;
      inc[1] = 1;
    } else if (auxOri > 0.75 && auxOri < 0.875) {
      inc[0] = 0;
      inc[1] = -1;
    } else if (auxOri > 0.875) {
      inc[0] = 0;
      inc[1] = 1;
    }

    for (int i=0; i<shapeRepetition; i++) {
      forma(canvas, x+(i*size*0.25*inc[0]), y+(i*size*0.25*(-1)*inc[1]), size, shapeForm);
    }
  }
}
