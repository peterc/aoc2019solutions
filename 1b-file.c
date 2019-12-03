#include <stdio.h>
#include <math.h>

int fuelForMass(int mass) {
  int fuel = 0, fi;

  do {
    fi = (int) floor((float) mass / 3.0) - 2;
    mass = fi;
    fuel += fi;
  } while (fi >= 9);

  return fuel;
}

int main() {
  FILE *fp;
  int mass;
  char buff[1024];

  fp = fopen("1input.txt", "r");

  if (fp == NULL) {
    printf("Yeah.. can't open that file\n");
    return 1;
  }

  int totalFuel = 0;

  while (fscanf(fp, "%d", &mass) != EOF)
    totalFuel += fuelForMass(mass);

  fclose(fp);

  printf("%d\n", totalFuel);  

  return 0;
}