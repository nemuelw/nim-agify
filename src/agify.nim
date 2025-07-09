import httpclient, jsony, options, results, sequtils, strformat, strutils

const BaseUrl = "https://api.agify.io/?"

type
  AgifyClient* = object
    apiKey*: string
    client*: HttpClient

  Age* = object
    name*: string
    age*: Option[int]
    count*: int
    country_id*: Option[string]

  Error* = object
    error*: string

proc makeRequest[T](self: AgifyClient, url: string): Result[T, string] =
  var url = url
  if self.apiKey.len > 0:
    url = fmt"{url}&apikey={self.apiKey}"

  let response = self.client.request(url)
  let body = response.body
  if response.status != "200 OK":
    let error = body.fromJson(Error)
    return err(error.error)

  return ok(body.fromJson(T))

proc newAgifyClient*(apiKey = ""): AgifyClient =
  ## initialize a new client for interacting with the API
  ##
  ## params:
  ##  `apiKey`: optional API key
  ##
  ## returns:
  ##  `AgifyClient`

  result.apiKey = apiKey
  result.client = newHttpClient()
  result.client.headers = newHttpHeaders({"User-Agent": "agify/0.1.0 (Nim)"})

proc predictAge*(self: AgifyClient, name: string, countryId = ""): Result[Age, string] =
  ## predict the age of a single name
  ##
  ## params:
  ##  `name`: name whose age is to be predicted
  ##  `countryId`: optional country filter to apply
  ##
  ## returns:
  ##  `Result[Age, string]`

  var url = BaseUrl
  url = fmt"{url}name={name}"
  if countryId.len > 0:
    url = fmt"{url}&country_id={countryId}"

  return makeRequest[Age](self, url)

proc predictAges*(self: AgifyClient, names: seq[string], countryId = ""): Result[seq[Age], string] =
  ## predict the ages of a list of names
  ##
  ## params:
  ##  `names`: list of names whose ages are to be predicted
  ##  `countryId`: optional country filter to apply
  ##
  ## returns:
  ##  `Result[seq[Age], string]`

  var url = BaseUrl
  let namesParam = names.mapIt(fmt"name[]={it}").join("&")
  url = fmt"{url}{namesParam}"
  if countryId.len > 0:
    url = fmt"{url}&country_id={countryId}"

  return makeRequest[seq[Age]](self, url)
