open Ctypes
open Foreign
open Util

(* Working with JavaScript values *)
(* Object creation functions *)
let napi_create_date = foreign "napi_create_date" (napi_env @-> double @-> ptr(napi_env) @-> returning napi_status)

(* Functions to convert from Node-API to C types *)
let napi_get_date_value = foreign "napi_get_date_value" (napi_env @-> napi_value @-> ptr(double) @-> returning napi_status)