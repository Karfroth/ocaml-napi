open Ctypes
open Foreign
open Lib.V8.Types
open Lib.V8.Functions
open Lib.V8.Properties
open Utils
open Hello
open Calc

(* init NAPI *)
let lib_init envNat exportNat =
  let env = ptr_of_raw_address envNat in
  let exports = ptr_of_raw_address exportNat in
  add_to_init env exports "hello" hello;
  add_to_init env exports "calc" calc;
  exportNat

let () =
  Callback.register "lib_init" lib_init