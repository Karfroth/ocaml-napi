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

(* Error Handling *)
let napi_get_last_error_info = foreign "napi_get_last_error_info" (napi_env @-> ptr(ptr(napi_extended_error_info)) @-> returning napi_status)

let napi_throw = foreign "napi_throw" (napi_env @-> napi_value @-> returning napi_status)
let napi_throw_error = foreign "napi_throw_error" (napi_env @-> string @-> string @-> returning napi_status)
let napi_throw_type_error = foreign "napi_throw_type_error" (napi_env @-> string @-> string @-> returning napi_status)
let napi_throw_range_error = foreign "napi_throw_range_error" (napi_env @-> string @-> string @-> returning napi_status)

let napi_is_error = foreign "napi_is_error" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
let napi_create_error = foreign "napi_create_error" (napi_env @-> napi_value @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
let napi_create_type_error = foreign "napi_create_type_error" (napi_env @-> napi_value @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
let napi_create_range_error = foreign "napi_create_range_error"  (napi_env @-> napi_value @-> napi_value @-> ptr(napi_value) @-> returning napi_status)

let napi_get_and_clear_last_exception = foreign "napi_get_and_clear_last_exception" (napi_env @-> ptr(napi_value) @-> returning napi_status)
let napi_is_exception_pending = foreign "napi_is_exception_pending" (napi_env @-> ptr(bool) @-> returning napi_status)

(* Fatal errors *)
let napi_fatal_error = foreign "napi_fatal_error" (string @-> size_t @-> string @-> size_t @-> returning void)

(* Object lifetime management *)
(* Making handle lifespan shorter than that of the native method *)
let napi_open_handle_scope = foreign "napi_open_handle_scope" (napi_env @-> ptr(napi_handle_scope) @-> returning napi_status)
let napi_close_handle_scope = foreign "napi_close_handle_scope" (napi_env @-> napi_handle_scope @-> returning napi_status)

let napi_open_escapable_handle_scope = foreign "napi_open_escapable_handle_scope" (napi_env @-> ptr(napi_handle_scope) @-> returning napi_status)
let napi_close_escapable_handle_scope = foreign "napi_close_escapable_handle_scope" (napi_env @-> napi_handle_scope @-> returning napi_status)

let napi_escape_handle = foreign "napi_escape_handle" (napi_env @-> napi_escapable_handle_scope @-> napi_value @-> ptr(napi_value) @-> returning napi_status)

(* References to objects with a lifespan longer than that of the native method *)
let napi_create_reference = foreign "napi_create_reference" (napi_env @-> napi_value @-> uint32_t @-> ptr(napi_ref) @-> returning napi_status)
let napi_delete_reference = foreign "napi_delete_reference" (napi_env @-> napi_ref @-> returning napi_status)
let napi_reference_ref = foreign "napi_reference_ref" (napi_env @-> napi_ref @-> ptr(uint32_t) @-> returning napi_status)
let napi_reference_unref = foreign "napi_reference_unref" (napi_env @-> napi_ref @-> ptr(uint32_t) @-> returning napi_status)
let napi_get_reference_value = foreign "napi_get_reference_value" (napi_env @-> napi_ref @-> ptr(napi_value) @-> returning napi_status)
