//OPM: alle arrays van de vorm boot#X en boot#Y zijn bedoeld als coördinaten van boten van speler
//     alle arrays van de vorm boot#CX en boot#CY zijn bedoeld als coördinaten van boten van cpu

public class Level_1 {
  /*--------------Het spel krijgt een titel--------------*/
  private String title;
  
  /*--------------Variabelen die nodig zijn om het spel te laten werken--------------*/
  private int w = 60;
  private int h = 60;
  private boolean gewonnen, verloren;
  private int schotenDoorComputer = 0;
  private int schotenDoorSpeler = 0;
  private int[] potentialT_x = {}; //lijst met potentiele x target posities
  private int[] potentialT_y = {}; //lijst met potentiele y target posities
  private int hitDoorComputer = 0; // variabele die bijhoudt hoeveel bootjes al zijn geraakt door de computer
  private int hitDoorSpeler = 0;   // variabele die bijhoudt hoeveel bootjes al zijn geraakt door de speler
  private boolean wasNietTerug;
  private int bomType;
  private boolean bomDirection, bomHover;
  private boolean boot5Geraakt, boot4Geraakt, boot3Geraakt, boot2Geraakt, boot1Geraakt;
  private boolean campaign; //als level 0 in campaign wordt opgeroepen dan mag op het einde niet gevraagd worden om opnieuw te spelen maar dan moet gevraagd worden of speler verder wil gaan

  /*--------------Bord wordt gemaakt--------------*/
  private Bord bordC = new Bord(40, 240, 10, 10, w, h);
  private Bord bordP = new Bord(720, 240, 10, 10, w, h);

  /*--------------Boten worden gemaakt, er wordt een array gemaakt om de boten in te zetten--------------*/
  ArrayList<Boot> bootArray;

  Boot boot5 = new Boot(750, 975, 5, true, 5, w, h);
  Boot boot4 = new Boot(750, 875, 4, true, 4, w, h);
  Boot boot3 = new Boot(1110, 975, 3, true, 3, w, h);
  Boot boot2 = new Boot(1020, 875, 2, true, 2, w, h);
  Boot boot1 = new Boot(1170, 875, 2, true, 1, w, h);

  /*--------------Variabelen die de definitieve coördinaten van boten bijhoudt--------------*/
  private int[] boot5X, boot5Y, boot4X, boot4Y, boot3X, boot3Y, boot2X, boot2Y, boot1X, boot1Y;
  private int[] boot5CX, boot5CY, boot4CX, boot4CY, boot3CX, boot3CY, boot2CX, boot2CY, boot1CX, boot1CY;

  public Level_1(String _title, boolean _campaign) {  
    title = _title;
    campaign = _campaign;
    
    bootArray = new ArrayList<Boot>();
    bootArray.add(boot5);
    bootArray.add(boot4);
    bootArray.add(boot3);
    bootArray.add(boot2);
    bootArray.add(boot1);

    //Variabelen die de definitieve coördinaten van boten bijhoudt
    if (!boot5.geplaatst) {
      boot5X = new int[5]; //x stelt rij voor (beetje ongelukkig gekozen omdat kol van links naar rechts gaat en niet rij...)
      boot5Y = new int[5]; //y stelt kolom voor
    }
    if (!boot4.geplaatst) {
      boot4X = new int[4];
      boot4Y = new int[4];
    }
    if (!boot3.geplaatst) {
      boot3X = new int[3];
      boot3Y = new int[3];
    }
    if (!boot2.geplaatst) {
      boot2X = new int[2];
      boot2Y = new int[2];
    }
    if (!boot1.geplaatst) {
      boot1X = new int[2];
      boot1Y = new int[2];
    };

    //variabelen die de coördinaten van boten van computer bijhoudt
    boot5CX = new int[5];
    boot5CY = new int[5]; 
    boot4CX = new int[4];
    boot4CY = new int[4];
    boot3CX = new int[3]; 
    boot3CY = new int[3]; 
    boot2CX = new int[2];
    boot2CY = new int[2];
    boot1CX = new int[2];
    boot1CY = new int[2];

    //variabelen die nodig zijn om het spel te laten werken !!OPM: w en h worden onmiddellijk geïnitialiseerd bij het declareren
    gewonnen = false;
    verloren = false;
    wasNietTerug = false;
    bomType = 0;
    bomDirection = true;
    bomHover = true;
    boot5Geraakt = false;
    boot4Geraakt = false;
    boot3Geraakt = false;
    boot2Geraakt = false;
    boot1Geraakt = false;
  }

  public void act() {
    shopAllowedDraw = true;
    /*--------------Alle tekst wordt hier gebundeld--------------*/
    //aanduiden dat de gebruiker in de classic zit
    textAlign(CENTER, TOP);
    textFont(f, 75);
    fill(255);
    text(title, width/2, 70);
    text("Punten: " + puntenLevel_1, 320, 860);

    //aanduiden welk bord van wie is
    textAlign(LEFT);
    textFont(f, 25);
    fill(120);
    text("Computers veld:", bordC.posX, bordC.posY - 15);
    text("Spelers veld:", bordP.posX, bordP.posY - 15);

    /*--------------Borden van speler en Computer worden getekend--------------*/
    bordP.drawBord();
    bordC.drawBord();

    /*--------------De stopknop en de teruknop worden getekend--------------*/
    //terugknop wordt getekend
    stroke(255);
    fill(255, 255, 255, 255);
    rect(100, height-80, 100, 20);
    triangle(90, height-70, 120, height-100, 120, height-40);

    stroke(100); 
    fill(100, 100, 100, 100);
    rect(85, height-105, 120, 70);

    //stopknop wordt getekend
    fill(255);
    textSize(40);
    textAlign(CENTER);
    text("STOP", 270, height-55);

    stroke(100); 
    fill(100, 100, 100, 100);
    rect(215, height-105, 110, 70);

    /*--------------Als de stopknop of de terugknop worden ingedrukt moeten de correcte acties uitgevoerd worden--------------*/
    if (update(85, height-105, 120, 70) || wasNietTerug) {
      delay(200);
      terugAllowedDraw = true;
    } else if (update(215, height-105, 110, 70)) {
      laatstePagina = screenPage;
      screenPage = 6;
    }

    //Als nog niet alle boten gezet zijn moeten die uiteraard eerst gezet worden
    if (!alleBotenGezet()) {
      nietAlleBotenGeplaatst();
    } else if (gewonnen || verloren) {
      if (gewonnen) {
        textFont(f, 100);
        fill(0, 127, 0);
        textAlign(LEFT);
        text("Gewonnen!", 100, 150);
      } else {
        textFont(f, 100);
        fill(127, 0, 0); 
        textAlign(LEFT);
        text("Verloren!", 100, 150);
      }
      if (!campaign) {
        opnieuwSpelen(screenPage);
      } else {
        if (gewonnen) {
          vragenNextLevel(1);
        } else  {
          opnieuwSpelenCampaign(screenPage);
        }
      }
      
    } else if (alleBotenGezet() && !bordC.botenGezet) {
      setC();
      bordC.botenGezet = true;
    }

    //als alle boten van de speler gezet zijn en als alle boten van de computer gezet zijn kan het vuren beginnen
    else {
      if (hitDoorComputer == 16) {
        gewonnen = false;
        verloren = true;
      } else if (hitDoorSpeler == 16) {
        gewonnen = true;
        verloren = false;
      }

      /*------------------------------------------------------BEGIN VAN SPEL------------------------------------------------------*/
      if (schotenDoorSpeler == schotenDoorComputer) {
        checkShopPressed(); //eerst checken of de speler een bom wil kopen
        checkKeyPressed(); //eerst checken of de speler de bom wil doen veranderen van richting
        bonusPunten();

        if (hover(bordC.posX, bordC.posY, w*bordC.cols, h*bordC.rows)) {
          schietenDoorSpeler();
          //int rij = (mouseY - bordC.posY)/h;
          //int kol = (mouseX - bordC.posX)/w;
        }
      }
      // beurt computer om te schieten
      else if (schotenDoorComputer + 1 == schotenDoorSpeler) {
        //schietenDoorComputerClassic();
        if (potentialT_x.length == 0) {
          schietenDoorComputer();
        } else {
          hunt();
        }
      }
    }
  }

