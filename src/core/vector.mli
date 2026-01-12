(** The type of 2D Vectors *)
type t =
  { x : float
  ; y : float
  }

(** Addition of vectors *)
val add : t -> t -> t

(** Subtraction of vectors *)
val sub : t -> t -> t

(** Multiplication of a floating point number by a vector *)
val mult : float -> t -> t

(** Dot product (scalar product) *)
val dot : t -> t -> float

(** Norm of a vector *)
val norm : t -> float

(** Normlized vector *)
val normalize : t -> t

(** Pretty printer for a vector *)
val pp : Format.formatter -> t -> unit

(** The null vector *)
val zero : t

(** Test for the null vector *)
val is_zero : t -> bool
