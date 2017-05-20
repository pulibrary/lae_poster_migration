xquery version "1.0";
module namespace geo="http://localhost/lae/geo";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets='http://www.loc.gov/METS/';

declare function geo:origin($doc as document-node()) as xs:string {
  let $place as xs:string := geo:strip_brackets($doc//mods:placeTerm/string())
  return json_helpers:k-vify("geo_origin", json_helpers:stringify($place))
};

declare function geo:strip_brackets($s as xs:string) as xs:string {
  replace($s, "[\[\]]", "")
};
