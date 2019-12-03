//
// THIS ONE IS NOT DONE -- WORK IN PROGRESS
//


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char input[] = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83";

//enum Direction { U = 0, D, L, R };
//struct Magnitude {
//};

int main() {
  int pos = 0;
  int mpos = 0;
  char direction;
  char s_magnitude[4];
  int magnitude;

  while (pos < strlen(input)) {
    direction = input[pos++];

    bzero(s_magnitude, sizeof(s_magnitude));
    mpos = 0;
    while (input[pos] >= '0' && input[pos] <= '9') {
        s_magnitude[mpos++] = input[pos++];
    }

    magnitude = atoi(s_magnitude);

    printf("%c\n", direction);
    printf("%d\n", magnitude);
    printf("-----\n");
    
    if (input[pos++] == '\n')
      break;
  }

  printf("WIRE TWO NOW\n");

  while (pos < strlen(input)) {
    direction = input[pos++];

    bzero(s_magnitude, sizeof(s_magnitude));
    mpos = 0;
    while (input[pos] >= '0' && input[pos] <= '9') {
        s_magnitude[mpos++] = input[pos++];
    }

    magnitude = atoi(s_magnitude);

    printf("%c\n", direction);
    printf("%d\n", magnitude);
    printf("-----\n");
    
    if (input[pos++] == '\n')
      break;
  }

  return 0;
}

