open Ctypes
open Foreign
include V7

(* Node-API memory management types *)
module MemoryManagement = struct
  include V7.MemoryManagement

  type napi_type_tag
  let napi_type_tag: napi_type_tag structure typ = structure "napi_type_tag"
  let lower = field napi_type_tag "lower" uint64_t
  let upper = field napi_type_tag "upper" uint64_t;;
  seal napi_type_tag;;
end

module Properties = struct
  include V7.Properties

  let napi_object_freeze = foreign "napi_object_freeze" (napi_env @-> napi_value @-> returning napi_status)
  let napi_object_seal = foreign "napi_object_seal" (napi_env @-> napi_value @-> returning napi_status)
end

module ObjectWrap = struct
  open MemoryManagement
  open Properties
  include V7.ObjectWrap 

  (* Object wrap *)
  let napi_type_tag_object = foreign "napi_type_tag_object" (napi_env @-> napi_value @-> ptr(napi_type_tag) @-> returning napi_status)
  let napi_check_object_type_tag = foreign "napi_check_object_type_tag" (napi_env @-> napi_value @-> ptr(napi_type_tag) @-> ptr(bool) @-> returning napi_status)
end