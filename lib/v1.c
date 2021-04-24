#include <inttypes.h>

#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <node_api.h>

#define CTYPES_FROM_PTR(P) caml_copy_int64((intptr_t)P)
#define CTYPES_TO_PTR(I64) ((void *)Int64_val(I64))
#define CTYPES_TO_NULL_PTR(I64) (I64 != 0xc00) ? NULL : CTYPES_TO_PTR(I64)

CAMLprim value
napi_get_cb_info_native(value env,
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
  napi_value* thisArg_ = CTYPES_TO_NULL_PTR(thisArg);
  void** data_ = CTYPES_TO_NULL_PTR(data);

  napi_status res = napi_get_cb_info(env_, cbinfo_, argc_, argv_, thisArg_, data_);
  CAMLreturn (Val_int(res));
}

CAMLprim value napi_get_cb_info_bytecode(value* args) {
    return napi_get_cb_info_native(args[0], args[1], args[2], args[3], args[4], args[5]);
}