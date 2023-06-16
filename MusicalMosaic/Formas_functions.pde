void forma(PGraphics canvas, float x, float y, int side, int shapeForm) {
  switch(shapeForm) {
  case 0:  //QUADRADO
    canvas.rectMode(CENTER);
    canvas.rect(x, y, side, side);
    break;
  case 1:  //L
    canvas.line(x-side*0.5, y-side*0.5, x-side*0.5, y+side*0.5);
    canvas.line(x-side*0.5, y+side*0.5, x+side*0.5, y+side*0.5);
    break;
  case 2:  //CÍRCULO
    canvas.ellipse(x, y, side, side);
    break;
  case 3:  //ARCO
    canvas.arc(x, y, side, side, PI*0.25, PI+PI*0.25, CHORD);
    break;
  case 4:  //LOSANGO
    canvas.beginShape();
    canvas.vertex(x, y-side*0.5);
    canvas.vertex(x-side*0.5, y);
    canvas.vertex(x, y+side*0.5);
    canvas.vertex(x+side*0.5, y);
    canvas.vertex(x, y-side*0.5);
    canvas.endShape();
    break;
  case 5:  //T INVERTIDO
    canvas.beginShape();
    canvas.vertex(x, y-side*0.5);
    canvas.vertex(x, y+side*0.5);
    canvas.vertex(x-side*0.5, y+side*0.5);
    canvas.vertex(x+side*0.5, y+side*0.5);
    canvas.endShape();
    break;
  case 6:  //+
    canvas.line(x, y-side*0.5, x, y+side*0.5);
    canvas.line(x-side*0.5, y, x+side*0.5, y);
    break;
  case 7:  //X
    canvas.line(x-side*0.5, y-side*0.5, x+side*0.5, y+side*0.5);
    canvas.line(x-side*0.5, y+side*0.5, x+side*0.5, y-side*0.5);
    break;
  case 8:  //TRIÂNGULO ISOSCELES
    canvas.triangle(x, y-side*0.5, x-side*0.5, y+side*0.5, x+side*0.5, y+side*0.5);
    break;
  case 9:  //MERCEDES
    canvas.line(x, y-side*0.5, x, y);
    canvas.line(x-side*0.5, y+side*0.5, x, y);
    canvas.line(x+side*0.5, y+side*0.5, x, y);
    break;
  case 10:  //TRIÂNGULO RETÂNGULO
    canvas.triangle(x+side*0.5, y-side*0.5, x-side*0.5, y+side*0.5, x+side*0.5, y+side*0.5);
    break;
  case 11:  //V
    canvas.line(x-side*0.5, y-side*0.5, x, y+side*0.5);
    canvas.line(x+side*0.5, y-side*0.5, x, y+side*0.5);
    break;
  }
}
