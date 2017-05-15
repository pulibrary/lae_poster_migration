xquery version "1.0";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xq';
import module namespace titles="http://localhost/lae/titles" at 'titles.xq';
import module namespace subjects="http://localhost/lae/subjects" at 'subjects.xq';
import module namespace dimensions="http://localhost/lae/dimensions" at 'dimensions.xq';

declare namespace mods='http://www.loc.gov/mods/v3';
declare namespace mets='http://www.loc.gov/METS/';
declare namespace saxon='http://saxon.sf.net/';

declare option saxon:output 'method=text';

declare variable $src_dir as xs:string external;

(: Internal global vars :)
declare variable $collection_params as xs:string := '?select=*.mets';
declare variable $docs
    as document-node()+ := collection(concat($src_dir, $collection_params));

declare function local:process_doc($doc as document-node())
  as xs:string {
    let $kvs as xs:string* := (
        titles:title_from_doc($doc),
        titles:sort_title_from_doc($doc),
        titles:alt_titles_from_doc($doc),
        dimensions:dimensions_from_doc($doc),
        subjects:subjects_from_doc($doc),
        json_helpers:k-vify("language", json_helpers:stringify("spa"))
    )
    return json_helpers:objectify($kvs)
};

declare function local:process_docs($docs as document-node()*)
  as xs:string* {
    for $doc in $docs
    return local:process_doc($doc)
};

declare function local:main($docs as document-node()*)
  as xs:string {
    json_helpers:arrayify(local:process_docs($docs))
};

local:main($docs)

(: distinct-values($docs//mods:languageTerm) :)
(: for $doc in $docs
return concat($doc//mods:extent, ' ', $doc//mods:recordIdentifier, '
') :)