  /*
  *  het gedrag van de boten als die nog niet geplaatst zijn
   */
  private void nietAlleBotenGeplaatst() {
    hoverOverBord();
    for (Boot boot : bootArray) {
      allowedDraw();
      boot.drawBoot();
      boot.checkMoveBoot();
      boot.changeDirection();

      if (boot5.geplaatst) {
        for (int i = 0; i < 5; i++) {
          bordP.coord[boot5X[i]][boot5Y[i]].type = 1;
        }
      }
      if (boot4.geplaatst) {
        for (int i = 0; i < 4; i++) {
          bordP.coord[boot4X[i]][boot4Y[i]].type = 1;
        }
      }
      if (boot3.geplaatst) {
        for (int i = 0; i < 3; i++) {
          bordP.coord[boot3X[i]][boot3Y[i]].type = 1;;
        }
      }
      if (boot2.geplaatst) {
        for (int i = 0; i < 2; i++) {
          bordP.coord[boot2X[i]][boot2Y[i]].type = 1;
        }
      }
      if (boot1.geplaatst) {
        for (int i = 0; i < 2; i++) {
          bordP.coord[boot1X[i]][boot1Y[i]].type = 1;
        }
      }
    }
  }

  /*
  * als de muis binnen het bordP is wordt gekeken of een bot actief en nog niet geplaatst, zo ja: hover
   */
  private void hoverOverBord() {
    if (mouseX >= bordP.posX && mouseX <= (bordP.posX + w * bordP.cols) && mouseY >= bordP.posY && mouseY <= (bordP.posY + h *bordP.rows)) {
      int rij = (mouseY - bordP.posY)/h;
      int kol = (mouseX - bordP.posX)/w;

      // Als de muis net op de rand (rechts of onder) is wordt door de bovenstaande formule de coord 10, maar dit gaat niet binnen de array van 0-9, dus wordt de 10 als 9 aangenomen
      if (rij == bordP.cols) {
        rij = (bordP.cols - 1);
      } else if (kol == bordP.rows) {
        kol = bordP.rows - 1;
      }

      for (Boot boot : bootArray) {
        if (boot.actief && !boot.geplaatst) {
          hoverBoot(rij, kol, boot.lengte, boot.direction, boot.nummer);
        }
      }
    }
  }

  /*
  *  deze methode zorgt ervoor dat wanneer een boot wordt aangeklikt en over het veld wordt gesleept, dat de juiste hokjes op het bordP inkleuren. Bovendien, indien de muis klikt tijdens
   *  het actief aangeklikt zijn van een boot, én de boot bevindt zich in het veld worden de definitieve coördinaten van de corresponderende boten vastgelegd
   */
  public void hoverBoot(int rij, int kol, int lengte, boolean direction, int welkeBoot) {
    //OPMERKING: hier wordt niet gecontroleerd of de boot al dan niet in het bordP actief is, dit wordt gecontroleerd in de act()
    //als de boot horizontaal staat en volledig binnen het bordP is
    if (direction && kol + lengte - 1 < bordP.cols) { 
      //dan wordt gecontrolleerd hoeveel blokjes (met het hokje waarop de muis staat bijgeteld), naar rechts, er nog vrij zijn
      int leeg = 0;
      for (int i = 0; i < lengte; i++) {
        if (bordP.coord[rij][kol + i].type == 0) {
          leeg++;
        }
      }
      //als er evenveel hokjes vrij zijn als de lengte van de boot
      if (leeg == lengte) {
        //dan wordt over de corresponderende hokjes een rechthoek getekend die aanduidt waar de boot zou komen bij het aanklikken van de muis 
        for (int i = 0; i < lengte; i++) {
          if (bordP.coord[rij][kol + i].type == 0) {
            fill(60);
            rect(bordP.posX + ((kol  + i)* w), bordP.posY + (rij * h), w, h);
            coordBoten(rij, kol, welkeBoot, direction);
            checkBotenGeplaatst();
          }
        }
      }
      //als niet evenveel hokjes vrij zijn als de boot lang is
      else {
        //dan wordt een rode rechthoek getekend met corresponderende lengte en richting
        illigaleBoot(lengte, direction);
      }
    } 
    //als de boot verticaal staat en volledig binnen het bordP is, de rest is analoog naar horizontaal (de '+ i's staat nu bij de y-coördinaat i.p.v. de x-coördinaat)
    else if (!direction && rij + lengte - 1 < bordP.rows) {
      int leeg = 0;
      for (int i = 0; i < lengte; i++) {
        if (bordP.coord[rij + i][kol].type == 0) {
          leeg++;
        }
      }
      if (leeg == lengte) {
        for (int i = 0; i < lengte; i++) {
          if (bordP.coord[rij + i][kol].type == 0) {
            fill(60);
            rect(bordP.posX + (kol * w), bordP.posY + ((rij + i) * h), w, h);
            coordBoten(rij, kol, welkeBoot, direction);
            checkBotenGeplaatst();
          }
        }
      } else {
        illigaleBoot(lengte, direction);
      }
    }
    //als de muis met actieve boot wel in het bordP is maar de boot past niet in het bordP wordt ook een rode rechthoek getekend met corresponderende lengte en direction
    else {
      illigaleBoot(lengte, direction);
    }
  }

  /*
  *  er verschijnt een rood vierkant wanneer met de muis over een plaats wordt gegaan waar de boot niet kan of mag staan
   */
  private void illigaleBoot(int lengte, boolean direction) {
    if (direction) {
      fill(180, 60, 60);
      rect(mouseX, mouseY, lengte * w, h);
    } else if (!direction) {
      fill(180, 60, 60);
      rect(mouseX, mouseY, w, lengte * h);
    }
  }

  /*
  *  De coördinaten van de hoverende boten wordt continu bijgehouden, als de boot wordt gezet dan verdwijnt ze en zijn de laatst ingegeven coördinaten bijgehouden
   */
  private void coordBoten(int rij, int kol, int welkeBoot, boolean direction) {
    if (direction) {
      if (welkeBoot == 5 && boot5.actief) {
        for (int i = 0; i < 5; i++) {
          boot5X[i] = rij;
          boot5Y[i] = kol + i;
        }
      } else if (welkeBoot == 4 && boot4.actief) {
        for (int i = 0; i < 4; i++) {
          boot4X[i] = rij;
          boot4Y[i] = kol + i;
        }
      } else if (welkeBoot == 3 && boot3.actief) {
        for (int i = 0; i < 3; i++) {
          boot3X[i] = rij;
          boot3Y[i] = kol + i;
        }
      } else if (welkeBoot == 2 && boot2.actief) {
        for (int i = 0; i < 2; i++) {
          boot2X[i] = rij;
          boot2Y[i] = kol + i;
        }
      } else if (welkeBoot == 1 && boot1.actief) {
        for (int i = 0; i < 2; i++) {
          boot1X[i] = rij;
          boot1Y[i] = kol + i;
        }
      }
    } else {
      if (welkeBoot == 5 && boot5.actief) {
        for (int i = 0; i < 5; i++) {
          boot5X[i] = rij + i;
          boot5Y[i] = kol;
        }
      } else if (welkeBoot == 4 && boot4.actief) {
        for (int i = 0; i < 4; i++) {
          boot4X[i] = rij + i;
          boot4Y[i] = kol;
        }
      } else if (welkeBoot == 3 && boot3.actief) {
        for (int i = 0; i < 3; i++) {
          boot3X[i] = rij + i;
          boot3Y[i] = kol;
        }
      } else if (welkeBoot == 2 && boot2.actief) {
        for (int i = 0; i < 2; i++) {
          boot2X[i] = rij + i;
          boot2Y[i] = kol;
        }
      } else if (welkeBoot == 1 && boot1.actief) {
        for (int i = 0; i < 2; i++) {
          boot1X[i] = rij + i;
          boot1Y[i] = kol;
        }
      }
    }
  }

