open Ctypes
open Foreign
open Util

(* Node-API memory management types *)
type napi_async_cleanup_hook_handle = unit ptr
let napi_async_cleanup_hook_handle: napi_async_cleanup_hook_handle typ = ptr void
let napi_async_cleanup_hook = funptr (napi_async_cleanup_hook_handle @-> ptr(void) @-> returning void)

(* Cleanup on exit of the current Node.js instance *)
let napi_add_async_cleanup_hook = foreign "napi_add_async_cleanup_hook" (napi_env @-> napi_async_cleanup_hook @-> ptr(void) @-> ptr(napi_async_cleanup_hook_handle) @-> returning napi_status)
let napi_remove_async_cleanup_hook = foreign "napi_remove_async_cleanup_hook" (napi_async_cleanup_hook_handle @-> returning napi_status)

(* Working with JavaScript properties *)
(* Structures *)
let napi_property_attributes = uint64_t (* TODO: ENUM *)

let node_api_get_module_file_name = foreign "node_api_get_module_file_name" (napi_env @-> ptr(string) @-> returning napi_status)