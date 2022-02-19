## Cloudbet Virtual Crypto Casino API Client
## =========================================
##
## .. image:: https://raw.githubusercontent.com/juancarlospaco/cloudbet/nim/cloudbet.jpg
import std/[httpcore, uri, macros]


type
  Cloudbet* = object  ## Cloudbet client object.
    apiKey*: string   ## API Key for the Cloudbet API.

  AcceptPriceChange* {.pure.} = enum
    NONE = "NONE", ALL = "ALL", BETTER = "BETTER"

  Side* {.pure.} = enum
    BACK = "BACK", LAY = "LAY"


const cloudbetApiURL: string = "https://sports-api.cloudbet.com/pub"  ## Cloudbet API URL.


macro unrollEncodeQuery(target: var string; args: openArray[(string, string)]) =
  doAssert args.len > 0, "Iterable must not be empty, because theres nothing to unroll"
  result = newStmtList()
  for i, item in args:
    let key: string = item[1][0].strVal
    doAssert key.len > 0, "Key must not be empty string."
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit(if i == 0: '?' else: '&'))
    for c in key: result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), c.newLit)
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit('='))
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), item[1][1])


macro unrollInternal(target: var string; args: openArray[(string, string)]) =
  result = newStmtList()  # Internal use only.
  result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit('{'))
  for i, item in args:
    let key: string = item[1][0].strVal
    doAssert key.len > 0, "Key must not be empty string."
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit('"'))
    for c in key: result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), c.newLit)
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit('"'))
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit(':'))
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit('"'))
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), item[1][1])
    result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit('"'))
    if i < args.len - 1: result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit(','))
  result.add nnkCall.newTree(nnkDotExpr.newTree(target, newIdentNode"add"), newLit('}'))


template defaultHeaders*(self: Cloudbet): array[3, (string, string)] =
  ## Generate default HTTP Headers, the API uses only `"application/json"` and `"X-API-Key"` so size is fixed for performance.
  [("Content-Type", "application/json"), ("Accept", "application/json"), ("X-API-Key", self.apiKey)]


func newCloudbet*(apiKey: string): Cloudbet =
  assert apiKey.len > 0, "Cloudbet API key must not be empty string."
  Cloudbet(apiKey: apiKey)


proc getSports*(self: Cloudbet): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get list of sports in alphabetical order.
  result = (metod: HttpGet, url: parseUri(static(cloudbetApiURL & "/v2/odds/sports/")), headers: self.defaultHeaders(), body: "")


proc getSport*(self: Cloudbet; sport: string): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get 1 Event, shows all available main markets by default.
  assert sport.len > 0, "Sport must not be empty string."
  result = (metod: HttpGet, url: parseUri(static(cloudbetApiURL & "/v2/odds/sports/") & sport), headers: self.defaultHeaders(), body: "")


