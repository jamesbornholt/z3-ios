//
//  main.c
//  z3linux
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "Z3Harness.h"

void loadZ3(const char *path) {
    loadZ3Dylib(path);
}

int main(int argc, const char * argv[]) {
    if (argc < 3) {
        fprintf(stderr, "usage: z3harness libz3.dylib file.smt2\n");
        return 1;
    }
    
    loadZ3Dylib(argv[1]);
    
    char *smt = NULL;
    size_t fsize, r;
    FILE *fd = fopen(argv[2], "r");
    
    if (!fd) {
        fprintf(stderr, "error opening smt file\n");
        return 2;
    }
    fseek(fd, 0, SEEK_END);
    fsize = ftell(fd);
    rewind(fd);
    
    smt = (char*) malloc(sizeof(char) * (fsize + 1));
    r = fread(smt, sizeof(char), fsize, fd);
    smt[fsize] = 0;
    
    struct timespec start, end;
    clock_gettime(CLOCK_REALTIME, &start);
    const char* ret = runZ3String(smt);
    clock_gettime(CLOCK_REALTIME, &end);
    double time = ((end.tv_sec*1e9 + end.tv_nsec) - (start.tv_sec*1e9 + start.tv_nsec)) / 1e9;
    printf("Z3 returned [%f s] \"%s\"\n", time, ret);
    
    return 0;
}
