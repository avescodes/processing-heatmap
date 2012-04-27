// github.com/rkneufeld
// Very much WIP

int dotSize = 24;
ArrayList points = new ArrayList() ;
color[] gradientColors = { color(255), color(255,0,0), color(0,255,0) };
Heatmap hm;

void setup() {
  size(1000,1350);
  frameRate(25);
  noStroke();

  hm = new Heatmap(points);
  loadSampleData();

  background(255);
  hm.draw();
}

void draw() {
  // JS debug call
  //FuzzyDot f = new FuzzyDot(100,100,100,1);
  //f.draw();
  if(mousePressed) {
    hm.click(mouseX,mouseY);
    background(255);
    hm.draw();
  }
}

void d(int x,int y) { fill(0); ellipse(x,y,5,5); return; }

HMPoint p(int x, int y, int clicks) { return new HMPoint(x,y,clicks); }
class HMPoint {
  int x;
  int y; 
  int clicks;
  HMPoint(int x, int y, int clicks) {
    this.x = x;
    this.y = y;
    this.clicks = clicks;
  }

  void click() { clicks++; }
}

class FuzzyDot {
  int x;
  int y;
  int c;
  int diameter;
  float originalDotAlpha;
  float dotAlpha;
  int steps;
  int originalSteps;
  float intensity;

  FuzzyDot(int x, int y, int diameter, float intensity) {
    this.x = x; this.y = y; 
    if(diameter <= 2) { diameter = 2; }
    this.diameter = diameter;

    originalDotAlpha = 255 / (diameter/2);
    originalSteps = int(255 / originalDotAlpha);
    
    steps = originalSteps;
    dotAlpha = originalDotAlpha;
    
    setIntensity(intensity);
  }
  
  void draw() {
    fill(0,dotAlpha);
    for(int i = 0; i < steps; i++) {
      ellipse(x,y,diameter-2*i,diameter-2*i);
    }
  }
  
  void setIntensity(float intensity) {
    this.intensity = intensity;
    steps = int(originalSteps * intensity);
    dotAlpha = originalDotAlpha * intensity; // Rework whole draw() to make intensity less fragile
  }
}

class Heatmap {
  ArrayList points;
  int maximumClicked = -1;
  HMGradient grad = new HMGradient(gradientColors);
  
  Heatmap(ArrayList points) {
    this.points = points;

    calcMaximum();
  }
  
  void calcMaximum() {
    for(int i = 0; i < points.size(); i++ ) {
      int current = ((HMPoint) points.get(i)).clicks;
      if(maximumClicked < current) {
        maximumClicked = current;
      }
    }
    
    if(maximumClicked <= 0) { maximumClicked = 1; }
  }

  void click(int x, int y) {
    boolean handled = false;

    for(int i = 0; i < points.size(); i++) {
      HMPoint point = (HMPoint) points.get(i);
      if(point.x == x && point.y == y) { 
        point.click();
        handled = true;
        //println("Point found, handled.");
        break;
      }
    }

    if(!handled) {
      //println("Making point");
      HMPoint point = p(x,y,1);
      points.add(point); 
    }
    
    calcMaximum();
    
    
    // Info printout:
    int clicks = 0;
    for(int i = 0; i < points.size(); i++) {
      clicks += ((HMPoint)points.get(i)).clicks;
    }
    println("Points: " + points.size() + ", Clicks: " + clicks);
  }
  
  void draw() {
    for(int i = 0; i < points.size(); i++) {
      HMPoint point = (HMPoint) points.get(i);
      //println("(" + point.x + "," + point.y + ") - Max Clicked: " + maximumClicked + ",  HMPoint clicks: " + point.clicks);
      
      float intensity = float(point.clicks) / float(maximumClicked);
      //println("Intensity: " + intensity);
      
      FuzzyDot f = new FuzzyDot(point.x,point.y,dotSize,intensity);
      f.draw();
    }
    
    //JS is currently too slow to render this properly...
    convertGrayscaleToColor(color(255, 0, 0),color(0, 255, 0));
  }
  
  void convertGrayscaleToColor(color from, color to) {
    loadPixels();
    for(int i = 0; i < pixels.length; i++) {
      color currentColor = pixels[i];
      if(color(255) != currentColor) {
        float currentAlpha = red(currentColor); // Alpha not preserved, useless...
        pixels[i] = grad.gradientLerpColor(currentAlpha/255); // Take one channel and use as grayscale value

        // println("Color: " + hex(currentColor));
        // println("New Color: " + hex(pixels[i]));
      }
    } 
    updatePixels();
  }
}


class HMGradient {
  color[] colors;
  HMGradient(color[] colors) {
    this.colors = colors; 
  }
  
  color gradientLerpColor(float degree) {
    int numColors = colors.length;
    float step = 255 / numColors;
    float degreeToStep = 255 * degree;
    for(int i = 0; i < numColors - 1; i++) {
      if(degreeToStep >= i*step && degreeToStep <= (i+1)*step) {
        color from = colors[i];
        color to =   colors[i+1];
        float newDegree = (degreeToStep % step) / step;
        return lerpColor(from, to, newDegree);
      }
    }
    return lerpColor(colors[colors.length-2],colors[colors.length-1], 1); // Set actual degree
  }
}

