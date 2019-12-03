open Yojson
open Safe
open Util

let storage = "{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Pair\",\"args\":[{\"int\":\"808\"},{\"prim\":\"False\"}]},{\"prim\":\"Pair\",\"args\":[{\"bytes\":\"ab\"},{\"int\":\"1\"}]}]},{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Pair\",\"args\":[[{\"int\":\"20\"},{\"int\":\"21\"}],[{\"prim\":\"Elt\",\"args\":[{\"int\":\"30\"},{\"int\":\"30\"}]},{\"prim\":\"Elt\",\"args\":[{\"int\":\"31\"},{\"int\":\"31\"}]},{\"prim\":\"Elt\",\"args\":[{\"int\":\"32\"},{\"int\":\"32\"}]}]]},{\"prim\":\"Pair\",\"args\":[[{\"prim\":\"Elt\",\"args\":[{\"int\":\"40\"},[{\"int\":\"400\"},{\"int\":\"401\"},{\"int\":\"402\"}]]},{\"prim\":\"Elt\",\"args\":[{\"int\":\"50\"},[{\"int\":\"500\"},{\"int\":\"501\"},{\"int\":\"502\"}]]}],[{\"prim\":\"Elt\",\"args\":[{\"int\":\"60\"},[{\"prim\":\"Elt\",\"args\":[{\"int\":\"70\"},{\"int\":\"80\"}]},{\"prim\":\"Elt\",\"args\":[{\"int\":\"71\"},{\"int\":\"81\"}]}]]},{\"prim\":\"Elt\",\"args\":[{\"int\":\"61\"},[{\"prim\":\"Elt\",\"args\":[{\"int\":\"77\"},{\"int\":\"88\"}]},{\"prim\":\"Elt\",\"args\":[{\"int\":\"99\"},{\"int\":\"101\"}]}]]}]]}]}]},{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Pair\",\"args\":[[{\"prim\":\"Elt\",\"args\":[{\"int\":\"1001\"},{\"prim\":\"Pair\",\"args\":[{\"int\":\"1002\"},{\"string\":\"myval0\"}]}]},{\"prim\":\"Elt\",\"args\":[{\"int\":\"1003\"},{\"prim\":\"Pair\",\"args\":[{\"int\":\"1004\"},{\"string\":\"myval1\"}]}]}],{\"int\":\"2\"}]},{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Some\",\"args\":[{\"int\":\"3\"}]},[{\"int\":\"777\"},{\"int\":\"888\"},{\"int\":\"999\"}]]}]},{\"prim\":\"Pair\",\"args\":[{\"prim\":\"Pair\",\"args\":[{\"string\":\"mystr\"},{\"prim\":\"Unit\"}]},{\"prim\":\"Pair\",\"args\":[{\"int\":\"4\"},{\"string\":\"myval\"}]}]}]}]}"
let storage_type = "{\"prim\":\"pair\",\"args\":[{\"prim\":\"pair\",\"args\":[{\"prim\":\"pair\",\"args\":[{\"prim\":\"pair\",\"args\":[{\"prim\":\"big_map\",\"args\":[{\"prim\":\"int\"},{\"prim\":\"int\"}],\"annots\":[\"%mbmap\"]},{\"prim\":\"bool\",\"annots\":[\"%mbool\"]}]},{\"prim\":\"pair\",\"args\":[{\"prim\":\"bytes\",\"annots\":[\"%mbytes\"]},{\"prim\":\"int\",\"annots\":[\"%mint\"]}]}]},{\"prim\":\"pair\",\"args\":[{\"prim\":\"pair\",\"args\":[{\"prim\":\"list\",\"args\":[{\"prim\":\"int\"}],\"annots\":[\"%mlist\"]},{\"prim\":\"map\",\"args\":[{\"prim\":\"int\"},{\"prim\":\"int\"}],\"annots\":[\"%mmap\"]}]},{\"prim\":\"pair\",\"args\":[{\"prim\":\"map\",\"args\":[{\"prim\":\"int\"},{\"prim\":\"list\",\"args\":[{\"prim\":\"int\"}]}],\"annots\":[\"%mmaplist\"]},{\"prim\":\"map\",\"args\":[{\"prim\":\"int\"},{\"prim\":\"map\",\"args\":[{\"prim\":\"int\"},{\"prim\":\"int\"}]}],\"annots\":[\"%mmapmap\"]}]}]}]},{\"prim\":\"pair\",\"args\":[{\"prim\":\"pair\",\"args\":[{\"prim\":\"pair\",\"args\":[{\"prim\":\"map\",\"args\":[{\"prim\":\"int\"},{\"prim\":\"pair\",\"args\":[{\"prim\":\"int\",\"annots\":[\"%id\"]},{\"prim\":\"string\",\"annots\":[\"%value\"]}]}],\"annots\":[\"%mmapmyrecord\"]},{\"prim\":\"nat\",\"annots\":[\"%mnat\"]}]},{\"prim\":\"pair\",\"args\":[{\"prim\":\"option\",\"args\":[{\"prim\":\"int\"}],\"annots\":[\"%moption\"]},{\"prim\":\"set\",\"args\":[{\"prim\":\"int\"}],\"annots\":[\"%mset\"]}]}]},{\"prim\":\"pair\",\"args\":[{\"prim\":\"pair\",\"args\":[{\"prim\":\"string\",\"annots\":[\"%mstring\"]},{\"prim\":\"unit\",\"annots\":[\"%munit\"]}]},{\"prim\":\"pair\",\"args\":[{\"prim\":\"int\",\"annots\":[\"%id\"]},{\"prim\":\"string\",\"annots\":[\"%value\"]}],\"annots\":[\"%myr\"]}]}]}]}"

