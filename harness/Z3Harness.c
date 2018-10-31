//
//  Z3Harness.c
//  z3
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#include "Z3Harness.h"

static void loadSymbol(char *sym, void *from, void ** to) {
    fprintf(stderr, "loading %s to %p\n", sym, to);
    *to = dlsym(from, sym);
    if (*to == NULL) {
        char *err = dlerror();
        fprintf(stderr, "error loading %s: %s\n", sym, err);
    }
}

void *loadZ3Dylib(const char *path) {
    fprintf(stderr, "loading Z3 from %s\n", path);
    z3Lib = dlopen(path, RTLD_NOW);
    if (z3Lib == NULL) {
        char *err = dlerror();
        fprintf(stderr, "error loading z3 dylib: %s\n", err);
    } else {
        fprintf(stderr, "loaded z3 dylib to %p\n", z3Lib);
        loadSymbol("Z3_mk_context", z3Lib, (void**) &z3MkContext);
        loadSymbol("Z3_parse_smtlib2_file", z3Lib, (void**) &z3ParseSMT2File);
        loadSymbol("Z3_eval_smtlib2_string", z3Lib, (void**) &z3EvalSMT2String);
    }
    return z3Lib;
}

const char *runZ3String(const char *str) {
    if (z3MkContext == NULL) {
        fprintf(stderr, "can't run z3 string\n");
        return "";
    }
    Z3_context ctx = z3MkContext(NULL);
    return z3EvalSMT2String(ctx, str);
}
