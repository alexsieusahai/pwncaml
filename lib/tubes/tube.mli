module type Tube = sig
  type t
  val metadata : t
  val read : int -> bytes
  val read_error : int -> bytes
  val write : bytes -> int
end

val create_tube : 'metadata_type -> (int -> bytes) -> (int -> bytes) -> (bytes -> int) -> (module Tube with type t = 'metadata_type)
