xquery version "1.0";
module namespace subjects="http://localhost/lae/subjects";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";

(: Missing subjects:
  0028.mets
  0182.mets
  0293.mets
  0399.mets
  0451.mets
  0576.mets
  0577.mets
  0685.mets
  1606.mets
  mx1zp001.mets
  mx1zp002.mets
 :)

 declare variable $subjects:lookup as document-node() := doc('./subjects.xml');

 declare function subjects:subjects($doc as document-node())
   as xs:string* {
     let $subjects as xs:string* :=
       for $poster_subject as element() in $doc//mods:subject
       return subjects:map-and-format-subject($poster_subject)
     return json_helpers:k-vify("subjects", json_helpers:arrayify($subjects))
 };

 declare function subjects:map-and-format-subject($poster_subject as element())
   as xs:string* {
     let $preprocessed-subject as xs:string := subjects:preprocess-subject($poster_subject),
         (: Some subjects were removed :)
         $lae_subject as element()? := subjects:look_up_lae_subject($preprocessed-subject)
     return if ($lae_subject) then subjects:format_lae_subject($lae_subject) else ()
 };

 declare function subjects:preprocess-subject($subject_element as element())
   as xs:string {
   normalize-space(string-join($subject_element/*[not(local-name()="geographic")], '--'))
 };

 declare function subjects:look_up_lae_subject($poster_subject as xs:string)
   as element()? {
     let $row as element() := $subjects:lookup//row[./poster_subject = $poster_subject]
     where not($row//review_note = "eliminate")
     return $row
 };

 declare function subjects:format_lae_subject($subject as element())
  as xs:string+ {
    for $topic in $subject//lae_topic
    let $category as xs:string := string($subject//lae_category),
        $category_string as xs:string := json_helpers:stringify($category),
        $topic_string as xs:string := json_helpers:stringify(string($topic))
    return
      json_helpers:objectify((
        json_helpers:k-vify("category", $category_string),
        json_helpers:k-vify("topic", $topic_string)
      ))

 };
