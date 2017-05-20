# Latin American Posters Export Utility

Format the Latin American Poster Metadata to a simple JSON structure for import into Plum.

**Note:** You need to install [`jq`](https://stedolan.github.io/jq/). `brew install jq` should do it.

Saxon is used for xquery execution, but is already included in the repo and should work transparently as long as you have a recent version of Java on your `PATH`.

There are two scripts that can be run:
 * `run.sh` will run the main XQuery and dump the json to stdout (an argument will save the output to a file instead)
 * `analyze.sh` runs `xquery/analysis.xq`, which is just there for ad-hoc analysis while building out the migration.

Output is an array of JSON objects similar to this:

```javascript
{
  "title": "\"El Quijote los niños\"",
  "sort_title": "quijote los niños",
  "alt_titles": [
    "\"Aunque no estoy para estas lides, bailemos Sancho con los niños\""
  ],
  "names": [
    {
      "label": "Central de Trabajadores Argentinos",
      "established": true // If the name is from the NAF
    }
  ],
  "geo_origin": "Argentina",
  "date": "2000",
  "dimensions": {
    "width": 46,
    "height": 32
  },
  "subjects": [ // See below; more top do
    "Labor unions",
    "Politics, activism and advocacy",
    "Labor unions--Political activity"
  ],
  "language": "spa",
  "files": [
    {
      "sha1": "991d6314d4e12dbb4ea65206b7a14d7c6f5fb1a5",
      "path": "pudl_root:pudl0025/02/0533/00000001.tif"
    },
    {
      "sha1": "7e181e7fedbb675ac048157dd0f106fabc10ae3a",
      "path": "pudl_root:pudl0025/02/0533/00000002.tif"
    }
  ]
}
```

Subject headings still need mapping to the LAE vocabulary. That work is happening [here](
https://docs.google.com/spreadsheets/d/1KW5JYdhgade6V6JUzl1H69-1BMHxhMGJXyVBLPEtKkM/edit?ts=59208e93#gid=0)
