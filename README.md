# seamCarving

There are five functions in this program: gradientEnergize, drawEnergy, findSeam, drawSeam, and carve.

gradientEnergize contains the process of generating energy values to create a 2D Array table of integers, corresponding to the image. 
  Vx = the vertical application of gradient energy. By adding together the square roots of each color value (r,g,b) at the positions both above and below the current pixel, the final Vx value is added to Hx.
  Hx = the horizontal application. The same exact thing, just getting values from the left and right pixels. 
Hx + Vx, rounded, becomes the final energy value for that pixel in the 2D array. The 2D array is completed for the entire image this way.

drawEnergy visually represents the energy table by mapping it to the grayscale/black and white.

findSeam goes through the energy table to find the least "energized" vertical path across the array, and creates a 2D array of the cumulative best possible values. It finds its best "parent" until the seam is completed.

drawSeam visually represents that seam by drawing it red.

Carve is where the magic happens. The image is then redrawn without the pixels of the seam, ultimately "carving" the image in draw.

And that's seam carving!
