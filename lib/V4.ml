open Ctypes
open Foreign
include V3
open Types

module Types = struct
  include V3.Types
  (* Basic Node-API data types *)
  type napi_threadsafe_function = unit ptr
  let napi_threadsafe_function: napi_threadsafe_function typ = ptr void

  let napi_threadsafe_function_release_mode = uint64_t (* TODO: enum *)
  let napi_threadsafe_function_call_mode = uint64_t (* TODO: enum *)
  let napi_threadsafe_function_call_js = funptr_opt (napi_env @-> napi_value @-> ptr(void) @-> ptr(void) @-> returning void)
end

module Asynchronous = struct
  open Types
  include V3.Asynchronous

  (* Asynchronous thread-safe function calls *)
  let napi_create_threadsafe_function = foreign "napi_create_threadsafe_function" (
    napi_env @-> (* env *)
    napi_value @-> (* func *)
    napi_value @-> (* async_resource *)
    napi_value @-> (* async_resource_name *)
    size_t @-> (* max_queue_size *)
    size_t @-> (* initial_thread_count *)
    ptr(void) @-> (* thread_finalize_data *)
    napi_finalize @-> (* thread_finalize_cb *)
    ptr(void) @-> (* context *)
    napi_threadsafe_function_call_js @-> (* call_js_cb *)
    ptr(napi_threadsafe_function) @-> (* result *)
    returning napi_status
  )
  let napi_get_threadsafe_function_context = foreign "napi_get_threadsafe_function_context" (napi_threadsafe_function @-> ptr(ptr(void)) @-> returning napi_status)
  let napi_call_threadsafe_function = foreign "napi_call_threadsafe_function" (napi_threadsafe_function @-> ptr(void) @-> napi_threadsafe_function_call_mode @-> returning napi_status)
  let napi_acquire_threadsafe_function = foreign "napi_acquire_threadsafe_function" (napi_threadsafe_function @-> returning napi_status)
  let napi_release_threadsafe_function = foreign "napi_release_threadsafe_function" (napi_threadsafe_function @-> napi_threadsafe_function_release_mode @-> returning napi_status)
  let napi_ref_threadsafe_function = foreign "napi_ref_threadsafe_function" (napi_env @-> napi_threadsafe_function @-> returning napi_status)
  let napi_unref_threadsafe_function = foreign "napi_unref_threadsafe_function" (napi_env @-> napi_threadsafe_function @-> returning napi_status)
end