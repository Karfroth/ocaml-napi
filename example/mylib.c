#include "mylib.h"
#include <inttypes.h>

#define CTYPES_FROM_PTR(P) caml_copy_int64((intptr_t)P)
#define CTYPES_TO_PTR(I64) ((void *)Int64_val(I64))
#define CTYPES_PTR_PLUS(I64, I) caml_copy_int64(Int64_val(I64) + I)

void initialize_example () {
   char *str = NULL;
   caml_startup(&str);
}

napi_value Init (napi_env env, napi_value exports) {
   initialize_example();
   static const value* closure = NULL;
   if (closure == NULL) {
      closure = caml_named_value("lib_init");
   }

   value envPtr = CTYPES_FROM_PTR(env);
   value exportsPtr = CTYPES_FROM_PTR(exports);
   value res = caml_callback2_exn(*closure, envPtr, exportsPtr);
   return exports;
}

NAPI_MODULE(NODE_GYP_MODULE_NAME, Init);