# R function for tel.search.ch API

This allows to fetch enteries from Swiss telephone directory [tel.search.ch](https://tel.search.ch/index.en.html).

Returns a tibble (`dplyr`).

[Here's](https://tel.search.ch/api/help.en.html) the API description. The function allows for all of the fields described.

Additionally then `adj_formats` is set to `TRUE` (default), then formats (character, date/times, integers) are set appropriately.

## API Key

Without an API key the output is limited to *title* and *content*. Also tel.search limits the maximum number of results to 10 without a key.

With a key you get separate fields for the street name, street number, telephone number etc. Also the max number of results is 200.

You can request an API key for free [here](https://tel.search.ch/api/getkey.html).
