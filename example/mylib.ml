open Ctypes
open Foreign
open Lib.V8.Types
open Lib.V8.Functions
open Lib.V8.JSValues
open Lib.V8.Properties

let to_napi_str (env: napi_env) str =
  let strValue = allocate_n Lib.V1.Types.napi_value ~count: 1 in
  let strLen =  (String.length str) |> Unsigned.Size_t.of_int in
  let resStatus = napi_create_string_utf8 env str strLen strValue in
  strValue

let from_napi_str env napiStr =
  let strSizePtr = allocate size_t (Unsigned.Size_t.of_int 0)
  and strSizeReadPtr = allocate size_t (Unsigned.Size_t.of_int 0) in
  let resStatus = napi_get_value_string_utf8 env napiStr None (Unsigned.Size_t.of_int 0) strSizePtr in
  let newStrSize = Unsigned.Size_t.add (!@strSizePtr) Unsigned.Size_t.one in
  let strLength = Unsigned.Size_t.to_int newStrSize in
  let buf = allocate_n char ~count: (Unsigned.Size_t.to_int newStrSize) in
  let resStatus2 = napi_get_value_string_utf8 env napiStr (Some buf) newStrSize strSizeReadPtr in
  Ctypes.string_from_ptr ~length: strLength buf

let get_args_arr env cbInfo len =
  let sizeTLen = Unsigned.Size_t.of_int len in
  let sizeTLenPtr = allocate size_t sizeTLen
  and args = CArray.make napi_value len in
  let res = napi_get_cb_info env cbInfo sizeTLenPtr (CArray.start args) None None in
  args

(* Ocaml Function *)
let hello env cbInfo =
  let args = get_args_arr env cbInfo 1 in
  let strRaw = CArray.get args 0 in
  let str = from_napi_str env strRaw in
  let returnVal = "Hello " ^ str in
  !@(to_napi_str env returnVal)

(* init NAPI *)
let lib_init envNat exportNat =
  let env = ptr_of_raw_address envNat in
  let exports = ptr_of_raw_address exportNat in
  let fn = allocate_n napi_value ~count: 1 in
  let fnName = "hello" |> CArray.of_string |> CArray.start in
  let fnNameLength = Unsigned.Size_t.of_int 5 in
  let fnCreateStatus = napi_create_function env fnName fnNameLength hello null fn in
  let napiSetStatus = napi_set_named_property env exports fnName !@fn in
  exportNat

let () =
  Callback.register "lib_init" lib_init