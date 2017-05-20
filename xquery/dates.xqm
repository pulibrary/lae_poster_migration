xquery version "1.0";
module namespace dates="http://localhost/lae/dates";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";

(:
 : All mods have 0 or 1 date
 :)
declare function dates:date($doc as document-node())
  as xs:string? {
    let $date as xs:string? := dates:normalize-date($doc//mods:dateIssued/string())
    return if (not($date)) then ()
    else json_helpers:k-vify('date', json_helpers:stringify($date))
};

declare function dates:normalize-date($date as xs:string?)
  as xs:string? {
    if (not($date) or $date = "[n.d.]") then "Unknown"
    else replace($date, "[\[\]]", "")

};
