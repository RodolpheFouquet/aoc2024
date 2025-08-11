type action =
  | Do
  | Dont

type expr =
  | Multiply of int * int
  | Action of action

let expr_to_string expr = 
  match expr with 
  | Action Do -> "do"
  | Action Dont -> "dont"
  | Multiply (_, _) -> "multiply"

let part1 () = 
  let content = Files.read_file "files/day3.txt" in
  let line = (String.concat "" content) in 
  let pattern = Str.regexp {|mul(\([0-9]+\),\([0-9]+\))|} in
  let rec helper acc index = 
    try
      let _ = Str.search_forward pattern line index in 
      let x = Str.matched_group 1 line |> int_of_string in
      let y = Str.matched_group 2 line |> int_of_string in
      let product = x * y in
      (* Get the end position of the current match *)
      let next_index = Str.match_end () in
      (* Continue with the next match *)
      helper (acc + product) next_index
    with
      Not_found -> acc 
  in
  let result = helper 0 0 in
  Printf.printf "The result of part 1 is %d\n" result

let part2 () = 
  let content = Files.read_file "files/day3.txt" in
  let line = (String.concat "" content) in 
  let pattern = Str.regexp {|mul(\([0-9]+\),\([0-9]+\))\|don't()\|do()|} in
  let rec helper acc last_action index = 
    try
      let _ = Str.search_forward pattern line index in 
      (* Get the end position of the current match *)
      let next_index = Str.match_end () in
      let m = Str.matched_group 0 line in
      match m with 
      | "do()" -> helper acc Do next_index 
      | "don't()" -> helper acc Dont next_index 
      | _ -> (
        let x = Str.matched_group 1 line |> int_of_string in
        let y = Str.matched_group 2 line |> int_of_string in
        let product = match last_action with
        | Do -> x*y
        | Dont -> 0
        in    
        helper (acc+product) last_action next_index
      )
    with
      | Not_found -> acc
  in
  let result = helper 0 Do 0 in
  Printf.printf "The result of part 2 is %d\n" result

(* Tests for expr_to_string function *)
let%test "expr_to_string_do" =
  expr_to_string (Action Do) = "do"

let%test "expr_to_string_dont" =
  expr_to_string (Action Dont) = "dont"

let%test "expr_to_string_multiply" =
  expr_to_string (Multiply (2, 3)) = "multiply"

(* Tests for pattern matching logic *)
let%expect_test "pattern_matching_mul" =
  let test_string = "mul(2,3)" in
  let pattern = Str.regexp {|mul(\([0-9]+\),\([0-9]+\))|} in
  let _ = Str.search_forward pattern test_string 0 in
  let x = Str.matched_group 1 test_string |> int_of_string in
  let y = Str.matched_group 2 test_string |> int_of_string in
  Printf.printf "%d * %d = %d" x y (x * y);
  [%expect {| 2 * 3 = 6 |}]

let%expect_test "pattern_matching_actions" =
  let test_string = "don't()do()" in
  let pattern = Str.regexp {|mul(\([0-9]+\),\([0-9]+\))\|don't()\|do()|} in
  let _ = Str.search_forward pattern test_string 0 in
  let m = Str.matched_group 0 test_string in
  Printf.printf "Found: %s" m;
  [%expect {| Found: don't() |}]

(* Test action matching *)
let%test "action_do_match" =
  let action = Do in
  match action with
  | Do -> true
  | Dont -> false

let%test "action_dont_match" =
  let action = Dont in
  match action with
  | Do -> false
  | Dont -> true

let get_name = (fun () -> "Day 3")