  /*
  * deze methode controlleert of alle boten al dan niet zijn gezet
   */
  private boolean alleBotenGezet() {
    if (boot5.geplaatst && boot4.geplaatst && boot3. geplaatst && boot2.geplaatst && boot1.geplaatst) {
      return true;
    }

    return false;
  }

  /*
  * als de boot binnen het bordP vasthangt aan muis mag ze niet getoond worden;
   * alsook als de boot geplaatst is mag de gebruiker het object niet meer zien
   */
  private void allowedDraw() {
    for (Boot boot : bootArray) {
      if (hover(bordP.posX, bordP.posY, w * bordP.cols, h * bordP.rows) && boot.actief && !boot.geplaatst) {
        boot.allowedDraw = false;
      } else {
        boot.allowedDraw = true;
      }

      //controlleert of de boot actief is, er over het bordP wordt gehoverd en op de moment dat er wordt geklikt verdwijnt de boot (bekijk twee opeenvolgende if-statements)
      if (boot.actief && hover(bordP.posX, bordP.posY, w * bordP.cols, h *  bordP.rows) && mousePressed && !boot.wasPressedInBord) {
        boot.wasPressedInBord = true;
      }
      if (boot.wasPressedInBord) {
        boot.allowedDraw = false;
      }
    }
  }

  /*
  *  update de waarden voor boot#.geplaatst
   */
  private void checkBotenGeplaatst() {
    for (Boot boot : bootArray) {
      if (!boot.allowedDraw && mousePressed) {
        boot.geplaatst = true;
        boot.actief = false;
        boot.allowedDraw = false;
      }
    }
  }

