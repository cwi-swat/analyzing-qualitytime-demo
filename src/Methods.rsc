module Methods

import lang::python::AST;
import QualityTimeDemo;
import vis::Figure;
import vis::Render;
import IO;

rel[str, loc] methodDefs(set[Module] ms)
  = { <n, l> | /classDef(_, _, _, [*_, /asyncFunctionDef|functionDef/(str n, _, _, _, _, _, src=l), *_], _) := ms};
  
rel[str caller, loc callerLoc, str call, loc callLoc] methodCalls(set[Module] ms)
  = { <caller, callerLoc, call, callLoc> | / /asyncFunctionDef|functionDef/(caller, _,/call(attribute(_,call,_), _, _,src=callLoc), _, _, _, src=callerLoc) := ms};
  
  
rel[str, str] callRelation(set[Module] ms) = methodCalls(ms)<caller, call>;

  
void callGraph(set[Module] ms) {
   calls = methodCalls(ms);
   defs = methodDefs(ms);
   
   nodes = [ box(text(n), id(n), size(50), fillColor("green"))   | <n, _> <- defs ];
   edges = [ edge(from, to) | <from, _, to, _> <- calls ];
   
   render(graph(nodes, edges, hint("layered"), gap(10)));
}  

void callGraph2(set[Module] ms) {
  calls = methodCalls(ms);
  defs = methodDefs(ms);
   
  gr = "digraph PythonCalls {
       '
       '<for (<n, _> <- defs) {>N_<n> [label=\"<n>\"]
       '<}>
       '
       '<for (<from, _, to, _> <- calls) {>
       '  N_<from> -\> N_<to>
       '<}>
       '}";
          
  writeFile(|home:///callGraph.dot|, gr);
}
  