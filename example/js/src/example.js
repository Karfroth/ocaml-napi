'use strict';

var Mylib = require("../mylib");
var helloString = Mylib.hello("From OCaml Native with Node NAPI!");
console.log(helloString);
var three = Mylib.calc({op: "+", a: 1.0, b: 2.0});
console.log(three);
var twenty = Mylib.calc({op: "*", a: 10.0, b: 2.0});
console.log(twenty);
var four = Mylib.calc({op: "-", a: 6.0, b: 2.0});
console.log(four);
var ten = Mylib.calc({op: "/", a: 20.0, b: 2.0});
console.log(ten);