  /*
  *  de computers coördinaten worden bepaald TODO: zet direction terug naar random
   */
  private void setC() {
    noLoop();
    int tel = 0; //dit wordt toegevoegd om er 100% zeker van te zijn dat het spel nooit in een oneindige lus terecht komt
    //deze while-lus is toegevoegd om ervoor te zorgen dat zeker boten elkaar niet overlappen, soms kwam er een blokje van type 4 over een blokje van type 3... nu gebeurt dit niet meer (toch niet uiteindelijk)
    while (!alleBotenCGeplaatst() && tel < 5000) {
      for (int i = 0; i < bordC.rows; i++) {
        for (int j = 0; j < bordC.cols; j++) {
          bordC.coord[i][j].type = 0;
        }
      }
      //boot 5  wordt gemaakt: eerst worden random rij en kolom gekozen
      int boot5CX_start = int(random(bordC.rows));
      int boot5CY_start = int(random(bordC.cols));
      //boot 5  wordt gemaakt: een random richting wordt gekozen (direction = 0 -> horizontaal; direction = 1 -> verticaal)
      int direction = int(random(2));
      //als direction horizontaal is, moet de boot binnen het veld passen (elk hokje is bovendien nog leeg, dit moet dus niet in rekening gebracht worden)
      if (direction == 0) {
        if (boot5CY_start + 4 >= bordC.cols) {
          while (boot5CY_start + 4 >= bordC.cols) {
            boot5CX_start = int(random(bordC.rows));
            boot5CY_start = int(random(bordC.cols));
          }
        }
        //boot 5  wordt gemaakt: als de startwaarde oke is worden de coordinaten van elk hokje van de boot bijgehouden
        for (int i = 0; i < 5; i++) {
          boot5CX[i] = boot5CX_start;
          boot5CY[i] = boot5CY_start + i;
        }
        //boot 5 wordt gemaakt: alle hokjes krijgen de gepaste type (de boot zelf en de omliggende hokjes)
        for (int i = 0; i < 5; i++) {
          bordC.coord[boot5CX[i]][boot5CY[i]].type = 3;
        }
      } else { //hier is alles hetzelfde maar dan voor verticaal ipv horizontaal
        if (boot5CX_start + 4 >= bordC.rows) {
          while (boot5CX_start + 4 >= bordC.rows) {
            boot5CX_start = int(random(bordC.rows));
            boot5CY_start = int(random(bordC.cols));
          }
        }
        for (int i = 0; i < 5; i++) {
          boot5CX[i] = boot5CX_start + i;
          boot5CY[i] = boot5CY_start;
        }
        for (int i = 0; i < 5; i++) {
          bordC.coord[boot5CX[i]][boot5CY[i]].type = 3;
        }
      }

      //boot 4 wordt gemaakt: alles in naar analogie van boot5 (behalve vanaf nu wordt wel rekening gehouden met de types hokjes bij het bepalen van een goede startwaarde voor x en y
      int boot4CX_start = int(random(bordC.rows));
      int boot4CY_start = int(random(bordC.cols));
      direction = int(random(2));
      if (direction == 0) {
        //hier wordt gecontroleerd of de boot in het veld past, dit moet eerst gebeuren vooralleer er wordt gecontroleerd of de startwaarde in de weg staat van andere boten omdat je anders ArrayOutOfBoundaries-errors krijgt
        if (boot4CY_start + 3 > bordC.cols - 1) {
          while (boot4CY_start + 3 > bordC.cols - 1) {
            boot4CX_start = int(random(bordC.rows));
            boot4CY_start = int(random(bordC.cols));
          }
          //stel dat de startwaarde niet oke is (wel binnen veld), dan wordt een andere startwaarde gezocht, die nieuwe startwaarde moet natuurlijk nog steeds binnen het veld zijn
          if (bordC.coord[boot4CX_start][boot4CY_start].type != 0 || bordC.coord[boot4CX_start][boot4CY_start + 1].type != 0 || bordC.coord[boot4CX_start][boot4CY_start + 2].type != 0 || bordC.coord[boot4CX_start][boot4CY_start + 3].type != 0) {
            while (boot4CY_start + 3 > bordC.cols - 1 || bordC.coord[boot4CX_start][boot4CY_start].type != 0 || bordC.coord[boot4CX_start][boot4CY_start + 1].type != 0 || bordC.coord[boot4CX_start][boot4CY_start + 2].type != 0 || bordC.coord[boot4CX_start][boot4CY_start + 3].type != 0) {
              boot4CX_start = int(random(bordC.rows));
              boot4CY_start = int(random(bordC.cols));
            }
          }
        }
        //nu de startwaarde goed is, kunnen we de coordinaten opslaan
        for (int i = 0; i < 4; i++) {
          boot4CX[i] = boot4CX_start;
          boot4CY[i] = boot4CY_start + i;
        }
        for (int i = 0; i < 4; i++) {
          bordC.coord[boot4CX[i]][boot4CY[i]].type = 3;
        }
      } else {
        if (boot4CX_start + 3 > bordC.rows - 1) {
          while (boot4CX_start + 3 > bordC.rows - 1) {
            boot4CX_start = int(random(bordC.rows));
            boot4CY_start = int(random(bordC.cols));
          }
        }
        if (bordC.coord[boot4CX_start][boot4CY_start].type != 0 || bordC.coord[boot4CX_start + 1][boot4CY_start].type != 0 || bordC.coord[boot4CX_start + 2][boot4CY_start].type != 0 || bordC.coord[boot4CX_start + 3][boot4CY_start].type != 0) {
          while (boot4CX_start + 3 > bordC.rows - 1 || bordC.coord[boot4CX_start][boot4CY_start].type != 0 || bordC.coord[boot4CX_start + 1][boot4CY_start].type != 0 || bordC.coord[boot4CX_start + 2][boot4CY_start].type != 0 || bordC.coord[boot4CX_start + 3][boot4CY_start].type != 0) {
            boot4CX_start = int(random(bordC.rows));
            boot4CY_start = int(random(bordC.cols));
          }
        }
        for (int i = 0; i < 4; i++) {
          boot4CX[i] = boot4CX_start + i;
          boot4CY[i] = boot4CY_start;
        }
        for (int i = 0; i < 4; i++) {
          bordC.coord[boot4CX[i]][boot4CY[i]].type = 3;
        }
      }

      //boot 3 wordt gemaakt: alles in naar analogie van boot5 (behalve vanaf nu wordt wel rekening gehouden met de types hokjes bij het bepalen van een goede startwaarde voor x en y
      int boot3CX_start = int(random(bordC.rows));
      int boot3CY_start = int(random(bordC.cols));
      direction = int(random(2));
      if (direction == 0) {
        //hier wordt gecontroleerd of de boot in het veld past, dit moet eerst gebeuren vooralleer er wordt gecontroleerd of de startwaarde in de weg staat van andere boten omdat je anders ArrayOutOfBoundaries-errors krijgt
        if (boot3CY_start + 2 > bordC.cols - 1) {
          while (boot3CY_start + 2 > bordC.cols - 1) {
            boot3CX_start = int(random(bordC.rows));
            boot3CY_start = int(random(bordC.cols));
          }
          //stel dat de startwaarde niet oke is (wel binnen veld), dan wordt een andere startwaarde gezocht, die nieuwe startwaarde moet natuurlijk nog steeds binnen het veld zijn
          if (bordC.coord[boot3CX_start][boot3CY_start].type != 0 || bordC.coord[boot3CX_start][boot3CY_start + 1].type != 0 || bordC.coord[boot3CX_start][boot3CY_start + 2].type != 0) {
            while (boot3CY_start + 2 > bordC.cols - 1 || bordC.coord[boot3CX_start][boot3CY_start].type != 0 || bordC.coord[boot3CX_start][boot3CY_start + 1].type != 0 || bordC.coord[boot3CX_start][boot3CY_start + 2].type != 0) {
              boot3CX_start = int(random(bordC.rows));
              boot3CY_start = int(random(bordC.cols));
            }
          }
        }
        //nu de startwaarde goed is, kunnen we de coordinaten opslaan
        for (int i = 0; i < 3; i++) {
          boot3CX[i] = boot3CX_start;
          boot3CY[i] = boot3CY_start + i;
        }
        for (int i = 0; i < 3; i++) {
          bordC.coord[boot3CX[i]][boot3CY[i]].type = 3;
        }
      } else {
        if (boot3CX_start + 2 > bordC.rows - 1) {
          while (boot3CX_start + 2 > bordC.rows - 1) {
            boot3CX_start = int(random(bordC.rows));
            boot3CY_start = int(random(bordC.cols));
          }
        }
        if (bordC.coord[boot3CX_start][boot3CY_start].type != 0 || bordC.coord[boot3CX_start + 1][boot3CY_start].type != 0 || bordC.coord[boot3CX_start + 2][boot3CY_start].type != 0) {
          while (boot3CX_start + 2 > bordC.rows - 1 || bordC.coord[boot3CX_start][boot3CY_start].type != 0 || bordC.coord[boot3CX_start + 1][boot3CY_start].type != 0 || bordC.coord[boot3CX_start + 2][boot3CY_start].type != 0) {
            boot3CX_start = int(random(bordC.rows));
            boot3CY_start = int(random(bordC.cols));
          }
        }
        for (int i = 0; i < 3; i++) {
          boot3CX[i] = boot3CX_start + i;
          boot3CY[i] = boot3CY_start;
        }
        for (int i = 0; i < 3; i++) {
          bordC.coord[boot3CX[i]][boot3CY[i]].type = 3;
        }
      }

      //boot 2 wordt gemaakt: alles in naar analogie van boot5 (behalve vanaf nu wordt wel rekening gehouden met de types hokjes bij het bepalen van een goede startwaarde voor x en y
      int boot2CX_start = int(random(bordC.rows));
      int boot2CY_start = int(random(bordC.cols));
      direction = int(random(2));
      if (direction == 0) {
        //hier wordt gecontroleerd of de boot in het veld past, dit moet eerst gebeuren vooralleer er wordt gecontroleerd of de startwaarde in de weg staat van andere boten omdat je anders ArrayOutOfBoundaries-errors krijgt
        if (boot2CY_start + 1 > bordC.cols - 1) {
          while (boot2CY_start + 1 > bordC.cols - 1) {
            boot2CX_start = int(random(bordC.rows));
            boot2CY_start = int(random(bordC.cols));
          }
          //stel dat de startwaarde niet oke is (wel binnen veld), dan wordt een andere startwaarde gezocht, die nieuwe startwaarde moet natuurlijk nog steeds binnen het veld zijn
          if (bordC.coord[boot2CX_start][boot2CY_start].type != 0 || bordC.coord[boot2CX_start][boot2CY_start + 1].type != 0) {
            while (boot2CY_start + 1 > bordC.cols - 1 || bordC.coord[boot2CX_start][boot2CY_start].type != 0 || bordC.coord[boot2CX_start][boot2CY_start + 1].type != 0) {
              boot2CX_start = int(random(bordC.rows));
              boot2CY_start = int(random(bordC.cols));
            }
          }
        }
        //nu de startwaarde goed is, kunnen we de coordinaten opslaan
        for (int i = 0; i < 2; i++) {
          boot2CX[i] = boot2CX_start;
          boot2CY[i] = boot2CY_start + i;
        }
        for (int i = 0; i < 2; i++) {
          bordC.coord[boot2CX[i]][boot2CY[i]].type = 3;
        }
      } else {
        if (boot2CX_start + 1 > bordC.rows - 1) {
          while (boot2CX_start + 1 > bordC.rows - 1) {
            boot2CX_start = int(random(bordC.rows));
            boot2CY_start = int(random(bordC.cols));
          }
        }
        if (bordC.coord[boot2CX_start][boot2CY_start].type != 0 || bordC.coord[boot2CX_start + 1][boot2CY_start].type != 0) {
          while (boot2CX_start + 1 > bordC.rows - 1 || bordC.coord[boot2CX_start][boot2CY_start].type != 0 || bordC.coord[boot2CX_start + 1][boot2CY_start].type != 0) {
            boot2CX_start = int(random(bordC.rows));
            boot2CY_start = int(random(bordC.cols));
          }
        }
        for (int i = 0; i < 2; i++) {
          boot2CX[i] = boot2CX_start + i;
          boot2CY[i] = boot2CY_start;
        }
        for (int i = 0; i < 2; i++) {
          bordC.coord[boot2CX[i]][boot2CY[i]].type = 3;
        }
      }

      //boot 1 wordt gemaakt: alles in naar analogie van boot5 (behalve vanaf nu wordt wel rekening gehouden met de types hokjes bij het bepalen van een goede startwaarde voor x en y
      int boot1CX_start = int(random(bordC.rows));
      int boot1CY_start = int(random(bordC.cols));
      direction = int(random(2));
      if (direction == 0) {
        //hier wordt gecontroleerd of de boot in het veld past, dit moet eerst gebeuren vooralleer er wordt gecontroleerd of de startwaarde in de weg staat van andere boten omdat je anders ArrayOutOfBoundaries-errors krijgt
        if (boot1CY_start + 1 > bordC.cols - 1) {
          while (boot1CY_start + 1 > bordC.cols - 1) {
            boot1CX_start = int(random(bordC.rows));
            boot1CY_start = int(random(bordC.cols));
          }
          //stel dat de startwaarde niet oke is (wel binnen veld), dan wordt een andere startwaarde gezocht, die nieuwe startwaarde moet natuurlijk nog steeds binnen het veld zijn
          if (bordC.coord[boot1CX_start][boot1CY_start].type != 0 || bordC.coord[boot1CX_start][boot1CY_start + 1].type != 0) {
            while (boot1CY_start + 1 > bordC.cols - 1 || bordC.coord[boot1CX_start][boot1CY_start].type != 0 || bordC.coord[boot1CX_start][boot1CY_start + 1].type != 0) {
              boot1CX_start = int(random(bordC.rows));
              boot1CY_start = int(random(bordC.cols));
            }
          }
        }
        //nu de startwaarde goed is, kunnen we de coordinaten opslaan
        for (int i = 0; i < 2; i++) {
          boot1CX[i] = boot1CX_start;
          boot1CY[i] = boot1CY_start + i;
        }
        for (int i = 0; i < 2; i++) {
          bordC.coord[boot1CX[i]][boot1CY[i]].type = 3;
        }
      } else {
        if (boot1CX_start + 1 > bordC.rows - 1) {
          while (boot1CX_start + 1 > bordC.rows - 1) {
            boot1CX_start = int(random(bordC.rows));
            boot1CY_start = int(random(bordC.cols));
          }
        }
        if (bordC.coord[boot1CX_start][boot1CY_start].type != 0 || bordC.coord[boot1CX_start + 1][boot1CY_start].type != 0) {
          while (boot1CX_start + 1 > bordC.rows - 1 || bordC.coord[boot1CX_start][boot1CY_start].type != 0 || bordC.coord[boot1CX_start + 1][boot1CY_start].type != 0) {
            boot1CX_start = int(random(bordC.rows));
            boot1CY_start = int(random(bordC.cols));
          }
        }
        for (int i = 0; i < 2; i++) {
          boot1CX[i] = boot1CX_start + i;
          boot1CY[i] = boot1CY_start;
        }
        for (int i = 0; i < 2; i++) {
          bordC.coord[boot1CX[i]][boot1CY[i]].type = 3;
        }
      }
      alleBotenCGeplaatst(); //hier wordt gecheckt of uit de while-lus mag gegaan worden of niet
      tel++;
      //Dit was om te testen of de boten goed worden gezet
      for (int i = 0; i < 10; i ++) {
        //println(bordC.coord[i][0].type + " " + bordC.coord[i][1].type + " " + bordC.coord[i][2].type + " " + bordC.coord[i][3].type + " " + bordC.coord[i][4].type + " " + bordC.coord[i][5].type + " " + bordC.coord[i][6].type + " " + bordC.coord[i][7].type + " " + bordC.coord[i][8].type + " " + bordC.coord[i][9].type);
      }
    }
    loop();
  }

