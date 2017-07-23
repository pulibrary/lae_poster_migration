xquery version "1.0";

(:
 : Just used for analysis while working on main.xq. Run with ../analyze.sh.
 :)

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods='http://www.loc.gov/mods/v3';
declare namespace mets="http://www.loc.gov/METS/";
declare namespace saxon='http://saxon.sf.net/';

declare option saxon:output 'method=text';

declare variable $src_dir as xs:string external;
declare variable $collection_params as xs:string := '?select=*.mets';
declare variable $docs as document-node()+ := collection(concat($src_dir, $collection_params));
declare variable $subject_lookup as document-node() := doc('./subjects.xml');

declare function local:subjects($doc as document-node())
  as xs:string* {
    let $subjects as xs:string* :=
        for $subject as element() in $doc//mods:subject
        let $poster_subject as xs:string := local:preprocess-subject($subject),
            $subject_object as xs:string := local:lookup($poster_subject)

        return $subject_object
    return json_helpers:objectify(
      json_helpers:k-vify('subjects', json_helpers:arrayify($subjects))
    )
};

declare function local:preprocess-subject($subject_element as element())
  as xs:string {
  normalize-space(string-join($subject_element/*[not(local-name()="geographic")], '--'))
};

declare function local:lookup($poster_subject as xs:string)
  as xs:string {
    let $row as element() :=  $subject_lookup//row[./poster_subject = $poster_subject],
        $category as xs:string := $row/lae_category/string()
    where $category != "" (: there are a handful that were marked to "eliminate; they do not have mappings":)
    return json_helpers:objectify((
      json_helpers:k-vify("category", json_helpers:stringify($poster_subject))
    ))
};


for $doc in $docs
let $subjects := local:subjects($doc)
return $subjects

(: for $row in $subject_lookup//row
let $s := $row/poster_subject
let $val_count := count($subject_lookup//poster_subject[. = $s])
where $val_count > 1
return $s :)


(: All subject strings :)
(: topic geographic name are the elements used:)


(: let $subjects :=
  for $subject in $docs//mods:subject
  let $normalized_subject := local:preprocess-subject($subject)
  return $normalized_subject

for $s in distinct-values($subjects)
where empty($subject_lookup//poster_subject[. = $s])
return $s :)

(: distinct-values($docs//mets:fileGrp[@USE="masters"]/count(mets:file)) :)

(: return count(distinct-values($subjects)) :)

(: for $doc in $docs
where exists($doc//mods:subject/mods:name)
return $doc//mods:recordIdentifier :)

(: distinct-values($docs//mods:originInfo/*/local-name()) :)
(: for $place in distinct-values($docs//mods:placeTerm)
order by $place
return concat($place, "
") :)

(: for $doc in $docs
let $place := $doc//mods:placeTerm
where empty($place)
return $doc//mods:recordIdentifier :)
(: place publisher dateIssued :)
