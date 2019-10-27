void regels() {
  //achtergrond instellen
  imageMode(CORNER);
  image(backGround, 0, 0, width, height);
  
  //omkadering van tekst
  stroke(100); 
  fill(100, 100, 100, 100);
  rect(40, 50, 350, 130);
  rect(40, 200, width-80, 215);
  rect(40, 425, width-80, 285);
  rect(40, 720, width-80, 155);
  
  //tekst
  fill(255);
  textSize(100);
  textAlign(LEFT);
  text("Regels", 50, 150); 
  
  textSize(50);
  textAlign(LEFT);
  text("Doel", 50, 250);
  text("Verloop van het spel", 50, 485);
  text("Opmerking", 50, 770);
  
  textSize(25);
  textAlign(LEFT);
  text("Het doel van het spel is om alle vijandelijke schepen te vernietigen met bommen." , 50, 290);
  text("Elke speler laat om de beurt een bom op een coördinaat vallen." ,50 ,325);
  text("De bedoeling van het spel is om alle vijandelijke schepen te laten zinken.", 50, 360);
  text("De eerste persoon die alle vijandelijke schepen heeft laten zinken, wint het spel." ,50 ,395);
  text("Je kiest waar jouw boten op het spelbord worden gepositioneerd." ,50, 525);
  text("Plaats alle vijf de boten op je spelbord." ,50, 560);
  text("De verschillende boten mogen niet tegen elkaar liggen, behalve bij levels 1 en 3." ,50, 595);
  text("Eens de boten gepositioneerd zijn kan het spel beginnen." ,50, 630);
  text("Op die coördinaat zal er een bom vallen." ,50, 665);
  text("Om een boot of een bom van riching of vorm te doen veranderen, druk je op spatie." , 50, 700);
  text("Wanneer je bij het plaatsen van de boten van horizontaal naar verticaal wil gaan (en vice versa), dan moet je op de spatie-toest drukken", 50, 820);
  text("Dit geldt ook voor het veranderen van de vorm/ligging van de speciale bommen uit de shop.", 50, 855);
  
  //knoppen die naar regels2() verwijzen
  fill(180, 60, 60, 100);
  rect(width/2-75, 915, 50, 50);
  
  fill(255);
  stroke(255);
  triangle(width/2-65, 930, width/2-65, 950, width/2-35 , 940);
  
  //terugknop
  stroke(255);
  fill(255, 255, 255, 255);
  rect(100, height-80, 100, 20);
  triangle(90, height-70, 120, height-100, 120, height-40);

  stroke(100); 
  fill(100, 100, 100, 100);
  rect(85, height-105, 120, 70); //dit is de stopknop zelf

  //stopknop
  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("STOP", 270, height-55);

  stroke(100); 
  fill(100, 100, 100, 100);
  rect(215, height-105, 110, 70);
  
  //knoppen worden ingedrukt
  if(update(85, height-105, 120, 70)) {
    delay(200);
    screenPage = 0; //de terugknop verwijst naar de homepage
  }  else if (update(215, height-105, 110, 70)) {
    laatstePagina = screenPage;
    screenPage = 6;
    delay(200);
  } else if (update(width/2-75, 915, 50, 50)) {
    screenPage = 8;
    delay(200);
  }
}

void regels2() {
  //instellen van achtergrond
  imageMode(CORNER);
  image(backGround, 0, 0, width, height);
  
  stroke(100); 
  fill(100, 100, 100, 100);
  rect(40, 50, 500, 130);
  rect(40, 200, width-80, 190);
  rect(40, 400, width-80, 330);
  rect(40, 741, width-80, 155);
 
  
  fill(255);
  textSize(75);
  textAlign(LEFT);
  text("Spelvarianten", 50, 150); 
  
  textSize(50);
  textAlign(LEFT);
  text("Campaign", 50, 250);
  text("Levels", 50, 450);
  text("Classic", 50, 800);
  
  
  textSize(25);
  textAlign(LEFT);
  text("Bij 'Campaign' worden de verschillende levels van 0 tot 1 doorlopen. Als je wint ga je naar een hoger en moeilijker level", 50, 300);
  text("Om beurten wordt er een bom gevuurd op het veld van de tegenstander." , 50, 335);
  text("Degene die erin slaagt om de alle boten van de tegenstander te raken, wint het spel." , 50, 370);
  
  text("Elk level heeft zijn eigen uitbreiding:" ,50 ,500);
  text("Level 0: een classic-versie met hunt-mode (computer zoekt boten rond een hit).", 85, 535);
  text("Level 1: de boten mogen tegen elkaar geplaatst worden bij aanvang van het spel.", 85, 570);
  text("Level 2: Als de pc 8 boothokjes achter staat, zal de kans op een hit verhogen (voor de computer).", 85, 605);
  text("Level 3: De computer zoekt vanaf nu diagonaal i.p.v. willekeurig (als nog geen boot geraakt is).",85, 640);
  text("Dit verhoogt de kans op het vinden van een boot.", 186, 675);
  text("Level 4: De kans dat de computer een boot raakt wordt nog groter (analoog naar level 2).", 85, 710);
  
  text("Classic is de meest eenvoudige spelvorm waarbij de computer random vakjes kiest.", 50, 850);
  text("Boten mogen hier niet tegen elkaar gezet worden", 50, 885);


  //knoppen die naar regels() verwijzen
  fill(180, 60, 60, 100);
  rect(width/2-75, 915, 50, 50);
  
  fill(255);
  stroke(255);
  triangle(width/2-65, 940, width/2-35, 930, width/2-35, 950);

  //terugknop
  stroke(255);
  fill(255, 255, 255, 255);
  rect(100, height-80, 100, 20);
  triangle(90, height-70, 120, height-100, 120, height-40);

  stroke(100); 
  fill(100, 100, 100, 100);
  rect(85, height-105, 120, 70); //dit is de knop zelf

  //stopknop
  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("STOP", 270, height-55);

  stroke(100); 
  fill(100, 100, 100, 100);
  rect(215, height-105, 110, 70);
  
  //knoppen worden ingedrukt
  if(update(85, height-105, 120, 70)) {
    delay(200);
    screenPage = 0; //de terugknop verwijst naar de homepage
  } else if (update(215, height-105, 110, 70)) {
    delay(200);
    laatstePagina = screenPage;
    screenPage = 6;
  } else if (update(width/2-75, 915, 50, 50)) {
    delay(200);
    screenPage = 7;
  }
}