  /*
  *  deze methode bekijkt of alle boten goed gezet zijn
   */
  private boolean alleBotenCGeplaatst() {
    int boothokjes = 0;
    for (int i = 0; i < bordC.rows; i++) {
      for (int j = 0; j < bordC.cols; j++) {
        if (bordC.coord[i][j].type == 3) {
          boothokjes++;
        }
      }
    }

    if (boothokjes == 16) {
      return true;
    }
    return false;
  }

  /*
  *  deze methode staat in voor de schoten die uitgevoerd worden door de speler in de classic
   */
  private void schietenDoorSpeler() {
    int rij = (mouseY - bordC.posY)/h;
    int kol = (mouseX - bordC.posX)/w;

    // Als de muis net op de rand (rechts of onder) is wordt door de bovenstaande formule de coord 10, maar dit gaat niet binnen de array van 0-9, dus wordt de 10 als 9 aangenomen
    if (kol == bordC.cols) {
      kol = (bordC.cols - 1);
    } 
    if (rij == bordC.rows) {
      rij = bordC.rows - 1;
    }

    bomVuren(rij, kol);
  }


  /*
  *  deze methode staat in voor de schoten die uitgevoerd worden door de computer in de campaign (diagonalen zoeken)
   */
  private void schietenDoorComputer() {
    int tempCol = (int(random(bordP.cols)));
    int tempRow = (int(random(bordP.rows)));

    while (bordP.coord[tempRow][tempCol].type != 0 && bordP.coord[tempRow][tempCol].type != 1 && bordP.coord[tempRow][tempCol].type != 2) {
      tempCol = (int(random(bordP.cols)));
      tempRow = (int(random(bordP.rows)));
    }

    if (bordP.coord[tempRow][tempCol].type == 0 || bordP.coord[tempRow][tempCol].type == 2) {
      bordP.coord[tempRow][tempCol].type = 6;
      schotenDoorComputer++;
    } else if (bordP.coord[tempRow][tempCol].type == 1) {
      bordP.coord[tempRow][tempCol].type = 5;
      hitDoorComputer++;
      schotenDoorComputer++;
      addPotentialT(tempRow, tempCol);
    }
  }

  /*
  *  deze methode staat in voor de schoten die uitgevoerd worden door de computer in de campaign (hunt mode)
   */
  private void hunt() {
    if (schotenDoorSpeler == (schotenDoorComputer+1)) {
      int tempX = potentialT_x[potentialT_x.length - 1]; //laad laatste x coord uit potentialTarget_x
      int tempY = potentialT_y[potentialT_y.length - 1]; //laad laatste y coord uit potentialTarget_y
      potentialT_x = shorten(potentialT_x); //verwijdert de ingeladen coor uit de potential target
      potentialT_y = shorten(potentialT_y); //verwijdert de ingeladen coor uit de potential target

      // als gevuurd wordt op een "lege cel" wordt deze een "lege geschoten cel"
      if (bordP.coord[tempY][tempX].type == 0 || bordP.coord[tempY][tempX].type == 2) {
        bordP.coord[tempY][tempX].type = 6;
        schotenDoorComputer ++;
      }
      // als gevuurd wordt op een "cel met boot" wordt deze een "geschoten cel met boot"
      else if (bordP.coord[tempY][tempX].type == 1) {
        bordP.coord[tempY][tempX].type = 5;
        hitDoorComputer++;
        schotenDoorComputer ++;
        addPotentialT(tempY, tempX);
      }
    }
  }



  // de 4 punten die gecheckt moeten worden
  private void addPotentialT(int Y, int X) {
    checkPotentialT(Y - 1, X);
    checkPotentialT(Y + 1, X);
    checkPotentialT(Y, X - 1);
    checkPotentialT(Y, X + 1);
  }

  // checkt of de potentiele target x en y binnen de range valt en dit vak nog niet is aangeklikt, indien goed, woden deze aan de respectievelijke coords lijst toegevoegd
  private void checkPotentialT(int Y, int X) {
    if ((Y <= (bordP.rows -1)) && (Y >= 0) && (X <= (bordP.cols - 1)) && (X >= 0)) {
      if ((bordP.coord[Y][X].type != 5) && (bordP.coord[Y][X].type != 6)) {

        int dubbel = 0;
        for (int x = 0; x < potentialT_x.length; x++) {
          if (X == potentialT_x[x]) {
            for (int y = 0; y < potentialT_y.length; y++) {
              if (Y == potentialT_y[y]) {
                dubbel++;
              }
            }
          }
        }
        if (dubbel == 0) {
          potentialT_x = append(potentialT_x, X); // add x coord to potentialTarget_x list
          potentialT_y = append(potentialT_y, Y); // add y coord to potentialTarget_y list
          //println(X,Y,"potentieel");
        } else {
          //println(X,Y,"dubbel");
        }
      }
    }
  }

