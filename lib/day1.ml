let rec get_pairs lines l1 l2 =
  match lines with
  | [] -> (l1, l2)
  | line :: rest -> (
    let (first, second) = Scanf.sscanf line "%d %d" (fun num1 num2 -> (num1, num2)) in
    get_pairs rest (first :: l1) (second :: l2) 
  )

module IntMap = Map.Make(struct
  type t = int
  let compare = compare
end)
  
let part2 () =
  let filename = "files/day1.txt" in
  let lines = Files.read_file filename in
  let (first, second) = get_pairs lines [] [] in
  let differences = List.map2 (fun a b -> Int64.abs (Int64.sub (Int64.of_int b) (Int64.of_int a)) ) (List.sort compare first) (List.sort compare second) in
  let sum_of_differences = List.fold_left Int64.add Int64.zero differences in
  Printf.printf "The result is %Ld\n" sum_of_differences

let count_occurrences numbers =
  let update_count map key =
    let count = match IntMap.find_opt key map with
      | Some c -> c + 1 (* Increment the count if the key exists *)
      | None -> 1       (* Initialize to 1 if the key is not present *)
    in
    IntMap.add key count map
  in
  List.fold_left update_count IntMap.empty numbers

let compute_value map =
  let func acc value =
    match IntMap.find_opt value map with
    | Some c -> c * value + acc
    | None -> acc
  in
  func


(* Tests for get_pairs function *)
let%test "get_pairs_empty_list" = 
  get_pairs [] [] [] = ([], [])

let%test "get_pairs_single_line" =
  get_pairs ["3   4"] [] [] = ([3], [4])

let%test "get_pairs_multiple_lines" =
  get_pairs ["1   2"; "3   4"] [] [] = ([3; 1], [4; 2])

(* Tests for count_occurrences function *)
let%test "count_occurrences_empty" =
  IntMap.is_empty (count_occurrences [])

let%test "count_occurrences_single" =
  let map = count_occurrences [5] in
  IntMap.find 5 map = 1

let%test "count_occurrences_duplicates" =
  let map = count_occurrences [3; 4; 3; 3] in
  IntMap.find 3 map = 3 && IntMap.find 4 map = 1

(* Tests for compute_value function *)
let%test "compute_value_found" =
  let map = IntMap.add 5 3 IntMap.empty in
  let func = compute_value map in
  func 0 5 = 15 (* 5 * 3 + 0 *)

let%test "compute_value_not_found" =
  let map = IntMap.empty in
  let func = compute_value map in
  func 10 5 = 10 (* not found, return acc *)

let get_name () = "Day 1"

let part1 () =
  let filename = "files/day1.txt" in
  let lines = Files.read_file filename in
  let (first, second) = get_pairs lines [] [] in
  let counts = count_occurrences second in
  let sum = List.fold_left (compute_value counts) 0 first in 
  Printf.printf "The result is %d\n" sum