module type Tube = sig
  type t
  val metadata : t
  val read : int -> bytes
  val read_error : int -> bytes
  val write : bytes -> int
end

let create_tube (type a) metadata read read_error write =
  (module struct
    type t = a
    let metadata = metadata
    let read = read
    let read_error = read_error
    let write = write
  end : Tube with type t = a);;
