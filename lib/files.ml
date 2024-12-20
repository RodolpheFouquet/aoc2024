let read_file filename =
  try
    (* Open the file *)
    let in_channel = open_in filename in

    (* Define a function to read lines recursively *)
    let rec read_lines acc =
      try
        (* Read the next line and add it to the accumulator *)
        let line = input_line in_channel in
        read_lines (line :: acc)
      with
      | End_of_file ->
          (* End of file reached; close the file and return the lines *)
          close_in in_channel;
          List.rev acc
    in
    read_lines []  (* Start reading lines with an empty accumulator *)

  with
  | Sys_error err ->
      (* Handle file-related errors *)
      Printf.eprintf "Error: %s\n" err;
      []
