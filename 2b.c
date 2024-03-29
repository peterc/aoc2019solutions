#include <stdio.h>
#include <string.h>

#define ARRAY_SIZE(foo) (sizeof(foo)/sizeof(foo[0]))

int program[] = {1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,9,27,1,5,27,31,1,9,31,35,1,35,10,39,2,13,39,43,1,43,9,47,1,47,9,51,1,6,51,55,1,13,55,59,1,59,13,63,1,13,63,67,1,6,67,71,1,71,13,75,2,10,75,79,1,13,79,83,1,83,10,87,2,9,87,91,1,6,91,95,1,9,95,99,2,99,10,103,1,103,5,107,2,6,107,111,1,111,6,115,1,9,115,119,1,9,119,123,2,10,123,127,1,127,5,131,2,6,131,135,1,135,5,139,1,9,139,143,2,143,13,147,1,9,147,151,1,151,2,155,1,9,155,0,99,2,0,14,0};
int mem[ARRAY_SIZE(program)] = {};

int main() {
  int i = 0, op, i1, i2, out;

  for (int noun = 0; noun < 100; noun++) {
    for (int verb = 0; verb < 100; verb++) {
      // Take a copy of the program and place it into 'mem'ory..
      memcpy(mem, program, sizeof(program));

      mem[1] = noun;
      mem[2] = verb;

      printf("RUN %d %d %d\n", mem[0], mem[1], mem[2]);

      i = 0;

      while(1) {
        op = mem[i], i1 = mem[i+1], i2 = mem[i+2], out = mem[i+3];

        printf("RUNNING %d %d %d %d\n", op, i1, i2, out);

        if (op == 1) {
          mem[out] = mem[i1] + mem[i2];
        } else if (op == 2) {
          mem[out] = mem[i1] * mem[i2];
        } else {
          break;
        }
        i += 4;
      }

      if (mem[0] == 19690720) {
        printf("ENDED RUN (%d,%d) WITH %d\n", noun, verb, mem[0]);
        return 0;
      }
    }
  }

  return 1;
}