(* Michelson value ----------------------------------------------------------*)

type ordered =
| Mint of int
| Mnat of int
| Mstr of string
| Mbytes of bytes
[@@deriving yojson, show {with_path = false}]

type mvalue =
| Mordered of ordered
| Mbool of bool
| Munit
| Moption of mvalue option
| Mpair of (mvalue * mvalue)
| Melt of (mvalue * mvalue)
| Munion of (mvalue * mvalue)
| Mlist of mvalue list
| Mmap of (ordered * mvalue) list
| Mset of ordered list
[@@deriving yojson, show {with_path = false}]

(* Michelson type -----------------------------------------------------------*)

type ordered_mtype =
| Tint
| Tnat
| Tstr
| Tbytes
[@@deriving yojson, show {with_path = false}]

type mtype =
| Tpair of amtype * amtype
| Tunion of amtype * amtype
| Tordered of ordered_mtype
| Toption of mtype
| Tbool
| Tunit
| Tlist of mtype
| Tmap of ordered_mtype * mtype
| Tset of ordered_mtype
and amtype = string option * mtype
[@@deriving yojson, show {with_path = false}]

(* flat storage type --------------------------------------------------------*)

type elt = string
[@@deriving yojson, show {with_path = false}]

type value =
| Vsingle of elt
| Voption of value option
| Vmultiple of (elt * value) list
[@@deriving yojson, show {with_path = false}]

type ordered_sftype =
| Sint
| Snat
| Sstr
| Sbytes
[@@deriving yojson, show {with_path = false}]

type sftype =
| Sordered of ordered_sftype
| Sbool
| Sunit
| Soption of sftype
| Srecord of named_sftype list
| Scontainer of (ordered_sftype * sftype)
[@@deriving yojson, show {with_path = false}]
and named_sftype = string * sftype
[@@deriving yojson, show {with_path = false}]

type sfield = sftype * value
[@@deriving yojson, show {with_path = false}]

type storage = sfield list
[@@deriving yojson, show {with_path = false}]

(* Conversions --------------------------------------------------------------*)

exception ExpectedNbargs of int
exception ExpectedOrdered
exception InvalidPrim

