open Ctypes
open Foreign

(* Node-API memory management types *)
type napi_type_tag
let napi_type_tag: napi_type_tag structure typ = structure "napi_type_tag"
let lower = field napi_type_tag "lower" uint64_t
let upper = field napi_type_tag "upper" uint64_t;;
seal napi_type_tag;;

type napi_async_cleanup_hook_handle = unit ptr
let napi_async_cleanup_hook_handle: napi_async_cleanup_hook_handle typ = ptr void