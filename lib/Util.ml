open Ctypes
open Foreign

module Types = struct
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

  type napi_callback_info = unit ptr
  let napi_callback_info: napi_callback_info typ = ptr void
  let napi_callback = funptr (napi_env @-> napi_callback_info @-> returning napi_value)

  let napi_async_execute_callback = funptr (napi_env @-> ptr(void) @-> returning void)
  let napi_async_complete_callback = funptr (napi_env @-> napi_status @-> ptr(void) @-> returning void)

  type napi_async_work = unit ptr
  let napi_async_work: napi_async_work typ = ptr void
  type napi_async_context = unit ptr
  let napi_async_context: napi_async_context typ = ptr void
  type napi_callback_scope = unit ptr
  let napi_callback_scope: napi_callback_scope typ = ptr void

  module NAPINodeVersion = struct
    type napi_node_version
    let napi_node_version: napi_node_version structure typ = structure "napi_node_version"
    
    type t = napi_node_version

    let major = field napi_node_version "major" uint32_t
    let minor = field napi_node_version "minor" uint32_t
    let patch = field napi_node_version "patch" uint32_t
    let release = field napi_node_version "release" string;;
    seal napi_node_version;;
  end
  type napi_node_version = NAPINodeVersion.napi_node_version
  let napi_node_version = NAPINodeVersion.napi_node_version

  type napi_deferred = unit ptr
  let napi_deferred: napi_deferred typ = ptr void
end

include Types

module ErrorHandling = struct
  open Types

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
end

module ObjectLifetime = struct
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
end

module JSValues = struct
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
end

