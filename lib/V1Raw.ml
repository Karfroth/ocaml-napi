open Ctypes

module type NAPITypes = sig
  type napi_status
  type napi_env
  type napi_callback_info
  type napi_value
  type 'a pointer

  val to_napi_env: unit ptr -> napi_env
  val to_napi_callback_info: unit ptr -> napi_callback_info
  val to_napi_value: unit ptr -> napi_value
  val to_pointer: 'a Ctypes.ptr -> 'a pointer
end
module Types: NAPITypes = struct
  type napi_status = Unsigned.uint64 (* TODO: enum *)
  type napi_env = nativeint
  type napi_callback_info = nativeint
  type napi_value = nativeint
  type 'a pointer = nativeint

  let to_napi_env ptr = raw_address_of_ptr ptr
  let to_napi_callback_info ptr = raw_address_of_ptr ptr
  let to_napi_value ptr = raw_address_of_ptr ptr
  let to_pointer (ptr: 'a Ctypes.ptr): 'a pointer = ptr |> to_voidp |> Ctypes.raw_address_of_ptr
end
open Types

let a = ptr(size_t)

external napi_get_cb_info: napi_env -> napi_callback_info -> nativeint -> nativeint -> nativeint -> nativeint -> napi_status
  = "napi_get_cb_info_bytecode" "napi_get_cb_info_native"

external napi_create_string_utf8: napi_env -> string -> (V1.Types.napi_value Types.pointer) -> napi_status = "napi_create_string_utf8_native"