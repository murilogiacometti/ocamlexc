(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  Distributed only by permission.                   *)
(*                                                                     *)
(***********************************************************************)

(* $Id: clflags.ml,v 1.2 1999/02/15 15:00:33 pessaux Exp $ *)

(* Command-line parameters *)

let objfiles = ref ([] : string list)   (* .cmo and .cma files *)
and ccobjs = ref ([] : string list)     (* .o, .a and -lxxx files *)

let compile_only = ref false            (* -c *)
and exec_name = ref "a.out"             (* -o *)
and archive_name = ref "library.cma"    (* -o *)
and object_name = ref ("camlprog" ^ Config.ext_obj) (* -o *)
and include_dirs = ref ([] : string list)(* -I *)
and print_types = ref false             (* -i *)
and make_archive = ref false            (* -a *)
and debug = ref false                   (* -g *)
and fast = ref false                    (* -unsafe *)
and link_everything = ref false         (* -linkall *)
and custom_runtime = ref false          (* -custom *)
and output_c_object = ref false         (* -output-obj *)
and ccopts = ref ([] : string list)     (* -ccopt *)
and nopervasives = ref false            (* -nopervasives *)
and preprocessor = ref(None : string option) (* -pp *)
and thread_safe = ref false             (* -thread *)
and noassert = ref false                (* -noassert *)
and verbose = ref false                 (* -verbose *)
and use_prims = ref ""                  (* -use_prims ... *)
and use_runtime = ref ""                (* -use_runtime ... *)
and make_runtime = ref false            (* -make_runtime *)
and gprofile = ref false                (* -p *)
and c_compiler = ref Config.bytecomp_c_compiler (* -cc *)
let dump_rawlambda = ref false          (* -drawlambda *)
and dump_lambda = ref false             (* -dlambda *)
and dump_instr = ref false              (* -dinstr *)

let keep_asm_file = ref false           (* -S *)
let optimize_for_speed = ref true       (* -compact *)

and dump_cmm = ref false                (* -dcmm *)
let dump_selection = ref false          (* -dsel *)
let dump_live = ref false               (* -dlive *)
let dump_spill = ref false              (* -dspill *)
let dump_split = ref false              (* -dsplit *)
let dump_scheduling = ref false         (* -dscheduling *)
let dump_interf = ref false             (* -dinterf *)
let dump_prefer = ref false             (* -dprefer *)
let dump_regalloc = ref false           (* -dalloc *)
let dump_reload = ref false             (* -dreload *)
let dump_scheduling = ref false         (* -dscheduling *)
let dump_linear = ref false             (* -dlinear *)
let keep_startup_file = ref false       (* -dstartup *)

let native_code = ref false             (* set to true under ocamlopt *)

let inline_threshold = ref 10
