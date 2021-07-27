#include "v1.h"
#include <iostream>

extern "C" {
  CAMLprim value napi_get_version_caml(value napi_env_caml) {
    uint32_t result = NULL;
    napi_env env;
    CAMLparam1(napi_env_caml);
    CAMLlocal1(res);
    env = (napi_env)CTYPES_TO_PTR(napi_env_caml);
    napi_status status = napi_get_version(env, &result);
    res = caml_alloc(2, 0);
    Field(res, 0) = ctypes_copy_size_t(status);
    if (status == napi_ok) {
      Field(res, 1) = caml_alloc_some(integers_copy_uint32(result));
    } else {
      Field(res, 1) = Val_none;
    }
    CAMLreturn(res);
  }
}
