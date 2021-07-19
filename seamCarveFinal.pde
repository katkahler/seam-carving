PImage img;
void setup() {
  size(1280, 720);
  img = loadImage("arch.JPG");
  img.resize(1280, 720);
  frameRate = frameRate / 2;
}
void draw() {
  clear();
  image(img, 0, 0);
  //drawEnergy(gradientEnergize(img));
  drawSeam(findSeam());
  if (img.width > 500) {
    img = carve(img, findSeam());
  }
  delay(1);
}
int[][] gradientEnergize(PImage img) {
  int[][] energy_table = new int[img.width][img.height];
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      // compute Hx and Vx
      color left = img.get(x-1, y);
      color right = img.get(x+1, y);
      color up = img.get(x, y-1);
      color down = img.get(x, y+1);
      float Hx = sq(red(left) - red(right)) + sq(green(left) - green(right)) + sq(blue(left) - blue(right));
      float Vx = sq(red(up) - red(down)) + sq(green(up) - green(down)) + sq(blue(up) - blue(down));
      energy_table[x][y] = round(Hx + Vx);
    }
  }
  return energy_table;
}
void drawEnergy(int[][] energy_table) {
  for (int x = 0; x < energy_table.length; x++) {
    for (int y = 0; y < energy_table[0].length; y++) {
      color here = color(map(energy_table[x][y], 0, 20000, 0, 255));
      set(x, y, here);
    }
  }
}
int[] findSeam() {
  //seam[0] = min(energy_table[height][])
  int[] seam = new int[img.height];
  int[][] energyTable = new int[img.width][img.height];
  // set seam[0] to that value
  // find smallest parent (looped)
  // set seam[i] to smallest parent
  energyTable = gradientEnergize(img);
  int dp[][] = new int[img.width][img.height];
  //creates a multidimensional array of the cumulative best possible values
  int topLeft;
  int topRight;
  int topCenter;
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      if (y == 0) {
        dp[x][y] = energyTable[x][y];
      } else {
        if (x == 0) {
          topLeft = 1000000000;
        } else {
          topLeft = dp[x-1][y-1];
        }
        if (x == img.width - 1) {
          topRight = 1000000000;
        } else {
          topRight = dp[x+1][y-1];
        }
        topCenter = dp[x][y-1];
        dp[x][y] = energyTable[x][y] + min(topLeft, topRight, topCenter);
      }
    }
  }
  int curr = 0;
  int smallest = 1000000000;
  for (int x = 0; x < img.width; x++) {
    if (dp[x][img.height-1] < smallest) {
      smallest = dp[x][img.height-1];
      curr = x;
    }
  }
  seam[img.height-1] = curr;
  //println(curr);
  int bestParent = 0;
  for (int y = img.height-2; y > 0; y--) {
    int smallestParentValue = 1000000000;
    for (int i = -1; i < 2; i++) {
      if (curr+i > 0 && curr+i < img.width - 1 && dp[curr+i][y-1] < smallestParentValue) {
        smallestParentValue = dp[curr+i][y-1];
        bestParent = i;
      }
    }
    curr = curr + bestParent;
    seam[y] = curr;
    //println(curr);
  }
  return(seam);
}
void drawSeam(int[] seam) {
  for (int y = 0; y < img.height; y++) {
    set(seam[y], y, color(255, 0, 0));
  }
}
PImage carve(PImage img, int[] shitWeShouldGetRidOf) {
  PImage newImage = createImage(img.width-1, img.height, RGB);
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      if (x < shitWeShouldGetRidOf[y]) {
        newImage.set(x, y, img.get(x, y));
      } else if (x > shitWeShouldGetRidOf[y]) {
        newImage.set(x-1, y, img.get(x, y));
      }
    }
  }
  return (newImage);
}
