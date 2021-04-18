open Ctypes
open Foreign
open Util

let node_api_get_module_file_name = foreign "node_api_get_module_file_name" (napi_env @-> ptr_opt(string) @-> returning napi_status)