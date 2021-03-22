open Ctypes
open Foreign
open Util

(* Working with JavaScript values and abstract operations *)
let napi_detach_arraybuffer = foreign "napi_detach_arraybuffer" (napi_env @-> napi_value @-> returning napi_status)
let napi_is_detached_arraybuffer = foreign "napi_is_detached_arraybuffer" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
