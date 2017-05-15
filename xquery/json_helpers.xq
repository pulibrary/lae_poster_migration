xquery version "1.0";
module namespace json="http://localhost/json";

declare function json:stringify($s as xs:string?)
  as xs:string {
    let $s := normalize-space($s),
        $s := replace($s, '…', '...'),
        $s := replace($s, '&quot;', '\\&quot;')
    return concat('"', $s, '"')
};

declare function json:arrayify($seq as xs:string*)
  as xs:string {
    concat('[', string-join($seq, ','), ']')
};

(:~
 : This will take care of quoting the key but leaves the value untouched.
 :)
declare function json:k-vify($key as xs:string, $value as xs:string)
  as xs:string {
    concat(json:stringify($key), ' : ', $value)
};

declare function json:objectify($kvs as xs:string*)
  as xs:string {
    concat('{', string-join($kvs, ','), '}')
};
