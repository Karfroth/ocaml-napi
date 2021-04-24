open Ctypes
open Foreign
open Lib.V8.Types
open Lib.V8.Functions
open Lib.V8.JSValues
open Lib.V8.Properties

let add_to_init env exports name f =
  let fn = allocate_n napi_value ~count: 1 in
  let fnName = name |> CArray.of_string |> CArray.start in
  let fnNameLength = name |> String.length |> Unsigned.Size_t.of_int in
  let fnCreateStatus = napi_create_function env fnName fnNameLength f null fn in
  napi_set_named_property env exports fnName !@fn;;

let convert_to_ocaml_str ?encoding str =
  let src = `String str in
  let rec loop d buf acc = match Uutf.decode d with
  | `Uchar u ->
      begin match Uchar.to_int u with
      | 0x000A ->
          let line = Buffer.contents buf in
          Buffer.clear buf; loop d buf (line :: acc)
      | _ ->
          Uutf.Buffer.add_utf_8 buf u; loop d buf acc
      end
  | `End -> List.rev (Buffer.contents buf :: acc)
  | `Malformed _ -> Uutf.Buffer.add_utf_8 buf Uutf.u_rep; loop d buf acc
  | `Await -> assert false
  in
  let nln = `Readline (Uchar.of_int 0x000A) in
  (loop (Uutf.decoder ~nln ?encoding src) (Buffer.create 512) []) |> String.concat ""

let to_napi_str env str =
  let strValue = allocate_n napi_value ~count: 1 in
  let strLen =  (String.length str) |> Unsigned.Size_t.of_int in
  let resStatus = napi_create_string_utf8 env str strLen strValue in
  strValue

let to_napi_number env num =
  let num_value = allocate_n napi_value ~count: 1 in
  let resStatus = napi_create_double env num num_value in
  num_value

let from_napi_str env napiStr =
  let strSizePtr = allocate size_t (Unsigned.Size_t.of_int 0)
  and strSizeReadPtr = allocate size_t (Unsigned.Size_t.of_int 0) in
  let resStatus = napi_get_value_string_utf8 env napiStr None (Unsigned.Size_t.of_int 0) strSizePtr in
  let newStrSize = Unsigned.Size_t.add (!@strSizePtr) Unsigned.Size_t.one in
  let strLength = Unsigned.Size_t.to_int newStrSize in
  let buf = allocate_n char ~count: (Unsigned.Size_t.to_int newStrSize) in
  let resStatus2 = napi_get_value_string_utf8 env napiStr (Some buf) newStrSize strSizeReadPtr in
  (Ctypes.string_from_ptr ~length: strLength buf) |> convert_to_ocaml_str

let from_napi_num_to_float env napi_num =
  let float_ptr = allocate Ctypes.double (-1.0) in
  let conversion_result = napi_get_value_double env napi_num float_ptr in
  !@float_ptr

let get_args_arr env cbInfo len =
  let sizeTLen = Unsigned.Size_t.of_int len in
  let sizeTLenPtr = allocate size_t sizeTLen
  and args = CArray.make nativeint len in
  let res = Lib.V1Raw.napi_get_cb_info_c 
    (env |> raw_address_of_ptr)
    (cbInfo |> raw_address_of_ptr)
    (sizeTLenPtr |> to_voidp |> raw_address_of_ptr)
    (args |> CArray.start |> to_voidp |> raw_address_of_ptr)
    (null |> raw_address_of_ptr)
    (null |> raw_address_of_ptr) in
  args

let get_value_from_obj env obj key_str =
  let key = to_napi_str env key_str in
  let result = allocate_n napi_value ~count: 1 in
  let status = napi_get_property env obj !@key result in
  result