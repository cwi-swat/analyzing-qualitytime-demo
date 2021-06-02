module QualityTimeDemo

import lang::python::Parse;
import util::FileSystem;

loc qualityTimeProject = |project://quality-time|;

set[Module] parseQualityTimeProject() = { parsePythonModule(m) | /loc m <- crawl(qualityTimeProject), m.extension == "py" };

    
set[loc] jsFiles() = { l | /loc l := crawl(qualityTimeProject), l.extension == "js"};