proc getCompetition*(self: Cloudbet; competition: string; fromTo: Slice[int]; markets: seq[string]; limit = 50.Positive): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get list of all live and upcoming events of the given competititon key.
  assert markets.len > 0, "Markets key must not be empty seq."
  assert competition.len > 1, "Competition key must not be empty string."
  var url = static(cloudbetApiURL & "/v2/odds/competitions/")
  url.add competition
  unrollEncodeQuery(url, {"limit": $limit, "from": $(fromTo.a), "to": $(fromTo.b)})
  for market in markets:
    url.add "&market="
    url.add market
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc getCompetition*(self: Cloudbet; competition: string; fromTo: Slice[int]; limit = 50.Positive): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get list of all live and upcoming events of the given competititon key.
  assert competition.len > 1, "Competition key must not be empty string."
  assert competition.len > 1, "Competition key must not be empty string."
  var url = static(cloudbetApiURL & "/v2/odds/competitions/")
  url.add competition
  unrollEncodeQuery(url, {"limit": $limit, "from": $(fromTo.a), "to": $(fromTo.b)})
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc getCompetition*(self: Cloudbet; competition: string; limit = 50.Positive): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get list of all live and upcoming events of the given competititon key.
  assert competition.len > 1, "Competition key must not be empty string."
  assert competition.len > 1, "Competition key must not be empty string."
  var url = static(cloudbetApiURL & "/v2/odds/competitions/")
  url.add competition
  unrollEncodeQuery(url, {"limit": $limit})
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc getFixtures*(self: Cloudbet; sport: string; year: 2000..int.high, month: 1..12; day: 1..31; limit = 50.Positive): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get fixtures (i.e. sporting events without markets or metadata) for a given sport on a given date.
  ## Shows live and upcoming fixtures of a given sport for a given date. Note that a "day" counts as 00:00 UTC to 23:59 UTC on the requested date.
  assert sport.len > 0, "Sport must not be empty string."
  var url = static(cloudbetApiURL & "/v2/odds/fixtures")
  unrollEncodeQuery(url, {"sport": sport, "limit": $limit})
  url.add "&date="
  url.addInt year
  url.add '-'
  if month < 10: url.add '0'
  url.addInt month
  url.add '-'
  if day < 10: url.add '0'
  url.addInt day
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc getEvent*(self: Cloudbet; id: uint; market: string): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get 1 Event, shows all available main markets by default.
  assert market.len > 0, "Markets must not be empty string."
  var url = static(cloudbetApiURL & "/v2/odds/events/")
  url.addInt id
  unrollEncodeQuery(url, {"market": market})
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc getEvent*(self: Cloudbet; id: uint): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get 1 Event, shows all available main markets by default.
  var url = static(cloudbetApiURL & "/v2/odds/events/")
  url.addInt id
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc postLine*(self: Cloudbet): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Obtain latest odds for a selection based on market key, outcome and params.
  result = (metod: HttpPost, url: static(parseUri(cloudbetApiURL & "/v2/odds/lines")), headers: self.defaultHeaders(), body: "")


proc getBetHistory*(self: Cloudbet; limit: 1..20 = 20; offset = 0.Natural): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get accepted bet history request with pagination.
  var url = static(cloudbetApiURL & "/v3/bets/history")
  unrollEncodeQuery(url, {"limit": $limit, "offset": $offset})
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc getBetStatus*(self: Cloudbet; referenceId: string): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get bet Status request by Reference ID.
  assert referenceId.len > 0, "referenceId must not be empty string."
  var url = static(cloudbetApiURL & "/v3/bets/")
  url.add referenceId
  url.add "/status"
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


proc bet*(self: Cloudbet; acceptPriceChange: AcceptPriceChange; currency, eventId, marketUrl, referenceId: string; price, stake: float; side: Side): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Place a Bet.
  var bodi: string = ""
  unrollInternal(bodi, {"acceptPriceChange": $acceptPriceChange, "currency": currency, "eventId": eventId, "marketUrl": marketUrl, "referenceId": referenceId, "price": $price, "stake": $stake, "side": $side})
  result = (metod: HttpPost, url: parseUri(cloudbetApiURL & "/v3/bets/place"), headers: self.defaultHeaders(), body: bodi)


proc getAccountCurrencies*(self: Cloudbet): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get a list of all currencies available on the account. Account management handler to show the list of currencies currently active on the account.
  result = (metod: HttpGet, url: parseUri(static(cloudbetApiURL & "/v1/account/currencies")), headers: self.defaultHeaders(), body: "")


proc getAccountInfo*(self: Cloudbet): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get a all account information. Account management handler to show account specific information.
  result = (metod: HttpGet, url: parseUri(static(cloudbetApiURL & "/v1/account/info")), headers: self.defaultHeaders(), body: "")


proc getAccountBalance*(self: Cloudbet; currency: string): tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string] =
  ## Get account balance. Account management handler to show the balance for a requested currency.
  var url = static(cloudbetApiURL & "/v1/account/currencies/")
  url.add currency
  url.add "/balance"
  result = (metod: HttpGet, url: parseUri(url), headers: self.defaultHeaders(), body: "")


runnableExamples:
  import std/[httpcore, uri]
  let client: Cloudbet = newCloudbet(apiKey = "YOUR_CLOUDBET_API_KEY")
  let preparedRequest = client.getSports()
  doAssert preparedRequest is tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string]
