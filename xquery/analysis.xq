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
(: for $s in distinct-values($docs//mods:geographic)
order by $s
return concat($s, "
") :)

let $counts :=
  for $doc in $docs
  return count(distinct-values($doc//mods:geographic))
return distinct-values($counts)

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
