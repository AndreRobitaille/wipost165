# Visual implementation lessons

Historical summary, distilled on 2026-09-07. Superseded as a specification;
all prior design and implementation choices may be reconsidered.

This pass made declared typography and styles load, introduced shared visual
tokens, and applied a consistent but varied motif across pages. The broader lesson
was to verify rendered assets and actual token use rather than trust declarations.

A static preview helped inspect typography and spacing, but later failed to show
dynamic homepage content. That preview was not evidence that the integrated page
worked. It has been removed along with the theme tooling.

The repeated visual language became more useful when it could be quieter on
secondary pages. The specific assets, selectors, templates, and implementation
sequence have been retired. A new design can solve the hierarchy differently.
