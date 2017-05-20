xquery version "1.0";
module namespace ids="http://localhost/lae/ids";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets='http://www.loc.gov/METS/';

declare function ids:ids($doc as document-node()) as xs:string {
  json_helpers:k-vify("ids", json_helpers:objectify((
    json_helpers:k-vify("ark", json_helpers:stringify(ids:ark($doc))),
    json_helpers:k-vify("pudl", json_helpers:stringify(ids:pudl($doc)))
  )))
};

declare function ids:ark($doc as document-node()) as xs:string {
  string($doc/mets:mets/@OBJID)
};

declare function ids:pudl($doc as document-node()) as xs:string? {
  replace($doc//mets:metsDocumentID, "\.mets", "")
};
