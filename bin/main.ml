module DayRunner (D : Day.DAY) = struct
  let run () =
    let () = Printf.printf "\n####################\n" in 
    let () = Printf.printf "Executing: %s,Part 1\n" (D.get_name ()) in 
    let () = D.part1 () in 
    let () = Printf.printf "Executing: %s,Part 2\n" (D.get_name ()) in 
    D.part2 ()
end

let () =  
  let days : (module Day.DAY) list = [
    (module Day1);
    (module Day2);
    (module Day3);
  ] in 
  List.iter (fun (module D : Day.DAY) ->
    let module Runner = DayRunner(D) in
    Runner.run ()
  ) days