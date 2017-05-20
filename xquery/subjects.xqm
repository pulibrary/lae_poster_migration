xquery version "1.0";
module namespace subjects="http://localhost/lae/subjects";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";
declare namespace mets='http://www.loc.gov/METS/';

(: TODO: these are going to have to be parsed out more, because they (or at
 : least the first set) include topical countries, which are geographical
 : subjects in the LAE project, and the remaining subjects need to be mapped
 : to the LAE vocab
 :
 : What's here now just brings them in the doc as-is.
 :)

declare function subjects:subjects_from_doc($doc as document-node())
  as xs:string* {
    let $subjects as xs:string* :=
        for $s in $doc//mods:subject
        return json_helpers:stringify(string-join($s/*, '--'))
    return json_helpers:k-vify('subjects', json_helpers:arrayify($subjects))
};
