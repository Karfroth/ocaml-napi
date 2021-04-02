open Ctypes
open Foreign
include Util

(* Exceptions *)
module ErrorHandling = struct
  include Util.ErrorHandling

  let napi_fatal_exception = foreign "napi_fatal_exception" (napi_env @-> napi_value @-> returning napi_status)
end

module ObjectLifetime = struct
  include Util.ObjectLifetime

  (* Cleanup on exit of the current Node.js instance *)
  let napi_add_env_cleanup_hook = foreign "napi_add_env_cleanup_hook" (napi_env @-> (funptr (ptr(void) @-> returning void) @-> ptr(void) @-> returning napi_status))
  let napi_remove_env_cleanup_hook = foreign "napi_remove_env_cleanup_hook" (napi_env @-> (funptr (ptr(void) @-> returning void) @-> ptr(void) @-> returning napi_status))
end

module Asynchronous = struct
  open Types
  include Util.Asynchronous

  let napi_open_callback_scope = foreign "napi_open_callback_scope" (napi_env @-> napi_value @-> napi_async_context @-> ptr(napi_callback_scope) @-> returning napi_status)
  let napi_close_callback_scope = foreign "napi_close_callback_scope" (napi_env @-> napi_callback_scope @-> returning napi_status)
end