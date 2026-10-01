; nozoki's own shell highlights. Capture names are the five token classes and no others.
; Punctuation, operators and everything else are left uncaptured, so they get no span.

(comment) @comment
[(string) (raw_string) (heredoc_body)] @string
(file_descriptor) @number

[
  "case" "do" "done" "elif" "else" "esac" "export" "fi" "for" "function" "if" "in" "select" "then"
  "unset" "until" "while"
] @keyword

(command_name) @name
(function_definition name: (word) @name)
