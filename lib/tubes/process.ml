open Core

let _read fd maxlen =
  let buf = Bytes.init maxlen ~f:(fun _ -> 'a') in
  let len = Unix.read fd ~buf in
  Bytes.sub buf ~pos:0 ~len

let create_process prog args =
  let pinfo = Unix.create_process ~prog ~args in
  let read = fun maxlen -> _read pinfo.stdout maxlen in
  let read_error = fun maxlen -> _read pinfo.stderr maxlen in
  let write = (fun buf -> Unix.write pinfo.stdin ~buf) in
  Tube.create_tube pinfo read read_error write
let%expect_test "read" =
  let module Tube = (val create_process "echo" ["Hello,"; "World!"]) in
  let output = Tube.read 1024 in
  print_endline (Bytes.to_string output);
  [%expect{|
    Hello, World!
  |}]
let%expect_test "write" =
  let module Tube = (val create_process "cat" []) in
  let _ = Tube.write (Bytes.of_string "Hello, World!") in
  let output = Tube.read 1024 in
  print_endline (Bytes.to_string output);
  [%expect{|
    Hello, World!
  |}]
let%expect_test "read_error" =
  let module Tube = (val create_process "cat" ["definitely_not_a_file"]) in
  print_endline (Tube.read_error 1024 |> Bytes.to_string);
  [%expect {| cat: definitely_not_a_file |}]
