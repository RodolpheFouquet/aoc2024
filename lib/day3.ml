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
  Printf.printf "The result is %d\n" result

let part2 = (fun () -> print_endline "part 2")
let get_name = (fun () -> "Day 3")