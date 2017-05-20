xquery version "1.0";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';
import module namespace titles="http://localhost/lae/titles" at 'titles.xqm';
import module namespace ids="http://localhost/lae/ids" at 'identifiers.xqm';
import module namespace names="http://localhost/lae/names" at 'names.xqm';
import module namespace files="http://localhost/lae/files" at 'files.xqm';
import module namespace geo="http://localhost/lae/geo" at 'geo.xqm';
import module namespace dates="http://localhost/lae/dates" at 'dates.xqm';
import module namespace subjects="http://localhost/lae/subjects" at 'subjects.xqm';
import module namespace dimensions="http://localhost/lae/dimensions" at 'dimensions.xqm';

declare namespace saxon='http://saxon.sf.net/';

declare option saxon:output 'method=text';

declare variable $src_dir as xs:string external;

declare variable $collection_arg as xs:string := concat($src_dir, '?select=*.mets');
declare variable $docs as document-node()+ := collection($collection_arg);

declare function local:process_doc($doc as document-node())
  as xs:string {
    let $kvs as xs:string* := (
        ids:ids($doc),
        titles:title($doc),
        titles:sort_title($doc),
        titles:alt_titles($doc),
        names:names($doc),
        geo:origin($doc),
        dates:date($doc),
        dimensions:dimensions($doc),
        geo:subject($doc),
        subjects:subjects($doc),
        json_helpers:k-vify("language", json_helpers:stringify("spa")),
        files:files($doc)
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
