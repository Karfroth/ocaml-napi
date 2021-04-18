open Ctypes
open Foreign
include V7

module Types = struct
  include V7.Types

  type napi_async_cleanup_hook_handle = unit ptr
  let napi_async_cleanup_hook_handle: napi_async_cleanup_hook_handle typ = ptr void

  let napi_property_attributes = uint64_t (* TODO: ENUM *)
end

(* Node-API memory management types *)
module MemoryManagement = struct
  open Types

  include V7.MemoryManagement
  let napi_async_cleanup_hook = funptr (napi_async_cleanup_hook_handle @-> ptr(void) @-> returning void)

  type napi_type_tag
  let napi_type_tag: napi_type_tag structure typ = structure "napi_type_tag"
  let lower = field napi_type_tag "lower" uint64_t
  let upper = field napi_type_tag "upper" uint64_t;;
  seal napi_type_tag;;
end

module ObjectLifetime = struct
  open Types
  open MemoryManagement

  include V7.ObjectLifetime

  (* Cleanup on exit of the current Node.js instance *)
  let napi_add_async_cleanup_hook = foreign "napi_add_async_cleanup_hook" (napi_env @-> napi_async_cleanup_hook @-> ptr(void) @-> ptr_opt(napi_async_cleanup_hook_handle) @-> returning napi_status)
  let napi_remove_async_cleanup_hook = foreign "napi_remove_async_cleanup_hook" (napi_async_cleanup_hook_handle @-> returning napi_status)
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