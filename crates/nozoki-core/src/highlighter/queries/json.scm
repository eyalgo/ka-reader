; nozoki's own JSON highlights. Capture names are the five token classes and no others.
; A node takes the capture of the LAST pattern that matches it, so a key's `name` pattern comes
; after the `string` pattern it refines. Structural punctuation is uncaptured and gets no span.

(comment) @comment
(string) @string
(number) @number
[(null) (true) (false)] @keyword

(pair key: (string) @name)
