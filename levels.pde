void levels() {
  //variabelen declareren
  float horizontaleHelftScherm = width/2;
  float verticaleHelftScherm = height/2;
  float breedteButton = 600;
  float hoogteButton = 150;
  float x = horizontaleHelftScherm - breedteButton/2;
  float y = verticaleHelftScherm - hoogteButton / 2;
  
  imageMode(CORNER);
  image(backGround, 0, 0, width, height);

  stroke(100); 
  fill(100, 100, 100, 100);
  
  rect(x - 400, y-200, breedteButton, hoogteButton); //level 0
  rect(x + 400, y-200, breedteButton, hoogteButton); //level 1
  rect(x - 400, y+48, breedteButton, hoogteButton); //level 2
  rect(x + 400, y+48, breedteButton, hoogteButton); //level 3
  rect(x, y+296, breedteButton, hoogteButton); //level 4


  fill(255);
  textSize(100);
  textAlign(CENTER);
  text("Level 0", horizontaleHelftScherm - 400, verticaleHelftScherm -165);
  text("Level 1", horizontaleHelftScherm + 400, verticaleHelftScherm - 165); 
  text("Level 2", horizontaleHelftScherm - 400, verticaleHelftScherm + 83);
  text("Level 3", horizontaleHelftScherm + 400, verticaleHelftScherm + 83);
  text("Level 4", horizontaleHelftScherm, verticaleHelftScherm + 331);

  //terugknop
  stroke(255);
  fill(255, 255, 255, 255);
  rect(100, height-80, 100, 20);
  triangle(90, height-70, 120, height-100, 120, height-40);

  stroke(100); 
  fill(100, 100, 100, 100);
  rect(85, height-105, 120, 70);
  
  //stopknop
  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("STOP", 270, height-55);

  stroke(100); 
  fill(100, 100, 100, 100);
  rect(215, height-105, 110, 70);
  
  //knoppen worden ingedrukt 
  if(update(85, height-105, 120, 70)) { //terugknop
    delay(200);
    screenPage = 1; //de terugknop verwijst naar play
  } else if (update(215, height-105, 110, 70)) { //stopknop
    laatstePagina = screenPage;
    screenPage = 6;
  } else if (update(x - 400, y-200, breedteButton, hoogteButton)) {
    screenPage = 10;
  } else if (update(x + 400, y-200, breedteButton, hoogteButton)) {
    screenPage = 11;
  } else if (update(x - 400, y+48, breedteButton, hoogteButton)) {
    screenPage = 12;
  } else if (update(x + 400, y+48, breedteButton, hoogteButton)) {
    screenPage = 13;
  } else if (update(x, y+296, breedteButton, hoogteButton)) {
    screenPage = 14;
  }
}
