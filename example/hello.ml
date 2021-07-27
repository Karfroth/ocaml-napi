open Ctypes
open Foreign
open Utils
open Lib.V1

(* Ocaml Function *)
let hello env cbInfo =
  let args = get_args_arr env cbInfo 1 in
  let strRaw = CArray.get args 0 in
  let str = from_napi_str env strRaw in
  let (_, napi_version_opt) =  env |> raw_address_of_ptr |> VersionManagement.napi_get_version in
  let napi_version = napi_version_opt
    |> Option.map Unsigned.UInt32.to_string
    |> Option.value ~default: "Version Not Found" in
  let returnVal = "Hello " ^ str ^ "(NAPI " ^ napi_version ^ ")" in
  !@(to_napi_str env returnVal)