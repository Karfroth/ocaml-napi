(* open Ctypes
open Foreign
include V6
open Types

(* Working with JavaScript values and abstract operations *)
module AbstractOperations = struct
  include V6.AbstractOperations

  let napi_detach_arraybuffer = foreign "napi_detach_arraybuffer" (napi_env @-> napi_value @-> returning napi_status)
  let napi_is_detached_arraybuffer = foreign "napi_is_detached_arraybuffer" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
end *)