  /*
   *  bij het hoveren van een bepaalde bom worden de juiste 
   */
  private void bomVuren(int rij, int kol) {
    /*--------------------------------------------------------------bomen hoveren--------------------------------------------------------------*/
    if (bomType == 0 && bomHover) {
      if (bordC.coord[rij][kol].type == 5 || bordC.coord[rij][kol].type == 6) {
        fill(180, 60, 60);
        rect(mouseX - w/2, mouseY - h/2, w, h);
      } else {
        fill(60);
        rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
      }
    } else if (bomType == 1 && bomHover) {
      if (bomDirection) { //horizontaal
        //als de bom binnen het bord is
        if (kol != bordC.cols - 1) {
          //als op een van de posities waar je bom wil plaatsen al een bom gezet is geweest
          if (bordC.coord[rij][kol].type == 5 || bordC.coord[rij][kol].type == 6 || bordC.coord[rij][kol + 1].type == 5 || bordC.coord[rij][kol + 1].type == 6) {
            //dan wordt een rood rechthoek getekend om te wijzen op het feit dat de boot daar niet mag staan
            fill(180, 60, 60);
            rect(mouseX - w/2, mouseY - h/2, w, h);
            rect(mouseX - w/2 + w, mouseY - h/2, w, h);
          } 
          //als op geen van de posities waar je de bom wil plaatsen al een bom gezet is geweest, dan moet ze daar hoveren
          else {
            fill(60);
            rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
            rect(bordC.posX + (kol + 1) * w, bordC.posY + rij * h, w, h);
          }
        } 
        //als de bom niet binnen het veld is moet er een rood vierkant getekend worden om aan te tonen dat je daar de bom niet kan zetten
        else {
          fill(180, 60, 60);
          rect(mouseX - w/2, mouseY - h/2, w, h);
          rect(mouseX - w/2 + w, mouseY - h/2, w, h);
        }
      } 
      //als de bom verticaal moet geplaatst worden, commentaar is analoog naar horizontaal
      else {
        if (rij != bordC.rows - 1) {
          if (bordC.coord[rij][kol].type == 5 || bordC.coord[rij][kol].type == 6 || bordC.coord[rij + 1][kol].type == 5 || bordC.coord[rij + 1][kol].type == 6) { 
            fill(180, 60, 60);
            rect(mouseX - w/2, mouseY - h/2, w, h);
            rect(mouseX - w/2, mouseY - h/2 + h, w, h);
          } else {
            fill(60);
            rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
            rect(bordC.posX + kol  * w, bordC.posY + (rij + 1) * h, w, h);
          }
        } else {
          fill(180, 60, 60);
          rect(mouseX - w/2, mouseY - h/2, w, h);
          rect(mouseX - w/2, mouseY - h/2 + h, w, h);
        }
      }
    } else if (bomType == 2 && bomHover) {
      if (bomDirection) {
        if (kol != bordC.cols - 1 && kol != 0) {
          if (bordC.coord[rij][kol].type == 5 || bordC.coord[rij][kol].type == 6 || bordC.coord[rij][kol + 1].type == 5 || bordC.coord[rij][kol + 1].type == 6 || bordC.coord[rij][kol - 1].type == 5 || bordC.coord[rij][kol - 1].type == 6) {
            fill(180, 60, 60);
            rect(mouseX - w/2 - w, mouseY - h/2, w, h);
            rect(mouseX - w/2, mouseY - h/2, w, h);
            rect(mouseX - w/2 + w, mouseY - h/2, w, h);
          } else {
            fill(60);
            rect(bordC.posX + (kol - 1) * w, bordC.posY + rij * h, w, h);
            rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
            rect(bordC.posX + (kol + 1) * w, bordC.posY + rij * h, w, h);
          }
        } else {
          fill(180, 60, 60);
          rect(mouseX - w/2 - w, mouseY - h/2, w, h);
          rect(mouseX - w/2, mouseY - h/2, w, h);
          rect(mouseX - w/2 + w, mouseY - h/2, w, h);
        }
      } else {
        if (rij != bordC.rows - 1 && rij != 0) {
          if (bordC.coord[rij][kol].type == 5 || bordC.coord[rij][kol].type == 6 || bordC.coord[rij + 1][kol].type == 5 || bordC.coord[rij + 1][kol].type == 6 || bordC.coord[rij - 1][kol].type == 5 || bordC.coord[rij - 1][kol].type == 6) { 
            fill(180, 60, 60);
            rect(mouseX - w/2, mouseY - h/2 - h, w, h);
            rect(mouseX - w/2, mouseY - h/2, w, h);
            rect(mouseX - w/2, mouseY - h/2 + h, w, h);
          } else {
            fill(60);
            rect(bordC.posX + kol * w, bordC.posY + (rij - 1) * h, w, h);
            rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
            rect(bordC.posX + kol  * w, bordC.posY + (rij + 1) * h, w, h);
          }
        } else {
          fill(180, 60, 60);
          rect(mouseX - w/2, mouseY - h/2 - h, w, h);
          rect(mouseX - w/2, mouseY - h/2, w, h);
          rect(mouseX - w/2, mouseY - h/2 + h, w, h);
        }
      }
    } else if (bomType == 3 && bomHover) {
      if (bomDirection) {
        if (rij != 0 && rij != bordC.rows - 1 && kol != 0 && kol != bordC.cols - 1) {
          fill(60);
          rect(bordC.posX + kol * w, bordC.posY + (rij - 1) * h, w, h);
          rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
          rect(bordC.posX + kol  * w, bordC.posY + (rij + 1) * h, w, h);
          rect(bordC.posX + (kol + 1) * w, bordC.posY + rij * h, w, h);
          rect(bordC.posX + (kol - 1) * w, bordC.posY + rij * h, w, h);
        } else {
          fill(180, 60, 60);
          rect(mouseX - w/2, mouseY - h/2 - h, w, h);
          rect(mouseX - w/2, mouseY - h/2, w, h);
          rect(mouseX - w/2, mouseY - h/2 + h, w, h);
          rect(mouseX - w/2 + w, mouseY - h/2, w, h);
          rect(mouseX - w/2 - w, mouseY - h/2, w, h);
        }
      } else {
        if (rij != 0 && rij != bordC.rows - 1 && kol != 0 && kol != bordC.cols - 1) {
          fill(60);
          rect(bordC.posX + (kol - 1) * w, bordC.posY + (rij - 1) * h, w, h);
          rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
          rect(bordC.posX + (kol - 1) * w, bordC.posY + (rij + 1) * h, w, h);
          rect(bordC.posX + (kol + 1) * w, bordC.posY + (rij + 1) * h, w, h);
          rect(bordC.posX + (kol + 1) * w, bordC.posY + (rij - 1) * h, w, h);
        } else {
          fill(180, 60, 60);
          rect(mouseX - w/2 - w, mouseY - h/2 - h, w, h);
          rect(mouseX - w/2, mouseY - h/2, w, h);
          rect(mouseX - w/2 + w, mouseY - h/2 + h, w, h);
          rect(mouseX - w/2 + w, mouseY - h/2 - h, w, h);
          rect(mouseX - w/2 - w, mouseY - h/2 + h, w, h);
        }
      }
    } else if (bomType == 4 && bomHover) {
      if (rij != 0 && rij != bordC.rows - 1 && kol != 0 && kol != bordC.cols - 1) {
        fill(60);
        rect(bordC.posX + (kol - 1) * w, bordC.posY + (rij - 1) * h, w, h);
        rect(bordC.posX + kol * w, bordC.posY + rij * h, w, h);
        rect(bordC.posX + (kol - 1) * w, bordC.posY + (rij + 1) * h, w, h);
        rect(bordC.posX + (kol + 1) * w, bordC.posY + (rij + 1) * h, w, h);
        rect(bordC.posX + (kol + 1) * w, bordC.posY + (rij - 1) * h, w, h);
        rect(bordC.posX + kol * w, bordC.posY + (rij - 1) * h, w, h);
        rect(bordC.posX + kol  * w, bordC.posY + (rij + 1) * h, w, h);
        rect(bordC.posX + (kol + 1) * w, bordC.posY + rij * h, w, h);
        rect(bordC.posX + (kol - 1) * w, bordC.posY + rij * h, w, h);
      } else {
        fill(180, 60, 60);
        rect(mouseX - w/2, mouseY - h/2, w, h);
        rect(mouseX - w/2 - w, mouseY - h/2 - h, w, h);           
        rect(mouseX - w/2 + w, mouseY - h/2 + h, w, h);
        rect(mouseX - w/2 + w, mouseY - h/2 - h, w, h);
        rect(mouseX - w/2 - w, mouseY - h/2 + h, w, h);
        rect(mouseX - w/2, mouseY - h/2 - h, w, h);
        rect(mouseX - w/2, mouseY - h/2 + h, w, h);
        rect(mouseX - w/2 + w, mouseY - h/2, w, h);
        rect(mouseX - w/2 - w, mouseY - h/2, w, h);
      }
    } else if (bomType == 5 && bomHover) {
      if (bomDirection) {
        for (int i = 0; i < bordC.cols; i++) {
          fill(60);
          rect(bordC.posX + w * i, bordC.posY + rij * h, w, h);
        }
      } else {
        for (int i = 0; i < bordC.rows; i++) {
          fill(60);
          rect(bordC.posX + kol * w, bordC.posY + i * h, w, h);
        }
      }
    }

    /*--------------------------------------------------------------bommen schieten--------------------------------------------------------------*/
    if (bomType == 0 && mousePressed) {
      bomHover = false;
      if (bomType == 0) {
        if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
          bordC.coord[rij][kol].type = 6;
          schotenDoorSpeler++;
        } else if (bordC.coord[rij][kol].type == 3) {
          bordC.coord[rij][kol].type = 5;
          hitDoorSpeler++;
          puntenLevel_1 += 20;
          schotenDoorSpeler++;
        }
      }
      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 1 && kol != bordC.cols - 1 && mousePressed && bomDirection) {
      //op geen van beide hokjes mag als geschoten zijn om de bom effectief te kunnen plaatsen
      //deze if mag weg indien beslist wordt dat het weg mag (zie OneNote)
      if (bordC.coord[rij][kol].type != 5 && bordC.coord[rij][kol].type != 6 && bordC.coord[rij][kol + 1].type != 5 && bordC.coord[rij][kol + 1].type != 6) {
        //hier wordt eerste hokje gecontrolleerd
        if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
          bordC.coord[rij][kol].type = 6;
          schotenDoorSpeler++;
        } else if (bordC.coord[rij][kol].type == 3) {
          bordC.coord[rij][kol].type = 5;
          puntenLevel_1 += 20;
          schotenDoorSpeler++;
          hitDoorSpeler++;
        }

        //hier wordt tweede hokje gecontrolleerd, merk op dat hier "schotenDoorSpeler++" wegvalt
        if (bordC.coord[rij][kol + 1].type == 0 || bordC.coord[rij][kol + 1].type == 4) {
          bordC.coord[rij][kol + 1].type = 6;
        } else if (bordC.coord[rij][kol + 1].type == 3) {
          bordC.coord[rij][kol + 1].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }
      }
      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 1 && rij != bordC.rows - 1 && mousePressed && !bomDirection ) {
      if (bordC.coord[rij][kol].type != 5 && bordC.coord[rij][kol].type != 6 && bordC.coord[rij + 1][kol].type != 5 && bordC.coord[rij + 1][kol].type != 6) {
        if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
          bordC.coord[rij][kol].type = 6;
          schotenDoorSpeler++;
        } else if (bordC.coord[rij][kol].type == 3) {
          bordC.coord[rij][kol].type = 5;
          puntenLevel_1 += 20;
          schotenDoorSpeler++;
          hitDoorSpeler++;
        }

        if (bordC.coord[rij + 1][kol].type == 0 || bordC.coord[rij + 1][kol].type == 4) {
          bordC.coord[rij + 1][kol].type = 6;
        } else if (bordC.coord[rij + 1][kol].type == 3) {
          bordC.coord[rij + 1][kol].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }
      }
      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 2  && kol != 0 && kol != bordC.cols -1 && mousePressed && bomDirection) {
      if (bordC.coord[rij][kol - 1].type != 5 && bordC.coord[rij][kol - 1].type != 6 && bordC.coord[rij][kol].type != 5 && bordC.coord[rij][kol].type != 6 && bordC.coord[rij][kol + 1].type != 5 && bordC.coord[rij][kol + 1].type != 6) {
        if (bordC.coord[rij][kol - 1].type == 0 || bordC.coord[rij][kol - 1].type == 4) {
          bordC.coord[rij][kol - 1].type = 6;
        } else if (bordC.coord[rij][kol - 1].type == 3) {
          bordC.coord[rij][kol - 1].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }

        if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
          bordC.coord[rij][kol].type = 6;
          schotenDoorSpeler++;
        } else if (bordC.coord[rij][kol].type == 3) {
          bordC.coord[rij][kol].type = 5;
          puntenLevel_1 += 20;
          schotenDoorSpeler++;
          hitDoorSpeler++;
        }

        //hier wordt tweede hokje gecontrolleerd, merk op dat hier "schotenDoorSpeler++" wegvalt
        if (bordC.coord[rij][kol + 1].type == 0 || bordC.coord[rij][kol + 1].type == 4) {
          bordC.coord[rij][kol + 1].type = 6;
        } else if (bordC.coord[rij][kol + 1].type == 3) {
          bordC.coord[rij][kol + 1].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }
      }
      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 2 && rij != 0 && rij != bordC.rows - 1 && mousePressed && !bomDirection) {
      if (bordC.coord[rij - 1][kol].type != 5 && bordC.coord[rij - 1][kol].type != 6 && bordC.coord[rij][kol].type != 5 && bordC.coord[rij][kol].type != 6 && bordC.coord[rij + 1][kol].type != 5 && bordC.coord[rij + 1][kol].type != 6) {
        if (bordC.coord[rij - 1][kol].type == 0 || bordC.coord[rij - 1][kol].type == 4) {
          bordC.coord[rij - 1][kol].type = 6;
        } else if (bordC.coord[rij - 1][kol].type == 3) {
          bordC.coord[rij - 1][kol].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }

        if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
          bordC.coord[rij][kol].type = 6;
          schotenDoorSpeler++;
        } else if (bordC.coord[rij][kol].type == 3) {
          bordC.coord[rij][kol].type = 5;
          puntenLevel_1 += 20;
          schotenDoorSpeler++;
          hitDoorSpeler++;
        }

        if (bordC.coord[rij + 1][kol].type == 0 || bordC.coord[rij + 1][kol].type == 4) {
          bordC.coord[rij + 1][kol].type = 6;
        } else if (bordC.coord[rij + 1][kol].type == 3) {
          bordC.coord[rij + 1][kol].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }
      }
      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 3 && kol != 0 && kol != bordC.cols - 1 && rij != 0 && rij != bordC.rows - 1 && mousePressed && bomDirection) {
      if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
        bordC.coord[rij][kol].type = 6;
        schotenDoorSpeler++;
      } else if (bordC.coord[rij][kol].type == 3) {
        bordC.coord[rij][kol].type = 5;
        schotenDoorSpeler++;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij + 1][kol].type == 0 || bordC.coord[rij + 1][kol].type == 4) {
        bordC.coord[rij + 1][kol].type = 6;
      } else if (bordC.coord[rij + 1][kol].type == 3) {
        bordC.coord[rij + 1][kol].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij - 1][kol].type == 0 || bordC.coord[rij - 1][kol].type == 4) {
        bordC.coord[rij - 1][kol].type = 6;
      } else if (bordC.coord[rij - 1][kol].type == 3) {
        bordC.coord[rij - 1][kol].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij][kol - 1].type == 0 || bordC.coord[rij][kol - 1].type == 4) {
        bordC.coord[rij][kol - 1].type = 6;
      } else if (bordC.coord[rij][kol - 1].type == 3) {
        bordC.coord[rij][kol - 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij][kol + 1].type == 0 || bordC.coord[rij][kol + 1].type == 4) {
        bordC.coord[rij][kol + 1].type = 6;
      } else if (bordC.coord[rij][kol + 1].type == 3) {
        bordC.coord[rij][kol + 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 3 && kol != 0 && kol != bordC.cols - 1 && rij != 0 && rij != bordC.rows - 1 && mousePressed && !bomDirection) {
      if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
        bordC.coord[rij][kol].type = 6;
        schotenDoorSpeler++;
      } else if (bordC.coord[rij][kol].type == 3) {
        bordC.coord[rij][kol].type = 5;
        schotenDoorSpeler++;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij - 1][kol + 1].type == 0 || bordC.coord[rij - 1][kol + 1].type == 4) {
        bordC.coord[rij - 1][kol + 1].type = 6;
      } else if (bordC.coord[rij - 1][kol + 1].type == 3) {
        bordC.coord[rij - 1][kol + 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij - 1][kol - 1].type == 0 || bordC.coord[rij - 1][kol - 1].type == 4) {
        bordC.coord[rij - 1][kol - 1].type = 6;
      } else if (bordC.coord[rij - 1][kol - 1].type == 3) {
        bordC.coord[rij - 1][kol - 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij + 1][kol - 1].type == 0 || bordC.coord[rij + 1][kol - 1].type == 4) {
        bordC.coord[rij + 1][kol - 1].type = 6;
      } else if (bordC.coord[rij + 1][kol - 1].type == 3) {
        bordC.coord[rij + 1][kol - 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij + 1][kol + 1].type == 0 || bordC.coord[rij + 1][kol + 1].type == 4) {
        bordC.coord[rij + 1][kol + 1].type = 6;
      } else if (bordC.coord[rij + 1][kol + 1].type == 3) {
        bordC.coord[rij + 1][kol + 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 4 && kol != 0 && kol != bordC.cols - 1 && rij != 0 && rij != bordC.rows - 1 && mousePressed) {
      if (bordC.coord[rij][kol].type == 0 || bordC.coord[rij][kol].type == 4) {
        bordC.coord[rij][kol].type = 6;
        schotenDoorSpeler++;
      } else if (bordC.coord[rij][kol].type == 3) {
        bordC.coord[rij][kol].type = 5;
        schotenDoorSpeler++;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij - 1][kol + 1].type == 0 || bordC.coord[rij - 1][kol + 1].type == 4) {
        bordC.coord[rij - 1][kol + 1].type = 6;
      } else if (bordC.coord[rij - 1][kol + 1].type == 3) {
        bordC.coord[rij - 1][kol + 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij - 1][kol - 1].type == 0 || bordC.coord[rij - 1][kol - 1].type == 4) {
        bordC.coord[rij - 1][kol - 1].type = 6;
      } else if (bordC.coord[rij - 1][kol - 1].type == 3) {
        bordC.coord[rij - 1][kol - 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij + 1][kol - 1].type == 0 || bordC.coord[rij + 1][kol - 1].type == 4) {
        bordC.coord[rij + 1][kol - 1].type = 6;
      } else if (bordC.coord[rij + 1][kol - 1].type == 3) {
        bordC.coord[rij + 1][kol - 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij + 1][kol + 1].type == 0 || bordC.coord[rij + 1][kol + 1].type == 4) {
        bordC.coord[rij + 1][kol + 1].type = 6;
      } else if (bordC.coord[rij + 1][kol + 1].type == 3) {
        bordC.coord[rij + 1][kol + 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }
      
      if (bordC.coord[rij + 1][kol].type == 0 || bordC.coord[rij + 1][kol].type == 4) {
        bordC.coord[rij + 1][kol].type = 6;
      } else if (bordC.coord[rij + 1][kol].type == 3) {
        bordC.coord[rij + 1][kol].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij - 1][kol].type == 0 || bordC.coord[rij - 1][kol].type == 4) {
        bordC.coord[rij - 1][kol].type = 6;
      } else if (bordC.coord[rij - 1][kol].type == 3) {
        bordC.coord[rij - 1][kol].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij][kol - 1].type == 0 || bordC.coord[rij][kol - 1].type == 4) {
        bordC.coord[rij][kol - 1].type = 6;
      } else if (bordC.coord[rij][kol - 1].type == 3) {
        bordC.coord[rij][kol - 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      if (bordC.coord[rij][kol + 1].type == 0 || bordC.coord[rij][kol + 1].type == 4) {
        bordC.coord[rij][kol + 1].type = 6;
      } else if (bordC.coord[rij][kol + 1].type == 3) {
        bordC.coord[rij][kol + 1].type = 5;
        puntenLevel_1 += 20;
        hitDoorSpeler++;
      }

      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 5 && mousePressed && bomDirection) {
      schotenDoorSpeler++;
      for (int i = 0; i < bordC.cols; i++) {
        if (bordC.coord[rij][i].type == 0 || bordC.coord[rij][i].type == 4) {
          bordC.coord[rij][i].type = 6;
        } else if (bordC.coord[rij][i].type == 3) {
          bordC.coord[rij][i].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }
      }
      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
      
    } else if (bomType == 5 && mousePressed && !bomDirection) {
      schotenDoorSpeler++;
      for (int i = 0; i < bordC.rows; i++) {
        if (bordC.coord[i][kol].type == 0 || bordC.coord[i][kol].type == 4) {
          bordC.coord[i][kol].type = 6;
        } else if (bordC.coord[i][kol].type == 3) {
          bordC.coord[i][kol].type = 5;
          puntenLevel_1 += 20;
          hitDoorSpeler++;
        }
      }
      bomHover = true; //nadat de computer geschoten heeft moet de bomHover weer true zijn
      bomType = 0; //bomtype moet terug veranderen naar het gewone indien een bom gekocht is geweest
      bomDirection = true; //om ervoor te zorgen dat altijd de eerte richting wordt gekozen bij het aanklikken in de shop
    }
  }

  /*
   *  de bom moet veranderen van richting/vorm als op spatie wordt gedrukt
   */
  private void checkKeyPressed() {
    if (keyPressed) {
      if (key == ' ') {
        bomDirection = !bomDirection;
        delay(200);
      }
    }
  }

  public void checkShopPressed() {
    if (update(1600, 360, 275, 105)) {
      if (puntenLevel_1 >= 200) {
        bomType = 1; 
        puntenLevel_1 -= 200;
        delay(200);
      }
    } else if (update(1600, 495, 275, 105)) {
      if (puntenLevel_1 >= 300) {
        bomType = 2; 
        puntenLevel_1 -= 300;
        delay(200);
      }
    } else if (update(1600, 630, 275, 105)) {
      if (puntenLevel_1 >= 500) {
        bomType = 3; 
        puntenLevel_1 -= 500;
        delay(200);
      }
    } else if (update(1600, 765, 275, 105)) {
      if (puntenLevel_1 >= 900) {
        bomType = 4; 
        puntenLevel_1 -= 900;
        delay(200);
      }
    } else if (update(1600, 900, 275, 105)) {
      if (puntenLevel_1 >= 1000) {
        bomType = 5; 
        puntenLevel_1 -= 1000;
        delay(200);
      }
    }
  }

  /*
   *  als een volledige boot geraakt is krijgt de gebruiker een bonus van 100ptn
   */
  public void bonusPunten() {
    int geraakt = 0;
    for (int i = 0; i < 5; i++) {
      if (bordC.coord[boot5CX[i]][boot5CY[i]].type == 5) {
        geraakt++;
      }
    }
    if (geraakt == 5 && !boot5Geraakt) {
      boot5Geraakt = true;
      puntenLevel_1 += 100;
    }

    geraakt = 0;
    for (int i = 0; i < 4; i++) {
      if (bordC.coord[boot4CX[i]][boot4CY[i]].type == 5) {
        geraakt++;
      }
    }
    if (geraakt == 4 && !boot4Geraakt) {
      boot4Geraakt = true;
      puntenLevel_1 += 100;
    }

    geraakt = 0;
    for (int i = 0; i < 3; i++) {
      if (bordC.coord[boot3CX[i]][boot3CY[i]].type == 5) {
        geraakt++;
      }
    }
    if (geraakt == 3 && !boot3Geraakt) {
      boot3Geraakt = true;
      puntenLevel_1 += 100;
    }

    geraakt = 0;
    for (int i = 0; i < 2; i++) {
      if (bordC.coord[boot2CX[i]][boot2CY[i]].type == 5) {
        geraakt++;
      }
    }
    if (geraakt == 2 && !boot2Geraakt) {
      boot2Geraakt = true;
      puntenLevel_1 += 100;
    }

    geraakt = 0;
    for (int i = 0; i < 2; i++) {
      if (bordC.coord[boot1CX[i]][boot1CY[i]].type == 5) {
        geraakt++;
      }
    }
    if (geraakt == 2 && !boot1Geraakt) {
      boot1Geraakt = true;
      puntenLevel_1 += 100;
    }
  }
}