module AbstractOperations = struct
  open JSValues

  (* Working with JavaScript values and abstract operations *)
  let napi_coerce_to_bool = foreign "napi_coerce_to_bool" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
  let napi_coerce_to_number = foreign "napi_coerce_to_number" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
  let napi_coerce_to_object = foreign "napi_coerce_to_object" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
  let napi_coerce_to_string = foreign "napi_coerce_to_string" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
  let napi_typeof = foreign "napi_typeof" (napi_env @-> napi_value @-> ptr(napi_valuetype) @-> returning napi_status)
  let napi_instanceof = foreign "napi_instanceof" (napi_env @-> napi_value @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_is_array = foreign "napi_is_array" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_is_arraybuffer = foreign "napi_is_arraybuffer" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_is_buffer = foreign "napi_is_buffer" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_is_error = foreign "napi_is_error" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_is_typedarray = foreign "napi_is_typedarray" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_is_dataview = foreign "napi_is_dataview" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_strict_equals = foreign "napi_strict_equals" (napi_env @-> napi_value @-> napi_value @-> ptr(bool) @-> returning napi_status)
end

(* Working with JavaScript properties *)
(* Structures *)
module Properties = struct
  let napi_property_attributes = uint64_t (* TODO: ENUM *)
  type napi_property_descriptor
  let napi_property_descriptor: napi_property_descriptor structure typ = structure "napi_property_descriptor"
  let utf8name = field napi_property_descriptor "utf8name" string
  let name = field napi_property_descriptor "name" napi_value
  let _method = field napi_property_descriptor "method" napi_callback
  let getter = field napi_property_descriptor "getter" napi_callback
  let setter = field napi_property_descriptor "setter" napi_callback
  let value = field napi_property_descriptor "value" napi_value
  let attributes = field napi_property_descriptor "attributes" napi_property_attributes
  let data = field napi_property_descriptor "data" (ptr void);;
  seal napi_property_descriptor;;

  let napi_get_property_names = foreign "napi_get_property_names" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
  let napi_set_property = foreign "napi_set_property" (napi_env @-> napi_value @-> napi_value @-> napi_value @-> returning napi_status)
  let napi_get_property = foreign "napi_get_property" (napi_env @-> napi_value @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
  let napi_has_property = foreign "napi_has_property" (napi_env @-> napi_value @-> napi_value @-> ptr(bool) @-> returning napi_status);;
  let napi_delete_property = foreign "napi_delete_property" (napi_env @-> napi_value @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_has_own_property = foreign "napi_has_own_property" (napi_env @-> napi_value @-> napi_value @-> ptr(bool) @-> returning napi_status)
  let napi_set_named_property = foreign "napi_set_named_property" (napi_env @-> napi_value @-> string @-> napi_value @-> returning napi_status)
  let napi_get_named_property = foreign "napi_get_named_property" (napi_env @-> napi_value @-> string @-> ptr(napi_value) @-> returning napi_status)
  let napi_has_named_property = foreign "napi_has_named_property" (napi_env @-> napi_value @-> string @-> ptr(bool) @-> returning napi_status)
  let napi_set_element = foreign "napi_set_element" (napi_env @-> napi_value @-> uint32_t @-> napi_value @-> returning napi_status)
  let napi_get_element = foreign "napi_get_element" (napi_env @-> napi_value @-> uint32_t @-> ptr(napi_value) @-> returning napi_status)
  let napi_has_element = foreign "napi_has_element" (napi_env @-> napi_value @-> uint32_t @-> ptr(bool) @-> returning napi_status)
  let napi_delete_element = foreign "napi_delete_element" (napi_env @-> napi_value @-> uint32_t @-> ptr(bool) @-> returning napi_status)
  let napi_define_properties = foreign "napi_define_properties" (napi_env @-> napi_value @-> size_t @-> ptr(napi_property_descriptor) @-> returning napi_status)
end

module Functions = struct
  (* Working with JavaScript functions *)
  let napi_call_function = foreign "napi_call_function" (napi_env @-> napi_value @-> napi_value @-> size_t @-> ptr(napi_value) @-> ptr(napi_value) @-> returning napi_status)
  let napi_create_function = foreign "napi_create_function" (napi_env @-> string @-> size_t @-> napi_callback @-> ptr(void) @-> ptr(napi_value) @-> returning napi_status)
  let napi_get_cb_info = foreign "napi_get_cb_info" (napi_env @-> napi_callback_info @-> ptr(size_t) @-> ptr(napi_value) @-> ptr(napi_value) @-> ptr(ptr(void)) @-> returning napi_status)
  let napi_get_new_target = foreign "napi_get_new_target" (napi_env @-> napi_callback_info @-> ptr(napi_value) @-> returning napi_status)
  let napi_new_instance = foreign "napi_new_instance" (napi_env @-> napi_value @-> size_t @-> ptr(napi_value) @-> ptr(napi_value) @-> returning napi_status)
end

module ObjectWrap = struct
  open Properties

  (* Object wrap *)
  let napi_define_class = foreign "napi_define_class" (
    napi_env @->
    string @->
    size_t @->
    napi_callback @->
    ptr(void) @->
    size_t @->
    ptr(napi_property_descriptor) @->
    ptr(napi_value) @->
    returning napi_status
  )
  let napi_wrap = foreign "napi_wrap" (napi_env @-> napi_value @-> ptr(void) @-> napi_finalize @-> ptr(void) @-> ptr(napi_ref) @-> returning napi_status)
  let napi_unwrap = foreign "napi_unwrap" (napi_env @-> napi_value @-> ptr(ptr(void)) @-> returning napi_status)
  let napi_remove_wrap = foreign "napi_remove_wrap" (napi_env @-> napi_value @-> ptr(ptr(void)) @-> returning napi_status)

end

module Asynchronous = struct
  open Types

  (* Simple asynchronous operations *)
  let napi_create_async_work = foreign "napi_create_async_work" (
    napi_env @->
    napi_value @->
    napi_value @->
    napi_async_execute_callback  @->
    napi_async_complete_callback @->
    ptr(void) @->
    ptr(napi_async_work) @->
    returning napi_status
  )
  let napi_delete_async_work = foreign "napi_delete_async_work" (napi_env @-> napi_async_work @-> returning napi_status)
  let napi_queue_async_work = foreign "napi_queue_async_work" (napi_env @-> napi_async_work @-> returning napi_status)
  let napi_cancel_async_work = foreign "napi_cancel_async_work" (napi_env @-> napi_async_work @-> returning napi_status)

  (* Custom asynchronous operations *)
  let napi_async_init = foreign "napi_async_init" (napi_env @-> napi_value @-> napi_value @-> ptr(napi_async_context) @-> returning napi_status)
  let napi_async_destroy = foreign "napi_async_destroy" (napi_env @-> napi_async_context @-> returning napi_status)
  let napi_make_callback = foreign "napi_make_callback" (
    napi_env @->
    napi_async_context @->
    napi_value @->
    napi_value @->
    size_t @->
    ptr(napi_value) @->
    ptr(napi_value) @->
    returning napi_status
  )
end

module VersionManagement = struct
  open Types

  let napi_get_node_version = foreign "napi_get_node_version" (napi_env @-> ptr(ptr(napi_node_version)) @-> returning napi_status)
  let napi_get_version = foreign "napi_get_version" (napi_env @-> ptr(uint32_t) @-> returning napi_status)
end

module MemoryManagement = struct
  let napi_adjust_external_memory = foreign "napi_adjust_external_memory" (napi_env @-> int64_t @-> ptr(int64_t) @-> returning napi_status)
end

module Promises = struct
  open Types

  let napi_create_promise = foreign "napi_create_promise" (napi_env @-> ptr(napi_deferred) @-> ptr(napi_value) @-> returning napi_status)
  let napi_resolve_deferred = foreign "napi_resolve_deferred" (napi_env @-> napi_deferred @-> napi_value @-> returning napi_status)
  let napi_reject_deferred = foreign "napi_reject_deferred" (napi_env @-> napi_deferred @-> napi_value @-> returning napi_status)
  let napi_is_promise = foreign "napi_is_promise" (napi_env @-> napi_value @-> ptr(bool) @-> returning napi_status)
end

module ScriptExecution = struct
  let napi_run_script = foreign "napi_run_script" (napi_env @-> napi_value @-> ptr(napi_value) @-> returning napi_status)
end