let amtype_to_ordered : amtype -> ordered_mtype = function
| _, Tordered t -> t
| _ -> raise ExpectedOrdered

let get_annot keys json =
if List.mem "annots" keys then
    Some (json |> member "annots" |> to_list |> fun l -> List.nth l 0 |> to_string)
else None

let rec json_to_mtype (json : Safe.t) : amtype =
    let keys= json |> keys in
    if List.mem "prim" keys then
        let prim = json |> member "prim" |> to_string in
        match prim with
        | "pair" -> begin
            match json |> member "args" |> to_list with
            | arg1 :: arg2 :: [] ->
                (None, Tpair (json_to_mtype arg1, json_to_mtype arg2))
            | _ -> raise (ExpectedNbargs 2) end
        | "big_map" | "map" -> begin
            match json |> member "args" |> to_list with
            | arg1 :: arg2 :: [] ->
                (get_annot keys json,
                Tmap (
                    amtype_to_ordered (json_to_mtype arg1),
                    snd (json_to_mtype arg2)))
            | _ -> raise (ExpectedNbargs 2) end
        | "list" -> begin
            match json |> member "args" |> to_list with
            | arg :: [] ->
                (get_annot keys json, Tlist (snd (json_to_mtype arg)))
            | _ -> raise (ExpectedNbargs 1) end
        | "set" -> begin
            match json |> member "args" |> to_list with
            | arg :: [] ->
                (get_annot keys json, Tset (amtype_to_ordered (json_to_mtype arg)))
            | _ -> raise (ExpectedNbargs 1) end
        | "bool" ->
            (get_annot keys json, Tbool)
        | "int" -> (get_annot keys json, Tordered Tint)
        | "nat" -> (get_annot keys json, Tordered Tnat)
        | "string" -> (get_annot keys json, Tordered Tstr)
        | "bytes" -> (get_annot keys json, Tordered Tbytes)
        | "option" -> begin
            match json |> member "args" |> to_list with
            | arg :: [] -> (get_annot keys json, Toption (snd (json_to_mtype arg)))
            | _ -> raise (ExpectedNbargs 1) end
        | "unit" -> (get_annot keys json, Tunit)
        | _ -> raise InvalidPrim
    else raise Not_found

let rec json_to_mvalue json : mvalue =
    print_endline (Safe.to_string json);
    try let _l = to_list json in Munit
    with _ ->
    let keys= json |> keys in
    if List.mem "prim" keys then
        let prim = json |> member "prim" |> to_string in
        match prim with
        | "Pair" -> begin
            match json |> member "args" |> to_list with
            | arg1 :: arg2 :: [] -> Mpair (json_to_mvalue arg1, json_to_mvalue arg2)
            | _ -> raise (ExpectedNbargs 2) end
        | "Elt" -> begin
            match json |> member "args" |> to_list with
            | arg1 :: arg2 :: [] -> Melt (json_to_mvalue arg1, json_to_mvalue arg2)
            | _ -> raise (ExpectedNbargs 2) end
        | "Unit" -> Munit
        | "False" -> Mbool false
        | "True" -> Mbool true
        | _ -> Munit
    else if List.mem "int" keys then
        let i = json |> member "int" |> to_string |> int_of_string in
        Mordered (Mint i)
    else if List.mem "string" keys then
        let s = json |> member "string" |> to_string in
        Mordered (Mstr s)
    else if List.mem "bytes" keys then
        let s = json |> member "bytes" |> to_string |> Bytes.unsafe_of_string in
        Mordered (Mbytes s)
    else Munit

(*---------------------------------------------------------------------------*)

let main () =
  let storage = Safe.from_string storage in
  let storage_type = Safe.from_string storage_type in
  print_endline (Safe.to_string storage);
  print_endline "";
  Format.printf "%a" pp_mvalue (json_to_mvalue storage);
  print_endline "";
  Format.printf "%a" pp_amtype (json_to_mtype storage_type);
  print_endline "";
  print_endline (Safe.to_string storage_type)

let _ = main ()
