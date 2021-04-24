open Ctypes

module Types = struct
  type napi_status = Unsigned.uint64 (* TODO: enum *)

  type napi_env = nativeint
  (* let napi_env: napi_env typ = ptr void *)

  type napi_callback_info = nativeint
  (* let napi_callback_info: napi_callback_info typ = ptr void *)

  type napi_value = nativeint
  (* let napi_value: napi_value typ = ptr void *)
end
open Types

let a = ptr(size_t)

external napi_get_cb_info_c: napi_env -> napi_callback_info -> nativeint -> nativeint -> nativeint -> nativeint -> napi_status
  = "napi_get_cb_info_bytecode" "napi_get_cb_info_native"