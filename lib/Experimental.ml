open Ctypes
open Foreign
open Util

(* Node-API memory management types *)
type napi_type_tag
let napi_type_tag: napi_type_tag structure typ = structure "napi_type_tag"
let lower = field napi_type_tag "lower" uint64_t
let upper = field napi_type_tag "upper" uint64_t;;
seal napi_type_tag;;

type napi_async_cleanup_hook_handle = unit ptr
let napi_async_cleanup_hook_handle: napi_async_cleanup_hook_handle typ = ptr void
let napi_async_cleanup_hook = funptr (napi_async_cleanup_hook_handle @-> ptr(void) @-> returning void)

(* Cleanup on exit of the current Node.js instance *)
let napi_add_async_cleanup_hook = foreign "napi_add_async_cleanup_hook" (napi_env @-> napi_async_cleanup_hook @-> ptr(void) @-> ptr(napi_async_cleanup_hook_handle) @-> returning napi_status)
let napi_remove_async_cleanup_hook = foreign "napi_remove_async_cleanup_hook" (napi_async_cleanup_hook_handle @-> returning napi_status)

(* Working with JavaScript properties *)
(* Structures *)
let napi_property_attributes = uint64_t (* TODO: ENUM *)
