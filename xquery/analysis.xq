xquery version "1.0";

(:
 : Just used for analysis while working on main.xq. Run with ../analyze.sh.
 :)

declare namespace mods='http://www.loc.gov/mods/v3';
declare namespace mets="http://www.loc.gov/METS/";
declare namespace saxon='http://saxon.sf.net/';

declare option saxon:output 'method=text';

declare variable $src_dir as xs:string external;

declare variable $collection_params as xs:string := '?select=*.mets';
declare variable $docs
  as document-node()+ := collection(concat($src_dir, $collection_params));



(: All subject strings :)
(: topic geographic name are the elements used:)

(: declare function local:process-subject($subject_element as element())
  as xs:string {
  normalize-space(string-join($subject_element/*[not(local-name()="geographic")], '--'))
};

let $subjects :=
  for $subject in $docs//mods:subject
  let $normalized_subject := local:process-subject($subject)
  return $normalized_subject
for $s in distinct-values($subjects)
order by $s
return concat('"', $s, '",', "
") :)

distinct-values($docs//mets:fileGrp[@USE="masters"]/count(mets:file))

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
