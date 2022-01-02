import java.util.Arrays; 

color[] palette = new color[256];

String input = "city.chr";
byte[] filedata;

byte[] bdata;
int[] data;
int size = 16;
int dims = size+4;
int pixLength = 640/dims;
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

  if (!input.equals("")) {
    filedata = loadBytes(input); 
    size = (int)sqrt(filedata.length * 2); 
    tile = new int[size][size];
    dims = size+4;
    pixLength = 640/dims;
    int i = 0;
    int j = 0; 
    for (int index = 0; index < filedata.length; index++) {
        int temp = filedata[index] + (filedata[index] >= 0 ? 0 : 256);
        tile[j][i] = (temp / 16);
        tile[j][i+1] = (temp % 16);
        i += 2;
        if (i == size) {
          j++;
          i = 0;
        }
    }
  }

  size(640,640);
  drawRect(2,2,size+2,1,color(255,255,0));
  drawRect(2,2,1,size+2,color(255,255,0));
  drawRect(2,3+size,size+2,1,color(255,255,0));
  drawRect(3+size,2,1,size+2,color(255,255,0));
  
}
void draw() {
  noStroke();
  
  for (int i = 0; i < 16; i++) {
    drawRect(i*size/16+3,0,size/16,1,palette[selectedPalette*16+i]); 
  }
  for (int j = 0; j < size; j++) {
    for (int i = 0; i < size; i++) {
      drawSquare(i+3,j+3,palette[selectedPalette*16+ tile[j][i]]);
    }  
  }
  fill(color(0,255,0));
  rect(pixLength*(cursorx+3) + pixLength/2 - pixLength/16,pixLength*(cursory+3) + pixLength/2 - pixLength/16,pixLength/8,pixLength/8);
}

void drawSquare(int x, int y, color c) {
 noStroke();
 fill(c);
 rect(pixLength*x,pixLength*y,pixLength,pixLength);
}
void drawRect(int x, int y, int xl, int yl, color c) {
  for (int j = 0; j < yl; j++) {
    for (int i = 0; i < xl; i++) {
      drawSquare(x+i,y+j,c); 
    }
  }
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
     if (cursorx < size - 1) {cursorx++;}
   } else if (keyCode == 40) { // down arrow
     if (cursory < size - 1) {cursory++;}
   } else if (keyCode >= 0x30 && keyCode <= 0x39) {
     tile[cursory][cursorx] = keyCode - 0x30;  
   } else if (keyCode >= 0x70 && keyCode <= 0x76) {
     tile[cursory][cursorx] = keyCode - 0x70 + 10;  
   } else if (keyCode == 10) {
     byte[] toSave = new byte[size*size/2];
     int index = 0;
     for (int j = 0; j < size; j++) {
       for (int i = 0; i < size; i += 2) {
         int temp = 16 * tile[j][i] + tile[j][i+1];
         toSave[index] = (byte)(temp >= 128 ? (temp - 256) : temp);
         index++;
       }            
     }
     saveBytes("outputtile.chr",toSave);
   }
   
}
