#include <node_api.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <caml/mlvalues.h>
#include <caml/callback.h>
#include <caml/alloc.h>
#include <caml/memory.h>

napi_value Init (napi_env env, napi_value exports);
void initialize_example ();