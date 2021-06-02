module Methods

import lang::python::AST;
import QualityTimeDemo;

rel[str, loc] methodDefs(set[Module] ms)
  = { <n, l> | /classDef(_, _, _, [*_, functionDef(n, _, _, _, _, _), *_], _) := ms};
  