void loadSampleData() {
 hm.click(19,458);
hm.click(545,32);
hm.click(600,260);
hm.click(329,380);
hm.click(470,571);
hm.click(474,573);
hm.click(469,573);
hm.click(482,573);
hm.click(482,573);
hm.click(482,573);
hm.click(506,574);
hm.click(506,574);
hm.click(548,704);
hm.click(548,704);
hm.click(581,766);
hm.click(581,766);
hm.click(568,767);
hm.click(555,764);
hm.click(533,786);
hm.click(528,792);
hm.click(521,797);
hm.click(511,797);
hm.click(497,797);
hm.click(482,797);
hm.click(469,793);
hm.click(461,700);
hm.click(473,546);
hm.click(445,557);
hm.click(385,562);
hm.click(146,595);
hm.click(92,634);
hm.click(135,686);
hm.click(153,716);
hm.click(191,732);
hm.click(248,733);
hm.click(262,733);
hm.click(290,710);
hm.click(297,705);
hm.click(316,692);
hm.click(418,642);
hm.click(417,666);
hm.click(271,688);
hm.click(235,693);
hm.click(435,693);
hm.click(464,693);
hm.click(503,692);
hm.click(528,691);
hm.click(575,691);
hm.click(577,698);
hm.click(562,698);
hm.click(626,46);
hm.click(613,47);
hm.click(736,291);
hm.click(935,433);
hm.click(543,76);
hm.click(608,962);
hm.click(472,131);
hm.click(360,267);
hm.click(8,132);
hm.click(308,195);
hm.click(575,921);
hm.click(324,896);
hm.click(324,896);
hm.click(540,916);
hm.click(590,923);
hm.click(413,910);
hm.click(525,53);
hm.click(789,66);
hm.click(357,362);
hm.click(790,57);
hm.click(713,273);
hm.click(515,55);
hm.click(552,42);
hm.click(540,46);
hm.click(740,273);
hm.click(612,735);
hm.click(661,952);
hm.click(215,788);
hm.click(226,727);
hm.click(226,471);
hm.click(44,456);
hm.click(135,566);
hm.click(198,903);
hm.click(527,53);
hm.click(720,458);
hm.click(40,838);
hm.click(214,329);
hm.click(329,460);
hm.click(194,449);
hm.click(168,632);
hm.click(395,454);
hm.click(152,431);
hm.click(330,342);
hm.click(552,45);
hm.click(565,45);
hm.click(558,38);
hm.click(535,47);
hm.click(370,354);
hm.click(659,27);
hm.click(225,61);
hm.click(221,61);
hm.click(209,51);
hm.click(229,54);
hm.click(231,46);
hm.click(5,105);
hm.click(896,513);
hm.click(557,391);
hm.click(520,393);
hm.click(332,398);
hm.click(420,397);
hm.click(444,390);
hm.click(579,396);
hm.click(525,393);
hm.click(542,395);
hm.click(542,395);
hm.click(560,391);
hm.click(423,389);
hm.click(543,392);
hm.click(429,379);
hm.click(449,390);
hm.click(538,387);
hm.click(520,391);
hm.click(520,392);
hm.click(533,392);
hm.click(368,388);
hm.click(537,391);
hm.click(372,399);
hm.click(531,394);
hm.click(430,400);
hm.click(546,399);
hm.click(538,390);
hm.click(308,389);
hm.click(549,389);
hm.click(430,392);
hm.click(332,387);
hm.click(524,393);
hm.click(451,398);
hm.click(555,403);
hm.click(290,373);
hm.click(540,397);
hm.click(440,401);
hm.click(529,209);
hm.click(432,385);
hm.click(453,386);
hm.click(553,390);
hm.click(436,384);
hm.click(537,51);
hm.click(744,42);
hm.click(362,1153);
hm.click(536,53);
hm.click(636,44);
hm.click(515,390);
hm.click(438,391);
hm.click(521,377);
hm.click(539,212);
hm.click(351,1182);
hm.click(539,52);
hm.click(566,32);
hm.click(828,276);
hm.click(550,43);
hm.click(903,41);
hm.click(106,1237);
hm.click(521,49);
hm.click(164,750);
hm.click(157,792);
hm.click(163,742);
hm.click(155,811);
hm.click(92,875);
hm.click(110,904);
hm.click(94,970);
hm.click(135,1002);
hm.click(121,989);
hm.click(119,987);
hm.click(118,981);
hm.click(189,669);
hm.click(400,282);
hm.click(732,879);
hm.click(741,45);
hm.click(231,337);
hm.click(531,206);
hm.click(745,3);
hm.click(546,206);
hm.click(301,340);
hm.click(534,40);
hm.click(280,596);
hm.click(776,422);
hm.click(796,422);
hm.click(837,421);
hm.click(847,421);
hm.click(857,421);
hm.click(786,422);
hm.click(169,424);
hm.click(743,931);
hm.click(930,45);
hm.click(636,208);
hm.click(489,213);
hm.click(679,113);
hm.click(806,473);
hm.click(814,941);
hm.click(343,396);
hm.click(533,387);
hm.click(524,385);
hm.click(441,382);
hm.click(527,210);
hm.click(342,1154);
hm.click(908,44);
hm.click(916,503);
hm.click(373,1164);
hm.click(74,613);
hm.click(732,297);
hm.click(523,54);
hm.click(735,218);
hm.click(552,45);
hm.click(519,38);
hm.click(134,349);
hm.click(127,304);
hm.click(127,304);
hm.click(547,404);
hm.click(548,389);
hm.click(337,393);
hm.click(421,387);
hm.click(438,380);
hm.click(513,382);
hm.click(513,383);
hm.click(459,391);
hm.click(459,390);
hm.click(459,390);
hm.click(459,390);
hm.click(516,390);
hm.click(331,384);
hm.click(401,383);
hm.click(520,385);
hm.click(525,385);
hm.click(525,385);
hm.click(357,386);
hm.click(522,394);
hm.click(542,384);
hm.click(646,44);
hm.click(545,384);
hm.click(552,384);
hm.click(552,391);
hm.click(557,396);
hm.click(557,396);
hm.click(445,395);
hm.click(552,398);
hm.click(552,398);
hm.click(438,384);
hm.click(435,402);
hm.click(531,384);
hm.click(541,204);
hm.click(987,126);
hm.click(963,377);
hm.click(985,235);
hm.click(983,567);
hm.click(828,266);
hm.click(306,318);
hm.click(391,359);
hm.click(285,362);
hm.click(548,204);
hm.click(721,51);
hm.click(537,55);
hm.click(530,205);
hm.click(560,48);
hm.click(551,47);
hm.click(252,544);
hm.click(243,518);
hm.click(529,43);
hm.click(269,337);
hm.click(397,1170);
hm.click(142,434);
hm.click(13,458);
hm.click(547,44);
hm.click(979,440);
hm.click(750,289);
hm.click(714,32);
hm.click(224,504);
hm.click(444,591);
hm.click(323,540);
hm.click(458,593);
hm.click(457,593);
hm.click(320,537);
hm.click(320,534);
hm.click(491,591);
hm.click(445,590);
hm.click(323,538);
hm.click(320,538);
hm.click(529,53);
hm.click(538,203);
hm.click(561,217);
hm.click(335,374);
hm.click(543,201);
hm.click(529,225);
hm.click(728,45);
hm.click(727,298);
hm.click(541,41);
hm.click(716,276);
hm.click(411,391);
hm.click(527,387);
hm.click(530,390);
hm.click(530,390);
hm.click(562,394);
hm.click(563,393);
hm.click(332,395);
hm.click(341,389);
hm.click(533,393);
hm.click(469,398);
hm.click(532,393);
hm.click(440,391);
hm.click(549,389);
hm.click(464,389);
hm.click(554,389);
hm.click(461,392);
hm.click(456,392);
hm.click(544,392);
hm.click(458,392);
hm.click(458,392);
hm.click(132,570);
hm.click(508,546);
hm.click(515,790);
hm.click(333,790);
hm.click(531,774);
hm.click(606,773);
hm.click(397,793);
hm.click(457,775);
hm.click(457,775);
hm.click(580,679);
hm.click(489,780);
hm.click(538,678);
hm.click(539,531);
hm.click(539,921);
hm.click(538,810);
hm.click(562,688);
hm.click(511,564);
hm.click(432,385);
hm.click(530,388);
hm.click(530,388);
hm.click(530,388);
hm.click(448,394);
hm.click(448,394);
hm.click(536,388);
hm.click(536,388);
hm.click(536,388);
hm.click(536,388);
hm.click(536,388);
hm.click(536,388);
hm.click(536,388);
hm.click(331,392);
hm.click(535,388);
hm.click(535,388);
hm.click(456,391);
hm.click(523,385);
hm.click(523,385);
hm.click(523,385);
hm.click(385,406);
hm.click(427,387);
hm.click(529,388);
hm.click(529,388);
hm.click(529,388);
hm.click(529,388);
hm.click(529,388);
hm.click(529,388);
hm.click(529,388);
hm.click(445,387);
hm.click(449,395);
hm.click(449,395);
hm.click(508,388);
hm.click(508,388);
hm.click(508,388);
hm.click(508,388);
hm.click(508,388);
hm.click(508,388);
hm.click(508,388);
hm.click(433,397);
hm.click(327,401);
hm.click(379,351);
hm.click(538,45);
hm.click(532,40);
hm.click(97,462);
hm.click(520,393);
hm.click(521,385);
hm.click(516,393);
hm.click(519,388);
hm.click(522,386);
hm.click(521,386);
hm.click(521,386);
hm.click(442,385);
hm.click(531,389);
hm.click(531,389);
hm.click(531,388);
hm.click(531,388);
hm.click(537,49);
hm.click(344,331);
hm.click(217,1315);
hm.click(536,50);
hm.click(208,349);
hm.click(352,1144);
hm.click(508,51); 
}
