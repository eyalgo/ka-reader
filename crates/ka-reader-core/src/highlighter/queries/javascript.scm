; ka-reader's own JavaScript highlights. Capture names are the five token classes and no others.
; Punctuation, operators and everything else are left uncaptured, so they get no span.

(comment) @comment
[(string) (template_string) (regex)] @string
(number) @number

[(this) (super) (true) (false) (null) (undefined)] @keyword
[
  "as" "async" "await" "break" "case" "catch" "class" "const" "continue" "debugger" "default"
  "delete" "do" "else" "export" "extends" "finally" "for" "from" "function" "get" "if" "import" "in"
  "instanceof" "let" "new" "of" "return" "set" "static" "switch" "throw" "try" "typeof" "var" "void"
  "while" "with" "yield"
] @keyword

(function_declaration name: (identifier) @name)
(function_expression name: (identifier) @name)
(class_declaration name: (identifier) @name)
(method_definition name: (property_identifier) @name)
(call_expression function: (identifier) @name)
(call_expression function: (member_expression property: (property_identifier) @name))
(pair key: (property_identifier) @name)
(jsx_opening_element name: (identifier) @name)
(jsx_closing_element name: (identifier) @name)
(jsx_self_closing_element name: (identifier) @name)
