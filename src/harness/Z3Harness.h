//
//  Z3Harness.h
//  z3
//
//  Created by James Bornholt on 10/30/18.
//  Copyright © 2018 James Bornholt. All rights reserved.
//

#ifndef Z3Harness_h
#define Z3Harness_h

#include <stdio.h>
#include <dlfcn.h>

#include "z3.h"

static void *z3Lib = NULL;

static Z3_context (*z3MkContext)(Z3_config c) = NULL;
static Z3_ast (*z3ParseSMT2File)(Z3_context ctx, Z3_string file, unsigned num_sorts, Z3_symbol const sort_names[], Z3_sort const sorts[], unsigned num_decls, Z3_symbol const decl_names[], Z3_func_decl decls[]) = NULL;
static Z3_string (*z3EvalSMT2String)(Z3_context ctx, Z3_string str) = NULL;

void *loadZ3Dylib(const char *path);
const char *runZ3String(const char *str);

#endif /* Z3Harness_h */
