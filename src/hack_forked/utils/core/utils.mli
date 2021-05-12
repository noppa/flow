(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

(* This `.mli` file was generated automatically. It may include extra
   definitions that should not actually be exposed to the caller. If you notice
   that this interface file is a poor interface, please take a few minutes to
   clean it up manually, and then delete this comment once the interface is in
   shape. *)

type callstack = Callstack of string

val spf : ('a, unit, string) format -> 'a

val singleton_if : bool -> 'a -> 'a list

val unsafe_opt : 'a option -> 'a

val try_finally : f:(unit -> 'a) -> finally:(unit -> unit) -> 'a

val with_context : enter:(unit -> unit) -> exit:(unit -> unit) -> do_:(unit -> 'c) -> 'c
