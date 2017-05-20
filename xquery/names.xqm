xquery version "1.0";
module namespace names="http://localhost/lae/names";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mods="http://www.loc.gov/mods/v3";

(:
 : Note: some MODS have [s.n.] in the publisher field. We're not bringing those
 : over. There are no other values for publisher.
 :)

(: TODO: mods:name :)
