open Ctypes
open Foreign
include V5
open Types

(* Working with JavaScript values *)
module JSValues = struct
  include V5.JSValues
  (* Enum types *)
  let napi_key_collection_mode = uint64_t (* TODO: ENUM *)
  let napi_key_filter = uint64_t (* TODO: ENUM *)
  let napi_key_conversion = uint64_t (* TODO: ENUM *)

  (* Functions to convert from C types to Node-API *)
  let napi_create_bigint_int64 = foreign "napi_create_bigint_int64" (napi_env @-> int64_t @-> ptr(napi_value) @-> returning napi_status)
  let napi_create_bigint_uint64 = foreign "napi_create_bigint_uint64" (napi_env @-> uint64_t @-> ptr(napi_value) @-> returning napi_status)
  let napi_create_bigint_words = foreign "napi_create_bigint_words" (napi_env @-> int @-> size_t @-> ptr(uint64_t) @-> ptr(napi_value) @-> returning napi_status)

  (* Functions to convert from Node-API to C types *)
  let napi_get_value_bigint_int64 = foreign "napi_get_value_bigint_int64" (napi_env @-> napi_value @-> ptr(int64_t) @-> ptr(bool) @-> returning napi_status)
  let napi_get_value_bigint_uint64 = foreign "napi_get_value_bigint_uint64" (napi_env @-> napi_value @-> ptr(uint64_t) @-> ptr(bool) @-> returning napi_status)
  let napi_get_value_bigint_words = foreign "napi_get_value_bigint_words" (napi_env @-> napi_value @-> ptr_opt(int) @-> ptr(size_t) @-> ptr_opt(uint64_t) @-> returning napi_status)
end

module Properties = struct
  include JSValues
  include V5.Properties

  let napi_get_all_property_names = foreign "napi_get_all_property_names" (napi_env @-> napi_value @-> napi_key_collection_mode @-> napi_key_filter @-> napi_key_conversion @-> ptr(napi_value) @-> returning napi_status)
end

module EnvironmentLifeCycle = struct
  let napi_set_instance_data = foreign "napi_set_instance_data" (napi_env @-> ptr(void) @-> napi_finalize @-> ptr(void) @-> returning napi_status)
  let napi_get_instance_data = foreign "napi_get_instance_data" (napi_env @-> ptr_opt(ptr(void)) @-> returning napi_status)
end