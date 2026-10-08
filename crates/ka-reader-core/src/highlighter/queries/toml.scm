; ka-reader's own TOML highlights. Capture names are the five token classes and no others.
; A key is captured on its own node, never on the whole `pair`, so its value and trailing comment
; keep their own classes. Punctuation and operators get no span.

(comment) @comment
(string) @string
[(integer) (float)] @number
(boolean) @keyword
[(offset_date_time) (local_date_time) (local_date) (local_time)] @number

(bare_key) @name
(quoted_key) @name
