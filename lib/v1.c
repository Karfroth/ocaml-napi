#include <inttypes.h>

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <node_api.h>

#define CTYPES_FROM_PTR(P) caml_copy_nativeint((intptr_t)P)
#define CTYPES_TO_PTR(I) ((void *)Nativeint_val(I))
#define CTYPES_ADDR_OF_FATPTR(P) CTYPES_TO_PTR(Field(P, 1))

#if SIZE_MAX == UINT32_MAX
#define TO_SIZE_T(t) ((uint32_t)Int32_val(t))
#elif SIZE_MAX == UINT64_MAX
#define TO_SIZE_T(t) ((uint64_t)Int64_val(t))
#else
# error "Unknown size_t"
#endif

CAMLprim value napi_get_cb_info_native(value env,
                                      value cbinfo,
                                      value argc,
                                      value argv,
                                      value thisArg,
                                      value data)
{
  CAMLparam5 (env, cbinfo, argc, argv, thisArg);
  CAMLxparam1 (data);
  napi_env env_ = CTYPES_TO_PTR(env);
  napi_callback_info cbinfo_ = CTYPES_TO_PTR(cbinfo);
  size_t* argc_ = CTYPES_TO_PTR(argc);
  napi_value* argv_ = CTYPES_TO_PTR(argv);
  napi_value* thisArg_ = CTYPES_TO_PTR(thisArg);
  void** data_ = CTYPES_TO_PTR(data);

  napi_status res = napi_get_cb_info(env_, cbinfo_, argc_, argv_, thisArg_, data_);
  CAMLreturn (Val_int(res));
}

CAMLprim value napi_get_cb_info_bytecode(value* args) {
    return napi_get_cb_info_native(args[0], args[1], args[2], args[3], args[4], args[5]);
}

CAMLprim value napi_create_string_utf8_native(value env,
                                            value str,
                                            value result)
{
  CAMLparam3 (env, str, result);

  napi_env env_ = CTYPES_TO_PTR(env);
  char* str_ = String_val(str);
  napi_value* result_ = CTYPES_TO_PTR(result);

  napi_status res = napi_create_string_utf8(env_, str_, NAPI_AUTO_LENGTH, result_);
  CAMLreturn (Val_int(res));
}
