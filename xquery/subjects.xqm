xquery version "1.0";
module namespace subjects="http://localhost/lae/subjects";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";

(: TODO: these are going to have to be mapped to the LAE vocab. Rewrite the
 : local:process-subject function once we have a mapping
 :)

declare function subjects:subjects($doc as document-node())
  as xs:string* {
    let $subjects as xs:string* :=
        for $subject as element() in $doc//mods:subject
        let $normalized as xs:string := subjects:process-subject($subject)
        return json_helpers:stringify($normalized)
    return json_helpers:k-vify('subjects', json_helpers:arrayify($subjects))
};

declare function subjects:process-subject($subject_element as element())
  as xs:string {
  normalize-space(string-join($subject_element/*[not(local-name()="geographic")], '--'))
};
