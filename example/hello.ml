open Ctypes
open Foreign
open Utils

(* Ocaml Function *)
let hello env cbInfo =
  let args = get_args_arr env cbInfo 1 in
  let strRaw = CArray.get args 0 in
  let str = from_napi_str env strRaw in
  let returnVal = "Hello " ^ str in
  !@(to_napi_str env returnVal)