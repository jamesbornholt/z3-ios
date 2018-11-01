//
//  main.c
//  z3linux
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "z3.h"

static void z3_noexit_error_handler(Z3_context ctx, Z3_error_code c) {
    fprintf(stderr, "Z3 Error: %s\n", Z3_get_error_msg(ctx, c));
}

int main(int argc, const char * argv[]) {
    if (argc < 2) {
        fprintf(stderr, "usage: main file.smt2\n");
        exit(1);
    }
    
    char *smt = NULL;
    size_t fsize, r;
    FILE *fd = fopen(argv[1], "r");
    
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
    
    Z3_context ctx = Z3_mk_context(NULL);
    Z3_set_error_handler(ctx, &z3_noexit_error_handler);
    
    struct timespec start, end;
    clock_gettime(CLOCK_REALTIME, &start);
    Z3_string z3ret = Z3_eval_smtlib2_string(ctx, smt);
    clock_gettime(CLOCK_REALTIME, &end);
    double time = ((end.tv_sec*1e9 + end.tv_nsec) - (start.tv_sec*1e9 + start.tv_nsec)) / 1e9;
    
    // copy output string to buffer before we free the context
    size_t len = strlen(z3ret);
    char *ret = calloc(sizeof(char), len + 1);
    strcpy(ret, z3ret);
    
    Z3_del_context(ctx);
    
    printf("Z3 returned [%f s] \"%s\"\n", time, ret);
    
    return 0;
}
