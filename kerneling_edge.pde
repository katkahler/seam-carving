PImage img;

void setup() {
  size(1000, 700);
  img = loadImage("arch.JPG");
  img.resize(1000, 700);
  image(img, 0, 0);
}

color apply(int _x, int _y) {
  color left = img.get(_x-1, _y);
  color right = img.get(_x+1, _y);
  color up = img.get(_x, _y-1);
  color down = img.get(_x, _y+1);
  
  int rx = round(red(left)-red(right));
  rx = rx * rx;
  int ry = round(red(up)-red(down));
  ry = ry * ry;
  
  int gx = round(green(left)-green(right));
  gx = gx * gx;
  int gy = round(green(up)-green(down));
  gy = gy * gy;
  
  int bx = round(blue(left)-blue(right));
  bx = bx * bx;
  int by = round(blue(up)-blue(down));
  by = by * by;
  
  int hx = rx + gx + bx;
  int vx = ry + gy + by;
  
  return hx + vx;
}

void draw() {
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      set(x, y, color(map(apply(x, y), 0, 20000, 0, 255)));
    }
  }
}
