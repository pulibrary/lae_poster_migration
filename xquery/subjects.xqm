xquery version "1.0";
module namespace subjects="http://localhost/lae/subjects";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";

declare variable $subject_lookup as document-node() := doc('./subjects.xml')

(: TODO: these are going to have to be mapped to the LAE vocab. Rewrite the
 : local:process-subject function once we have a mapping
 :)

declare function subjects:subjects($doc as document-node())
  as xs:string* {
    let $subjects as xs:string* :=
        for $subject as element() in $doc//mods:subject
        let $lookup_str as xs:string := subjects:preprocess-subject($subject)
        return json_helpers:stringify($normalized)
    return json_helpers:k-vify('subjects', json_helpers:arrayify($subjects))
};

declare function subjects:preprocess-subject($subject_element as element())
  as xs:string {
  normalize-space(string-join($subject_element/*[not(local-name()="geographic")], '--'))
};

declare function subjects:lookup($poster_subject as xs:string)
  as xs:string {
    let $row as element() :=  $subject_lookup//row[./poster_subject = $poster_subject]

};
