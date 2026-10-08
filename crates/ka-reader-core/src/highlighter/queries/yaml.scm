; ka-reader's own YAML highlights. Capture names are the five token classes and no others.
; A node takes the capture of the LAST pattern that matches it, so a key's `name` patterns come
; after the `string` pattern they refine. Punctuation and document markers get no span.

(comment) @comment
[(double_quote_scalar) (single_quote_scalar) (block_scalar) (string_scalar)] @string
[(integer_scalar) (float_scalar)] @number
[(boolean_scalar) (null_scalar)] @keyword

(block_mapping_pair
  key: (flow_node [(double_quote_scalar) (single_quote_scalar)] @name))
(block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @name)))
(flow_mapping
  (_ key: (flow_node [(double_quote_scalar) (single_quote_scalar)] @name)))
(flow_mapping
  (_ key: (flow_node (plain_scalar (string_scalar) @name))))
