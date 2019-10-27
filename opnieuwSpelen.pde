/*----------------------------In deze tab staan heel wat methode met min of meer dezelfde code/manier van werken maar met een anderen boodschap-------------------*/
public void opnieuwSpelen(int pagina) {
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
  text("Wil je opnieuw spelen?", x+250, y+100);
  
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
    screenPage = pagina;
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
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
  } else if(update(x+u-a-c, y+b, c, d)) {
    delay(200);
    screenPage = 0;
    classicAlGespeeld = false;
    campaignAlGespeeld = false;
    shopAllowedDraw = false;
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
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
  }
}

public void vragenNextLevel(int pagina) {
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
  text("Wil je verder spelen?", x+250, y+100);
  
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
  if (update(x+a, y+b, c, d)) {
    if (!level_0_AlGespeeld) {
      level_0_AlGespeeld = true;
      level_1_AlGespeeld = false;
      puntenLevel_1 += puntenLevel_0;
    } else if (!level_1_AlGespeeld) {
      level_1_AlGespeeld = true;
      level_2_AlGespeeld = false;
      puntenLevel_2 += puntenLevel_1;
    } else if (!level_2_AlGespeeld) {
      level_2_AlGespeeld = true;
      level_3_AlGespeeld = false;
      puntenLevel_3 += puntenLevel_2;
    } else if (!level_3_AlGespeeld) {
      level_3_AlGespeeld = true;
      level_4_AlGespeeld = false;
      puntenLevel_4 += puntenLevel_3;
    }
  } else if (update(x+u-a-c, y+b, c, d)) {
    screenPage = pagina;
    campaignAlGespeeld = false;
    shopAllowedDraw = false;
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
    delay(200);
  }
}

public void felicitatiesCampaignGewonnen(int pagina) {
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
  text("Ongelooflijk! U heeft de computer verslaan!", x + 250, y + 65);
  text("Wil je opnieuw spelen?", x+250, y+100);
  
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
    screenPage = pagina;
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
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
  } else if(update(x+u-a-c, y+b, c, d)) {
    delay(200);
    screenPage = 0;
    classicAlGespeeld = false;
    campaignAlGespeeld = false;
    shopAllowedDraw = false;
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
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
  }
}

public void opnieuwSpelenCampaign(int pagina) {
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
  text("Helaas! De computer heeft je verslaan!", x + 250, y + 65);
  text("Wil je opnieuw spelen?", x+250, y+100);
  
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
    screenPage = pagina;
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
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
  } else if(update(x+u-a-c, y+b, c, d)) {
    delay(200);
    screenPage = 0;
    classicAlGespeeld = false;
    campaignAlGespeeld = false;
    shopAllowedDraw = false;
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
    puntenCampaign = 0;
    puntenLevel_0 = 0;
    puntenLevel_1 = 0; 
    puntenLevel_2 = 0;
    puntenLevel_3 = 0;
    puntenLevel_4 = 0;
  }
}
