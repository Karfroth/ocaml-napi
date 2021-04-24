open Ctypes
open Foreign
open Utils
open Lib.V8
open Properties

type op = 
| Add
| Subtract
| Multiply
| Divide
| NoOp

let convert_to_op = function
| "+" -> Add
| "-" -> Subtract
| "*" -> Multiply
| "/" -> Divide
|  _ -> NoOp

let apply_op op a b = match op with
| Add      -> a +. b
| Subtract -> a -. b
| Multiply -> a *. b
| Divide   -> a /. b
| NoOp     -> 0.0

let calc env cb_info =
  let args = get_args_arr env cb_info 1 in
  let obj = CArray.get args 0 in
  let op_str = !@(get_value_from_obj env (obj |> ptr_of_raw_address) "op") |> (from_napi_str env)
  and a = !@(get_value_from_obj env (obj |> ptr_of_raw_address) "a") |> (from_napi_num_to_float env)
  and b = !@(get_value_from_obj env (obj |> ptr_of_raw_address) "b") |> (from_napi_num_to_float env) in
  let op = op_str |> convert_to_op in
  let res = apply_op op a b in
  !@(to_napi_number env res)
