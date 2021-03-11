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

let napi_finalize = funptr (napi_env @-> ptr(void) @-> ptr(void) @-> returning void)

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

(* Working with JavaScript values *)
(* Enum types *)
let napi_valuetype = uint64_t  (* TODO: ENUM *)
let napi_typedarray_type = uint64_t  (* TODO: ENUM *)

(* Object creation functions *)
let napi_create_array = foreign "napi_create_array" (napi_env @-> ptr(napi_value) @-> returning napi_status)
let napi_create_array_with_length = foreign "napi_create_array_with_length" (napi_env @-> size_t @-> ptr(napi_value) @-> returning napi_status)
let napi_create_arraybuffer = foreign "napi_create_arraybuffer" (napi_env @-> size_t @-> ptr(ptr(void)) @-> ptr(napi_value) @-> returning napi_status)
let napi_create_buffer = foreign "napi_create_buffer" (napi_env @-> size_t @-> ptr(ptr(void)) @-> ptr(napi_value) @-> returning napi_status)
let napi_create_buffer_copy = foreign "napi_create_buffer_copy" (napi_env @-> size_t @-> ptr(void) @-> ptr(ptr(void)) @-> ptr(napi_value) @-> returning napi_status)
let napi_create_external = foreign "napi_create_external" (napi_env @-> ptr(void) @-> napi_finalize @-> ptr(void) @-> ptr(napi_value) @-> returning napi_status)
let napi_create_external_arraybuffer = foreign "napi_create_external_arraybuffer" (napi_env @-> ptr(void) @-> size_t @-> napi_finalize @-> ptr(void) @-> ptr(napi_value) @-> returning napi_status)
let napi_create_external_buffer = foreign "napi_create_external_buffer" (napi_env @-> size_t @-> ptr(void) @-> napi_finalize @-> ptr(void) @-> ptr(napi_value) @-> returning napi_status)
let napi_create_object = foreign "napi_create_object" (napi_env @-> ptr(napi_value) @-> returning napi_status)
let napi_create_symbol = foreign "napi_create_symbol" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
let napi_create_typedarray = foreign "napi_create_typedarray" (napi_env @-> napi_typedarray_type @-> size_t @-> napi_value @-> size_t @-> ptr(napi_value) @-> returning napi_status)
let napi_create_dataview = foreign "napi_create_dataview" (napi_env @-> size_t @-> napi_value @-> size_t @-> ptr(napi_value) @-> returning napi_status)

(* Functions to convert from C types to Node-API *)
let napi_create_int32 = foreign "napi_create_int32" (napi_env @-> int32_t @-> ptr(napi_value) @-> returning napi_status)
let napi_create_uint32 = foreign "napi_create_uint32" (napi_env @-> uint32_t @-> ptr(napi_value) @-> returning napi_status)
let napi_create_int64 = foreign "napi_create_int64" (napi_env @-> int64_t @-> ptr(napi_value) @-> returning napi_status)
let napi_create_double = foreign "napi_create_double" (napi_env @-> double @-> ptr(napi_value) @-> returning napi_status)
let napi_create_string_latin1 = foreign "napi_create_string_latin1" (napi_env @-> string @-> size_t @-> ptr(napi_value) @-> returning napi_status)
let napi_create_string_utf16 = foreign "napi_create_string_utf16" (napi_env @-> ptr(uint16_t) @-> size_t @-> ptr(napi_value) @-> returning napi_status) (* TODO: char16_t *)
let napi_create_string_utf8 = foreign "napi_create_string_utf8" (napi_env @-> string @-> size_t @-> ptr(napi_value) @-> returning napi_status) (* TODO: char16_t *)

(* Functions to convert from Node-API to C types *)
let napi_get_array_length = foreign "napi_get_array_length" (napi_env @-> napi_value @-> ptr(uint32_t) @-> returning napi_status)
let napi_get_arraybuffer_info = foreign "napi_get_arraybuffer_info" (napi_env @-> napi_value @-> ptr(ptr(void)) @-> ptr(size_t) @-> returning napi_status)
let napi_get_buffer_info = foreign "napi_get_buffer_info" (napi_env @-> napi_value @-> ptr(ptr(void)) @-> ptr(size_t) @-> returning napi_status)
let napi_get_prototype = foreign "napi_get_prototype" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
let napi_get_typedarray_info = foreign "napi_get_typedarray_info" (napi_env @-> napi_value @-> ptr(napi_typedarray_type) @-> ptr(size_t) @-> ptr(ptr(void)) @-> ptr(napi_value) @-> ptr(size_t) @-> returning napi_status)
let napi_get_dataview_info = foreign "napi_get_dataview_info" (napi_env @-> napi_value @-> ptr(size_t) @-> ptr(ptr(void)) @-> ptr(napi_value) @-> ptr(size_t) @-> returning napi_status)
let napi_get_value_bool = foreign "napi_get_value_bool" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
let napi_get_value_double = foreign "napi_get_value_double" (napi_env @-> napi_value @-> ptr(double) @-> returning napi_status)
let napi_get_value_external = foreign "napi_get_value_external" (napi_env @-> napi_value @-> ptr(ptr(void)) @-> returning napi_status)
let napi_get_value_int32 = foreign "napi_get_value_int32" (napi_env @-> napi_value @-> ptr(int32_t) @-> returning napi_status)
let napi_get_value_int64 = foreign "napi_get_value_int64" (napi_env @-> napi_value @-> ptr(int64_t) @-> returning napi_status)
let napi_get_value_string_latin1 = foreign "napi_get_value_string_latin1" (napi_env @-> napi_value @-> ptr(char) @-> size_t @-> ptr(size_t) @-> returning napi_status)
let napi_get_value_string_utf8 = foreign "napi_get_value_string_utf8" (napi_env @-> napi_value @-> ptr(char) @-> size_t @-> ptr(size_t) @-> returning napi_status)
let napi_get_value_string_utf16 = foreign "napi_get_value_string_utf16" (napi_env @-> napi_value @-> ptr(uint16_t) @-> size_t @-> ptr(size_t) @-> returning napi_status)
let napi_get_value_uint32 = foreign "napi_get_value_uint32" (napi_env @-> napi_value @-> ptr(uint32_t) @-> returning napi_status)

(* Functions to get global instances *)
let napi_get_boolean = foreign "napi_get_boolean" (napi_env @-> bool @-> ptr(napi_value) @-> returning napi_status)
let napi_get_global = foreign "napi_get_global" (napi_env @-> ptr(napi_value) @-> returning napi_status)
let napi_get_null = foreign "napi_get_null" (napi_env @-> ptr(napi_value) @-> returning napi_status)
let napi_get_undefined = foreign "napi_get_undefined" (napi_env @-> ptr(napi_value) @-> returning napi_status)
