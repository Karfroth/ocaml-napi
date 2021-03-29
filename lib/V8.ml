open Ctypes
open Foreign
open Util

(* Node-API memory management types *)
type napi_type_tag
let napi_type_tag: napi_type_tag structure typ = structure "napi_type_tag"
let lower = field napi_type_tag "lower" uint64_t
let upper = field napi_type_tag "upper" uint64_t;;
seal napi_type_tag;;

module Properties = struct
  let napi_object_freeze = foreign "napi_object_freeze" (napi_env @-> napi_value @-> returning napi_status)
  let napi_object_seal = foreign "napi_object_seal" (napi_env @-> napi_value @-> returning napi_status)
end

module ObjectWrap = struct
  include Util.ObjectWrap 
  open Properties

  (* Object wrap *)
  let napi_type_tag_object = foreign "napi_type_tag_object" (napi_env @-> napi_value @-> ptr(napi_type_tag) @-> returning napi_status)
  let napi_check_object_type_tag = foreign "napi_check_object_type_tag" (napi_env @-> napi_value @-> ptr(napi_type_tag) @-> ptr(bool) @-> returning napi_status)
end