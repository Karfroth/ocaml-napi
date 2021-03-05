open Ctypes
open Foreign

(* Basic Node-API data types *)
let napi_status = int64_t (* TODO: enum *)

type napi_extended_error_info
let napi_extended_error_info: napi_extended_error_info structure typ = structure "napi_extended_error_info"
let error_message = field napi_extended_error_info "error_message" string
let engine_reserved = field napi_extended_error_info "engine_reserved" (ptr void)
let engine_error_code = field napi_extended_error_info "engine_error_code" uint32_t
let error_code = field napi_extended_error_info "error_code" napi_status;;
seal napi_extended_error_info;;

type napi_env = unit ptr
let napi_env: napi_env typ = ptr void

type napi_value = unit ptr
let napi_value: napi_value typ = ptr void

(* Node-API memory management types *)
type napi_handle_scope = unit ptr
let napi_handle_scope: napi_handle_scope typ = ptr void
type napi_escapable_handle_scope = unit ptr
let napi_escapable_handle_scope: napi_escapable_handle_scope typ = ptr void
type napi_ref = unit ptr
let napi_ref: napi_ref typ = ptr void
