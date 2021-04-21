'use strict';

var Mylib = require("../mylib");
var helloString = Mylib.hello("From OCaml Native with Node NAPI!");
console.log(helloString);
var three = Mylib.calc({op: "+"});
console.log(three);