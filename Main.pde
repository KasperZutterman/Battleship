int posBoot5X = 10, posBoot5Y = 10;
int screenPage = 0;
PImage logo;
PImage backGround;
boolean classicAlGespeeld = false; 
boolean campaignAlGespeeld = false;
boolean level_0_AlGespeeld = false; 
boolean level_1_AlGespeeld = false;
boolean level_2_AlGespeeld = false;
boolean level_3_AlGespeeld = false; 
boolean level_4_AlGespeeld = false; 
boolean Campaign_level_0_AlGespeeld = false; 
boolean Campaign_level_1_AlGespeeld = false;
boolean Campaign_level_2_AlGespeeld = false;
boolean Campaign_level_3_AlGespeeld = false; 
boolean Campaign_level_4_AlGespeeld = false; 
int laatstePagina = 0;
PFont f;
boolean terugAllowedDraw = false;
boolean shopAllowedDraw = false;
PImage bomLogo;
int puntenCampaign, puntenLevel_0, puntenLevel_1, puntenLevel_2, puntenLevel_3, puntenLevel_4;

Classic classic;
Level_0 level_0;
Level_1 level_1;
Level_2 level_2;
Level_3 level_3;
Level_4 level_4;

void setup() {
  fullScreen();
  f = createFont("Arial", 16, true);

  logo = loadImage("img/logo.PNG");
  backGround = loadImage("img/achtergrond.jpg");
  
  bomLogo = loadImage("img/bom.png");
  
  puntenCampaign = 0;
  puntenLevel_0 = 0;
  puntenLevel_1 = 0; 
  puntenLevel_2 = 0;
  puntenLevel_3 = 0;
  puntenLevel_4 = 0;
}

void draw() {
  background(0);

  if (screenPage == 0) {
    homePage();
  } else if (screenPage == 1) {
    play();
  } else if (screenPage == 2) {
    regels();
  } else if (screenPage == 3) {
    quit();
  } else if (screenPage == 4) {
    if (!classicAlGespeeld) {
      classic = new Classic();
      classicAlGespeeld = true;
    }
    if (classicAlGespeeld) {
      classic.act();
    }
  } else if (screenPage == 5) {
    if (!campaignAlGespeeld) {
      level_0 = new Level_0("Campaign - 0", true);
      level_1 = new Level_1("Campaign - 1", true);
      level_2 = new Level_2("Campaign - 2", true);
      level_3 = new Level_3("Campaign - 3", true);
      level_4 = new Level_4("Campaign - 4", true);
      campaignAlGespeeld = true;
      level_0_AlGespeeld = false;
      level_1_AlGespeeld = true;
      level_2_AlGespeeld = true;
      level_3_AlGespeeld = true;
      level_4_AlGespeeld = true;
    } else {
      if (!level_0_AlGespeeld) {
        level_0.act();
      } else if (!level_1_AlGespeeld) {
        level_1.act();
      } else if (!level_2_AlGespeeld) {
        level_2.act();
      } else if (!level_3_AlGespeeld) {
        level_3.act();
      } else if (!level_4_AlGespeeld) {
        level_4.act();
      }
    }
  } else if (screenPage == 6) {
    stopknop(laatstePagina);
  } else if (screenPage == 7) {
    regels();
  } else if (screenPage == 8) {
    regels2();
  } else if (screenPage == 9) {
    levels();
  } else if (screenPage == 10) {
    if (!level_0_AlGespeeld) {
      level_0 = new Level_0("Level 0", false);
      level_0_AlGespeeld = true;
    } else {
      level_0.act();
    }
  } else if (screenPage == 11) {
    if (!level_1_AlGespeeld) {
      level_1 = new Level_1("Level 1", false);
      level_1_AlGespeeld = true;
    } else {
      level_1.act();
    }
  } else if (screenPage == 12) {
    if (!level_2_AlGespeeld) {
      level_2 = new Level_2("Level 2", false);
      level_2_AlGespeeld = true;
    } else {
      level_2.act();
    }
  } else if (screenPage == 13) {
    if (!level_3_AlGespeeld) {
      level_3 = new Level_3("Level 3", false);
      level_3_AlGespeeld = true;
    } else {
      level_3.act();
    }
  } else if (screenPage == 14) {
    if (!level_4_AlGespeeld) {
      level_4 = new Level_4("Level 4", false);
      level_4_AlGespeeld = true;
    } else {
      level_4.act();
    }
  }
  
  /*-------------terugAllowedDraw wordt enkel true bij de spelvormen, vandaar dat screenPage ook 1 is, geldt voor alle spelvormen*/
  if (terugAllowedDraw) {
    drawTerugknop();
  }
  
  if (shopAllowedDraw) {
    drawShop();
  }
}

