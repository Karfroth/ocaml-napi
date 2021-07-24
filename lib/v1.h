extern "C" {
  #include <node_api.h>
  #include <caml/mlvalues.h>
  #include <caml/alloc.h>
  #include <caml/memory.h>
  #include <caml/callback.h>
  #include <caml/custom.h>

  #define CTYPES_FROM_PTR(P) caml_copy_int64((intptr_t)P)
  #define CTYPES_TO_PTR(I64) ((void *)Int64_val(I64))
  #define CTYPES_PTR_PLUS(I64, I) caml_copy_int64(Int64_val(I64) + I)
}