open Ctypes
open Foreign
open Utils
open Lib.V8

(* Ocaml Function *)
let hello env cbInfo =
  let args = get_args_arr env cbInfo 1 in
  let strRaw = CArray.get args 0 in
  let str = from_napi_str env strRaw in
  let v = napi_get_version env in
  let v_str = string_of_int v in
  let returnVal = "Hello " ^ str ^ v_str in
  !@(to_napi_str env returnVal)