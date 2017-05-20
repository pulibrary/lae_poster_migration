xquery version "1.0";
module namespace titles="http://localhost/lae/titles";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xq';

declare namespace mods="http://www.loc.gov/mods/v3";

declare function titles:title_from_doc($doc as document-node())
  as xs:string {
    let $title_s := string-join($doc//mods:mods/mods:titleInfo[position()=1]/*, ' ')
    return json_helpers:k-vify('title', json_helpers:stringify($title_s))
};

(:
 : TODO: Seems like a lot of titles are missing nonSorts--could try to make
 : these better
:)
declare function titles:sort_title_from_doc($doc as document-node())
  as xs:string {
    let $title_s := $doc//mods:mods/mods:titleInfo[position()=1]/mods:title
    return json_helpers:k-vify('sort_title', json_helpers:stringify($title_s))
};

(: Note, the whole set seems to have only one alt title! :)
declare function titles:alt_titles_from_doc($doc as document-node())
  as xs:string* {
    let $alts :=
        for $t in $doc//mods:mods/mods:titleInfo[position()>1]
        return json_helpers:stringify(string-join($t/*, ' '))
    return if ($alts) then
      json_helpers:k-vify('alt_titles', json_helpers:arrayify($alts))
    else ()
};
