; ka-reader's own Python highlights. Capture names are the five token classes and no others.
; DESIGN.md § Colors, Code: keywords, strings, numbers, comments and names (functions, keys, tags).
; Punctuation, operators and everything else are left uncaptured, so they get no span.

(comment) @comment
(string) @string
[(integer) (float)] @number

[(none) (true) (false)] @keyword
[
  "and" "as" "assert" "async" "await" "break" "case" "class" "continue" "def" "del" "elif" "else"
  "except" "finally" "for" "from" "global" "if" "import" "in" "is" "lambda" "match" "nonlocal" "not"
  "or" "pass" "raise" "return" "try" "while" "with" "yield"
] @keyword

(function_definition name: (identifier) @name)
(class_definition name: (identifier) @name)
(call function: (identifier) @name)
(call function: (attribute attribute: (identifier) @name))
(decorator (identifier) @name)
