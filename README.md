# Cloudbet Virtual Crypto Casino API Client

![](https://raw.githubusercontent.com/juancarlospaco/cloudbet/nim/cloudbet.jpg)

![](https://github.com/juancarlospaco/cloudbet/actions/workflows/build.yml/badge.svg)
![](https://img.shields.io/github/languages/top/juancarlospaco/cloudbet?style=for-the-badge)
![](https://img.shields.io/github/stars/juancarlospaco/cloudbet?style=for-the-badge)
![](https://img.shields.io/github/languages/code-size/juancarlospaco/cloudbet?style=for-the-badge)
![](https://img.shields.io/github/issues-raw/juancarlospaco/cloudbet?style=for-the-badge)
![](https://img.shields.io/github/issues-pr-raw/juancarlospaco/cloudbet?style=for-the-badge)
![](https://img.shields.io/github/last-commit/juancarlospaco/cloudbet?style=for-the-badge)


# Requisites

- Valid API Key and API Secret, get it for free at https://www.cloudbet.com/en/player/api


# Examples

```nim
import std/[httpcore, uri], cloudbet
let client: Cloudbet = newCloudbet(apiKey = "YOUR_CLOUDBET_API_KEY")
let preparedRequest = client.getSports()
doAssert preparedRequest is tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string]
# Use "preparedRequest" with HttpClient, JsFetch, JsHttpClient, xmlhttprequest, our your favorite HTTP lib, etc...
```

KISS design, only uses `httpcore`, `uri`, `macros` from StdLib.


# More

- See also https://github.com/juancarlospaco/binance#binance
- See also https://github.com/juancarlospaco/tradingview#tradingview


# Stars

![](https://starchart.cc/juancarlospaco/cloudbet.svg)
:star: [@juancarlospaco](https://github.com/juancarlospaco '2022-02-19')
