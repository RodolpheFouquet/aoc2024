type report =
  | Safe
  | Unsafe
  
type evolution = 
  | Increasing
  | Decreasing
  | OutOfBounds

let to_evolution a b =
  match compare a b with
  | n when n > 0 && a-b <=3 ->  Decreasing
  | n when n < 0 && b-a <= 3 -> Increasing
  | _ -> OutOfBounds

let report_to_string report = 
  match report with
  | Safe -> "Safe"
  | Unsafe -> "Unsafe"

(* I could only generate the list before and after the element causing an issue, but too lazy *)
let sublists_with_one_removed list =  
  let rec helper prefix rest = 
    match rest with
    | [] -> []
    | x :: xs -> (List.rev_append prefix xs) :: (helper (x :: prefix) xs)
  in
  helper [] list

let safe_or_unsafe numbers =
  let rec safe_or_unsafe_rec current rest state =
    match rest with
    | [] -> Safe
    | next :: r -> (
      match to_evolution current next with 
      | OutOfBounds -> Unsafe
      | s when s = state -> safe_or_unsafe_rec next r s
      | s when s <> state -> Unsafe
      | _ -> Safe
  
    )
  in
  match numbers with 
  | current :: next :: rest -> safe_or_unsafe_rec next rest (to_evolution current next)
  | _ -> failwith "this should not happen"

  let safe_or_unsafe_with_removals numbers =
    let sublist_helpers = 
      let sublists = sublists_with_one_removed numbers in
      let reports = List.map (fun s -> safe_or_unsafe s) sublists in 
      List.exists (fun r -> r = Safe) reports 
    in
    let rec safe_or_unsafe_rec current rest state num_of_removals =
      match rest with
      | [] -> Safe
      | next :: r -> (
        match to_evolution current next with 
        | s when s = state -> safe_or_unsafe_rec next r s 0
        | s when s <> state || s =  OutOfBounds -> (
          if num_of_removals = 1 then
            Unsafe
          else 
            if sublist_helpers then Safe else Unsafe
        )
        | _ -> Safe
    
      )
    in
    match numbers with 
    | current :: next :: rest -> safe_or_unsafe_rec next rest (to_evolution current next) 0
    | _ -> failwith "this should not happen"

let part1 () = 
  let filename = "files/day2.txt" in 
  let lines = Files.read_file filename in
  let splitted_lines = List.map(fun line -> String.split_on_char ' ' line) lines in
  (* we do not care about int_of_string, it cannot fail in our case*)
  let numbers = List.map(fun splitted -> List.map (fun  splitted -> int_of_string splitted) splitted) splitted_lines in
  let reports = List.map(fun nums -> safe_or_unsafe nums) numbers in
  let sum = List.fold_left (fun acc r -> acc + (if r = Safe then 1 else 0)) 0 reports in 
  Printf.printf "The result of part 1 is %d\n" sum

let part2 () =   
  let filename = "files/day2.txt" in 
  let lines = Files.read_file filename in
  let splitted_lines = List.map(fun line -> String.split_on_char ' ' line) lines in
  (* we do not care about int_of_string, it cannot fail in our case*)
  let numbers = List.map(fun splitted -> List.map (fun  splitted -> int_of_string splitted) splitted) splitted_lines in
  let reports = List.map(fun nums -> safe_or_unsafe_with_removals nums) numbers in
  let sum = List.fold_left (fun acc r -> acc + (if r = Safe then 1 else 0)) 0 reports in 
  Printf.printf "The result of part 2 is %d\n" sum
let get_name = (fun () -> "Day 2")