public void drawTerugknop() {
  textAlign(CENTER);
  //variabelen declareren
  float u = 500;
  float v = 300;
  float x = width/2 - u/2;
  float y = height/2 - v/2;
  float a = 50, b = 150; //resp. extra waarde bij x- en y- coördinaat voor ja-knop
  float c = 150, d = 100; //resp. breedte en hoogte van ja-knop
  
  //omkadering van warning
  stroke(0);
  fill(255);
  rect(x, y, u, v);
  
  //warning tekst
  stroke(0);
  fill(255,0,0);
  textSize(24);
  text("Bent u zeker dat u wilt terugkeren?", x+250, y+100);
  text("Note: alle gegevens gaan verloren!", x + 250, y + 135);
  
  //warning > ja
  fill(255,0,0);
  stroke(0);
  rect(x+a, y+b, c, d);
  
  fill(255);
  textSize(50);
  text("Ja", x+125, y+215);
  
  //warning > nee
  fill(255,0,0);
  stroke(0);
  rect(x+u-a-c, y+b, c, d);
  
  fill(255);
  textSize(50);
  text("Nee", x+u-125, y+215);
  
  //knoppen worden ingedrukt
  if(update(x+a, y+b, c, d)) { //bij ja worden alle nodige variabelen gereset
    delay(200);
    screenPage = 1;
    classicAlGespeeld = false;
    campaignAlGespeeld = false;
    Campaign_level_0_AlGespeeld = false;
    Campaign_level_1_AlGespeeld = false;
    Campaign_level_2_AlGespeeld = false;
    Campaign_level_3_AlGespeeld = false;
    Campaign_level_4_AlGespeeld = false;
    level_0_AlGespeeld = false;
    level_1_AlGespeeld = false;
    level_2_AlGespeeld = false;
    level_3_AlGespeeld = false;
    level_4_AlGespeeld = false;
    terugAllowedDraw = false;
    shopAllowedDraw = false;
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
  } else if(update(x+u-a-c, y+b, c, d)) {
    delay(200);
    terugAllowedDraw = false;
  }
}

