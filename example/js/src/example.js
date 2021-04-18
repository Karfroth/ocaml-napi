'use strict';

var Mylib = require("../mylib");
var res = Mylib.hello("From OCaml Native with Node NAPI!");
console.log(res);