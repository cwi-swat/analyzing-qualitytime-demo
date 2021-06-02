module Constants

import lang::python::Parse;
import util::FileSystem;
import util::ResourceMarkers;
import Message;
import String;
import IO;
import QualityTimeDemo;

rel[str,loc] constants(set[Module] ms) = { <c, l> | /constant(string(c), _, src=l) := ms, c notin {"", " "}};

rel[str, loc] defDocs(set[Module] ms) 
	= { <c, l> | / /functionDef|asyncFunctionDef/(_, _, [expr(constant(string(c), _, src=l)), *_], _, _, _) := ms}
    + { <c, l> | /classDef(_, _, _, [expr(constant(string(c), _, src=l)), *_], _) := ms}
    + { <c, l> | /\module([expr(constant(string(c), _, src=l)), *_], _) := ms}
    ;
    
rel[str, loc] undocumentedDefs1(set[Module] ms)
    = { <"<n>", l> | / /functionDef|asyncFunctionDef/(n, _, ![expr(constant(string(c), _)), *_], _, _, _, src=l) := ms};
    
rel[str, loc] undocumentedDefs2(set[Module] ms)
    = { <"<n>", l> | / /functionDef|asyncFunctionDef/(n, _, ![expr(constant(string(c), _)), *_], _, _, _, src=l) := ms
      , /__init.*/ !:= "<n>"
      };    
      

    
void reportOnConstants(set[Module] ms) {
    realConstants = constants(ms) - defDocs(ms);
    
    messages = {info("Constant detected: \"<c>\"", l) | <c, l> <- realConstants};
    
    addMessageMarkers(messages);
}   

void removeConstantMarkers(set[Module] ms) {
	realConstants = constants(ms) - defDocs(ms);
    
    fs = {l.top | <_, l> <- realConstants};
    
    for (f <- fs)
        removeMessageMarkers(f);
} 

rel[str,loc] constantsInJSfiles(set[Module] ms) {
    realConstants = constants(ms) - defDocs(ms);
    
   return { <c,f(offset, size(c))> | f <- jsFiles(), <c,_> <- realConstants, offset <- findAll(readFile(f), c)};
}      