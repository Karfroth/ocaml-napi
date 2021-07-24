#include "v1.h"

extern "C" {
  CAMLprim value napi_get_version_caml(value napi_env_caml) {
    uint32_t result;
    napi_env env;
    CAMLparam1(napi_env_caml);
    env = (napi_env)CTYPES_TO_PTR(napi_env_caml);
    napi_get_version(env, &result);
    return Val_int(result);
  }
}
