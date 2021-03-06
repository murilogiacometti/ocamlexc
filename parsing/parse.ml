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

(* $Id: parse.ml,v 1.2 1998/10/23 13:18:40 pessaux Exp $ *)

(* Entry points in the parser *)

open Location

(* Skip tokens to the end of the phrase *)

let rec skip_phrase lexbuf =
  try
    match Lexer.token lexbuf with
      Parser.SEMISEMI | Parser.EOF -> ()
    | _ -> skip_phrase lexbuf
  with
    | Lexer.Error (Lexer.Unterminated_comment, _, _) -> ()
    | Lexer.Error (Lexer.Unterminated_string, _, _) -> ()
    | Lexer.Error(_,_,_) -> skip_phrase lexbuf

let maybe_skip_phrase lexbuf =
  if Parsing.is_current_lookahead Parser.SEMISEMI
  or Parsing.is_current_lookahead Parser.EOF
  then ()
  else skip_phrase lexbuf

let wrap parsing_fun lexbuf =
  try
    let ast = parsing_fun Lexer.token lexbuf in
    Parsing.clear_parser();
    ast
  with
    | Lexer.Error(Lexer.Unterminated_comment, _, _) as err -> raise err
    | Lexer.Error(Lexer.Unterminated_string, _, _) as err -> raise err
    | Lexer.Error(_, _, _) as err ->
        if !Location.input_name = "" then skip_phrase lexbuf;
        raise err
    | Syntaxerr.Error _ as err ->
        if !Location.input_name = "" then maybe_skip_phrase lexbuf;
        raise err
    | Parsing.Parse_error | Syntaxerr.Escape_error ->
        let loc = { loc_start = Lexing.lexeme_start lexbuf;
                    loc_end = Lexing.lexeme_end lexbuf } in
        if !Location.input_name = "" 
        then maybe_skip_phrase lexbuf;
        raise(Syntaxerr.Error(Syntaxerr.Other loc))

(* !!! Eta expansions *)
let implementation x = wrap Parser.implementation x
and interface x= wrap Parser.interface x
and toplevel_phrase x = wrap Parser.toplevel_phrase x
and use_file x = wrap Parser.use_file x
