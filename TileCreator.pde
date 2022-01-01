import java.util.Arrays; 

color[] palette = new color[256];

byte[] bdata;
int[] data;
int[][] tile = new int[16][16];

int selectedPalette = 0;
int cursorx, cursory = 0;

void setup() {
  bdata = loadBytes("palette.chr");
  data = new int[bdata.length];
  for (int i = 0; i < bdata.length; i++) {
    data[i] = (bdata[i] >= 0 ? bdata[i] : (256 + bdata[i]));
  }
  for (int i = 0; i < data.length; i += 2) {
    int r,g,b;
    r = (int)(((float)(data[i+1] % 16)) * 255 / 16);
    g = (int)(((float)(data[i] / 16)) * 255 / 16);
    b = (int)(((float)(data[i] % 16)) * 255 / 16);
    palette[i/2] = color(r,g,b);
    
  }
  for (int j = 0; j < 16; j++) {
    for (int i = 0; i < 16; i++) {
      tile[j][i] = 0;
    }  
  }

  size(640,640);
  noStroke();
  fill(color(255,255,0));
  rect(32,32,18*32,32);
  rect(32,32,32,32*18);
  rect(32,32*18,18*32,32);
  rect(32*18,64,32,32*16);
  
}
void draw() {
  noStroke();
  
  for (int i = 0; i < 16; i++) {
    fill(palette[selectedPalette*16+i]);
    rect(i*32+64,0,32,32);  
  }
  for (int j = 0; j < 16; j++) {
    for (int i = 0; i < 16; i++) {
      fill(palette[selectedPalette*16+tile[j][i]]);
      rect(64+32*i,64+32*j,32,32);
    }  
  }
  fill(color(0,255,0));
  rect(76+cursorx*32,76+cursory*32,8,8);
}
void keyPressed() {
   println(key + " " + keyCode); 
   if (key == '>') {
     if (selectedPalette < 15) {
       selectedPalette++;
     }
   } else if (key == '<') {
     if (selectedPalette > 0) {
       selectedPalette--;
     }
   } else if (keyCode == 37) { // Left arrow
     if (cursorx > 0) {cursorx--;}
   } else if (keyCode == 38) { // Up arrow
     if (cursory > 0) {cursory--;}
   } else if (keyCode == 39) { // Right arrow
     if (cursorx < 15) {cursorx++;}
   } else if (keyCode == 40) { // down arrow
     if (cursory < 15) {cursory++;}
   } else if (keyCode >= 0x30 && keyCode <= 0x39) {
     tile[cursory][cursorx] = keyCode - 0x30;  
   } else if (keyCode >= 0x70 && keyCode <= 0x76) {
     tile[cursory][cursorx] = keyCode - 0x70 + 10;  
   } else if (keyCode == 10) {
     byte[] toSave = new byte[128];
     int index = 0;
     for (int j = 0; j < 16; j++) {
       for (int i = 0; i < 16; i += 2) {
         int temp = 16 * tile[j][i] + tile[j][i+1];
         toSave[index] = (byte)(temp >= 128 ? (temp - 256) : temp);
         index++;
       }            
     }
     saveBytes("outputtile.chr",toSave);
   }
   
}
