open Ctypes
open Foreign
open Lib.V1.Types
open Lib.V1.Functions
open Lib.V1.Properties
open Utils
open Hello
open Calc

(* init NAPI *)
let lib_init envNat exportNat =
  let env = ptr_of_raw_address envNat in
  let exports = ptr_of_raw_address exportNat in
  (add_to_init env exports "hello" hello) |> ignore;
  (add_to_init env exports "calc" calc) |> ignore;
  exportNat

let () =
  Callback.register "lib_init" lib_init