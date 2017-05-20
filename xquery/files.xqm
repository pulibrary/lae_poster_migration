xquery version "1.0";
module namespace files="http://localhost/lae/files";

import module namespace json_helpers='http://localhost/json' at 'json_helpers.xqm';

declare namespace mets='http://www.loc.gov/METS/';
declare namespace xlink="http://www.w3.org/1999/xlink";

declare function files:files($doc as document-node()) as xs:string {
  let $files as xs:string* :=
    for $file as element() in $doc//mets:fileGrp[@USE="masters"]/mets:file
    return files:process_file($file)
  return json_helpers:k-vify("files", json_helpers:arrayify($files))
};

declare function files:process_file($file as element()) as xs:string {
  let $sha1 as xs:string := string($file/@CHECKSUM),
      $path as xs:string := files:clean_path($file/mets:FLocat/@xlink:href),
      $kvs as xs:string* := (
        json_helpers:k-vify("sha1", json_helpers:stringify($sha1)),
        json_helpers:k-vify("path", json_helpers:stringify($path))
      )
  return json_helpers:objectify($kvs)
};

declare function files:clean_path($path as xs:string) as xs:string {
  replace($path, "file:///mnt/diglibdata/pudl/", "pudl_root:")
};
