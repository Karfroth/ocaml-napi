open Ctypes
open Foreign

(* Basic Node-API data types *)
type napi_threadsafe_function = unit ptr
let napi_threadsafe_function: napi_threadsafe_function typ = ptr void

let napi_threadsafe_function_release_mode = uint64_t (* TODO: enum *)
let napi_threadsafe_function_call_mode = uint64_t (* TODO: enum *)