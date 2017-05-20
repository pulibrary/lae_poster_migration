xquery version "1.0";
module namespace names="http://localhost/lae/names";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets='http://www.loc.gov/METS/';
(:
 : Note: some MODS have [s.n.] in the publisher field. We're not bringing those
 : over. There are no other values for publisher.
 :)

declare function names:names($doc as document-node())
as xs:string? {
  let $names as xs:string* :=
    for $name_element as element() in $doc//mods:mods/mods:name
    let $established as xs:boolean := exists($name_element/@authority),
        $name as xs:string := json_helpers:stringify($name_element/mods:namePart/string()), (: There's only ever one :)
        $kvs as xs:string+ := (
          json_helpers:k-vify('label', string($name)),
          json_helpers:k-vify('established', string($established))
        )
    return json_helpers:objectify($kvs)
  return if (empty($names)) then ()
  else json_helpers:k-vify("names", json_helpers:arrayify($names))
};
