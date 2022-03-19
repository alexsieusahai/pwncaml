open Core

let _read sock maxlen =
  let buf = Bytes.create maxlen in
  let len = Unix.recv sock ~buf ~pos:0 ~len:maxlen ~mode:[] in
  Bytes.sub buf ~pos:0 ~len

let _write sock buf =
  let rec send pos =
    if pos < Bytes.length buf
    then
      send (Unix.send sock ~buf ~pos ~len:(Bytes.length buf) ~mode:[]) |> ignore;
  in
  send 0;
  Bytes.length buf

let remote hostname port =
  let ai = Unix.getaddrinfo hostname (Int.to_string port) [] |> List.hd_exn in
  let sock = Unix.socket ~domain:ai.ai_family ~kind:ai.ai_socktype ~protocol:ai.ai_protocol () in
  Unix.connect sock ~addr:ai.ai_addr;
  let read = _read sock in
  let read_error = fun _ -> Bytes.create 0 in
  let write = _write sock in
  Tube.tube sock read read_error write
let%expect_test "read" =
  let module Tube = (val remote "ftp.ubuntu.com" 21) in
  let output = Tube.read 4 in
  output |> Bytes.to_string |> print_endline;
  [%expect{| 220 |}]
let%expect_test "write" =
  let module Tube = (val remote "www.google.com" 80) in
  let _ = Tube.write ("GET / HTTP/1.1\r\nHost:www.google.com\r\n\r\n" |> Bytes.of_string) in
  let output = Tube.read 4 in
  output |> Bytes.to_string |> print_endline;
  [%expect{| HTTP |}]
