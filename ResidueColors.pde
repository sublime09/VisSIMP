public class ResidueColors {
  final int RED = 0x7FFF0000;
  final int BLUE = 0x7F00FF00;
  final int GREEN = 0x7F0000FF;
  final int BLACK = 0x7F000000;
  
  public int[] residueColors;
  
  public ResidueColors(SimData sim) {
    residueColors = new int[sim.numResidues];
    
    for(int i = 0; i < residueColors.length; i++) {
      if(i == 0 || i == 2 || i == 6 || i == 10 || i == 21 || i == 22) {
        residueColors[i] = RED;
      } else if(i == 4 || i == 15 || i == 27) {
        residueColors[i] = BLUE;
      } else if(i == 5 || i == 7 || i == 9 || i == 12 || i == 13 || i == 14 || i == 25 || i == 26) {
        residueColors[i] = GREEN;
      } else {
        residueColors[i] = BLACK;
      }
    }
  }
}