public void drawShop() {
  float posX = 1600, posY = 360; //positie button 1
  float u = 275;
  float v = 105;

  /*---------plaatsen van de afbeelding bom---------*/
  image(bomLogo, width-100, 4, 100, 100);
  
  /*---------plaatsen van de knoppen---------*/
  //plaatsen button1
  fill(100, 0);
  stroke(255);
  
  rect(posX, posY, u, v);
  
  //plaatsen button2
  rect(posX, posY + 135, u, v);
  
  //plaatsen button3
  rect(posX, posY + 270, u, v);
  
  //plaatsen button4
  rect(posX, posY + 405, u, v);
  
  //plaatsen button5
  rect(posX, posY + 540, u, v);
  
  /*---------plaatsen van de lijnen---------*/
  fill(255);
  
  //linker lijn
  line(1351, 0, 1351, height);
  
  //onder titel
  line(1351, 90, width, 90);
  
  //onder legende
  line(1351, 150, width, 150);
  
  //onder uitleg van de werking
  line(1355, 295, width, 295);
  
  //onder soorten bommen
  line(1355, 345, width, 345);
  
  /*---------plaatsen van de tekst---------*/
  fill(#B22222);
  textAlign(LEFT);
  
  textSize(50);
  text("Shop", 1380, 70);
  
  textSize(30);
  text("Legende", 1380, 130);
  
  //legende en uitleg
  fill(255);
  rect(1380, 165, 20, 20);
  stroke(0);
  line(1380, 185, 1400, 165);
  line(1380, 165, 1400, 185);
  textSize(20);
  textAlign(LEFT);
  text("Dit is het vakje dat je plaatst in het veld", 1415, 166, 500, 170);
  text("De bommen met .../... verdraaien of veranderen indien op de spatie-toets wordt gedrukt", 1380, 220, 540, 250);
  
  //soorten bommen
  fill(#B22222);
  textSize(30);
  textAlign(LEFT);
  text("Soorten bommen",1375,330);
  
  /*---------plaatsen van bommen----------*/
  //bom 200ptn
  fill(255);
  text("200 ptn:", 1375, 415);
  rect(1650, 398, 20, 20);
  line(1650, 398, 1670, 418);
  line(1650, 418, 1670, 398);
  rect(1670, 398, 20, 20);
  text("/", 1725, 418);
  rect(1776, 388, 20, 20);
  line(1776, 388, 1796, 408);
  line(1776, 408, 1796, 388);
  rect(1776, 408, 20, 20);
  
  //bom 300ptn
  text("300 ptn:", 1375, 550);
  rect(1640, 535, 20, 20);
  rect(1660, 535, 20, 20);
  line(1660, 535, 1680, 555);
  line(1660, 555, 1680, 535);
  rect(1680, 535, 20, 20);
  text("/", 1725, 555);
  rect(1776, 515, 20, 20);
  rect(1776, 535, 20, 20);
  line(1776, 535, 1796, 555);
  line(1776, 555, 1796, 535);
  rect(1776, 555, 20, 20);
  
  //bom 500ptn
  text("500 ptn:", 1375, 690);
  rect(1640, 670, 20, 20);
  rect(1660, 670, 20, 20);
  line(1660, 670, 1680, 690);
  line(1660, 690, 1680, 670);
  rect(1660, 650, 20, 20);
  rect(1660, 690, 20, 20);
  rect(1680, 670, 20, 20);
  text("/", 1725, 691);
  rect(1766, 650, 20, 20);
  rect(1766, 690, 20, 20);
  rect(1786, 670, 20, 20);
  line(1786, 670, 1806, 690);
  line(1786, 690, 1806, 670);
  rect(1806, 650, 20, 20);
  rect(1806, 690, 20, 20);
  
  //bom 900ptn
  text("900 ptn:", 1375, 825);
  rect(1702, 785, 20, 20);
  rect(1722, 785, 20, 20);
  rect(1742, 785, 20, 20);
  rect(1702, 805, 20, 20);
  rect(1722, 805, 20, 20);
  line(1722, 805, 1742, 825);
  line(1722, 825, 1742, 805);
  rect(1742, 805, 20, 20);
  rect(1702, 825, 20, 20);
  rect(1722, 825, 20, 20);
  rect(1742, 825, 20, 20);
  
  //bom 1000 ptn
  text("1000 ptn:", 1375, 960);
  text("...", 1610, 955);
  rect(1640, 942, 20, 20);
  rect(1660, 942, 20, 20);
  line(1660, 942, 1680, 962);
  line(1660, 962, 1680, 942);
  rect(1680, 942, 20, 20);
  text("...", 1702, 955);
  text("/", 1745, 960);
  text(".", 1792, 908);
  text(".", 1792, 914);
  text(".", 1792, 920);
  rect(1786, 922, 20, 20);
  rect(1786, 942, 20, 20);
  line(1786, 942, 1806, 962); 
  line(1786, 962, 1806, 942);
  rect(1786, 962, 20, 20);
  text(".", 1792, 989);
  text(".", 1792, 995);
  text(".", 1792, 1001);
}
