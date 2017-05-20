xquery version "1.0";
module namespace dimensions="http://localhost/lae/dimensions";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets='http://www.loc.gov/METS/';

(: TODO: these are going to have to be parsed out more, because they include
 : topical countries, which are geographical dimensions in the LAE project, and
 : the remaining dimensions need to be mapped to the LAE vocab
 :
 : What's here now just brings them in the doc as-is.
 :)

declare function dimensions:dimensions($doc as document-node())
  as xs:string* {
    let $extent as xs:string? := normalize-space($doc//mods:extent/string()),
        $tokens as xs:string+ := dimensions:tokenize($extent),
        $obj as xs:string := json_helpers:objectify((
          json_helpers:k-vify('width', string($tokens[1])),
          json_helpers:k-vify('height', replace(string($tokens[2]), ' cm\.', ''))
        ))
    return json_helpers:k-vify('dimensions', $obj)
};

(: There are a handful (< 5 from what I can tell) of oddball dimensions in the
 : data, mostly from typos or missing data. This logic lets those few pass
 : through.
 :)
declare function dimensions:tokenize($extent as xs:string?) as xs:string+ {
  if ($extent) then
    if (matches($extent, '^\d+')) then
      if (contains($extent, ' × ' )) then
          tokenize($extent, ' × ' )
      else
          tokenize($extent, ' x ')
    else
      ('"Unknown"', '"Unknown"')
  else
    ('"Unknown"', '"Unknown"')
};
