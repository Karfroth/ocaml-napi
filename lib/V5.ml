open Ctypes
open Foreign
include V4

(* Working with JavaScript values *)
module JSValues = struct
  include V4.JSValues

  (* Object creation functions *)
  let napi_create_date = foreign "napi_create_date" (napi_env @-> double @-> ptr(napi_env) @-> returning napi_status)

  (* Functions to convert from Node-API to C types *)
  let napi_get_date_value = foreign "napi_get_date_value" (napi_env @-> napi_value @-> ptr(double) @-> returning napi_status)
end

(* Working with JavaScript values and abstract operations *)
module AbstractOperations = struct
  include V4.AbstractOperations
  let napi_is_date = foreign "napi_is_date" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
end

module ObjectWrap = struct
  include V4.ObjectWrap 
  open V4.Properties

  (* Object wrap *)
  let napi_add_finalizer = foreign "napi_add_finalizer" (napi_env @-> napi_value @-> ptr(void) @-> napi_finalize @-> ptr(void) @-> ptr(napi_ref) @-> returning napi_status)
end