(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(***********************************************************************)

(* $Id: lexing.ml,v 1.1 1998/08/19 13:29:07 pessaux Exp $ *)

(* The run-time library for lexers generated by camllex *)

type lexbuf =
  { refill_buff : lexbuf -> unit;
    mutable lex_buffer : string;
    mutable lex_buffer_len : int;
    mutable lex_abs_pos : int;
    mutable lex_start_pos : int;
    mutable lex_curr_pos : int;
    mutable lex_last_pos : int;
    mutable lex_last_action : int;
    mutable lex_eof_reached : bool }

type lex_tables =
  { lex_base: string;
    lex_backtrk: string;
    lex_default: string;
    lex_trans: string;
    lex_check: string }

external engine: lex_tables[`a] <[`b]-> int[`c] <[`d]-> lexbuf[`e] <[`f]->
                 int[_] = "lex_engine" ;;

let lex_refill read_fun aux_buffer lexbuf =
  let read =
    read_fun aux_buffer (String.length aux_buffer) in
  let n =
    if read > 0
    then read
    else (lexbuf.lex_eof_reached <- true; 0) in
  if lexbuf.lex_start_pos < n then begin
    let oldlen = lexbuf.lex_buffer_len in
    let newlen = oldlen * 2 in
    let newbuf = String.create newlen in
    String.unsafe_blit lexbuf.lex_buffer 0 newbuf oldlen oldlen;
    lexbuf.lex_buffer <- newbuf;
    lexbuf.lex_buffer_len <- newlen;
    lexbuf.lex_abs_pos <- lexbuf.lex_abs_pos - oldlen;
    lexbuf.lex_curr_pos <- lexbuf.lex_curr_pos + oldlen;
    lexbuf.lex_start_pos <- lexbuf.lex_start_pos + oldlen;
    lexbuf.lex_last_pos <- lexbuf.lex_last_pos + oldlen
  end;
  String.unsafe_blit lexbuf.lex_buffer n
                     lexbuf.lex_buffer 0 
                     (lexbuf.lex_buffer_len - n);
  String.unsafe_blit aux_buffer 0
                     lexbuf.lex_buffer (lexbuf.lex_buffer_len - n)
                     n;
  lexbuf.lex_abs_pos <- lexbuf.lex_abs_pos + n;
  lexbuf.lex_curr_pos <- lexbuf.lex_curr_pos - n;
  lexbuf.lex_start_pos <- lexbuf.lex_start_pos - n;
  lexbuf.lex_last_pos <- lexbuf.lex_last_pos - n

let from_function f =
  { refill_buff = lex_refill f (String.create 512);
    lex_buffer = String.create 1024;
    lex_buffer_len = 1024;
    lex_abs_pos = - 1024;
    lex_start_pos = 1024;
    lex_curr_pos = 1024;
    lex_last_pos = 1024;
    lex_last_action = 0;
    lex_eof_reached = false }

let from_channel ic =
  from_function (fun buf n -> input ic buf 0 n)

let from_string s =
  { refill_buff = (fun lexbuf -> lexbuf.lex_eof_reached <- true);
    lex_buffer = s ^ "";
    lex_buffer_len = String.length s;
    lex_abs_pos = 0;
    lex_start_pos = 0;
    lex_curr_pos = 0;
    lex_last_pos = 0;
    lex_last_action = 0;
    lex_eof_reached = true }

let lexeme lexbuf =
  let len = lexbuf.lex_curr_pos - lexbuf.lex_start_pos in
  let s = String.create len in
  String.unsafe_blit lexbuf.lex_buffer lexbuf.lex_start_pos s 0 len;
  s

let lexeme_char lexbuf i =
  String.get lexbuf.lex_buffer (lexbuf.lex_start_pos + i)

let lexeme_start lexbuf =
  lexbuf.lex_abs_pos + lexbuf.lex_start_pos
and lexeme_end lexbuf =
  lexbuf.lex_abs_pos + lexbuf.lex_curr_pos

