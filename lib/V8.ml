open Ctypes
open Foreign
open Util

module Properties = struct
  let napi_object_freeze = foreign "napi_object_freeze" (napi_env @-> napi_value @-> returning napi_status)
  let napi_object_seal = foreign "napi_object_seal" (napi_env @-> napi_value @-> returning napi_status)
end