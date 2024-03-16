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

- Cloudbet account, get it for free at https://www.cloudbet.com/en/auth/sign-up
- Valid API Key and API Secret, get it for free at https://www.cloudbet.com/en/player/api


# Examples

```nim
import std/[httpcore, uri], cloudbet
let client: Cloudbet = newCloudbet(apiKey = "YOUR_CLOUDBET_API_KEY")
let preparedRequest = client.getSports()
doAssert preparedRequest is tuple[metod: HttpMethod, url: Uri, headers: array[3, (string, string)], body: string]
# Use "preparedRequest" with HttpClient, JsFetch, JsHttpClient, xmlhttprequest, or your favorite HTTP lib, etc...
```

KISS design, only uses `httpcore`, `uri`, `macros` from StdLib, 0 Dependencies.


# Limits

From Cloudbet API Docs:

> When using the API be considerate.
> If the bet rejection rate on the betting API is too high (>75% on your last 100 bets),
> your account will be flagged for abusive behaviour.
> You may get blocked for up to 7 days for integrity checks.
> Bet endpoint has a rate limit of 1 Request per second.


# More about Cloudbet

- https://www.cloudbet.com/en/blog/posts/sports-betting-api-tutorial-with-golang
- https://github.com/Cloudbet
- https://gist.github.com/kgravenreuth/6703e1e213aecac4d5728f2f699d34e7
- https://github.com/Cloudbet/docs/discussions


# More

- See also https://github.com/juancarlospaco/binance#binance
- See also https://github.com/juancarlospaco/tradingview#tradingview


# Stars

![](https://starchart.cc/juancarlospaco/cloudbet.svg)
:star: [@juancarlospaco](https://github.com/juancarlospaco '2022-02-19')
:star: [@luisacosta828](https://github.com/luisacosta828 '2022-02-20')	
:star: [@mrgaturus](https://github.com/mrgaturus '2022-02-20')	
:star: [@Nacho512](https://github.com/Nacho512 '2022-02-20')	
:star: [@AndrielFR](https://github.com/AndrielFR '2022-02-21')	
:star: [@kgravenreuth](https://github.com/kgravenreuth '2022-04-29')	
:star: [@hugosenari](https://github.com/hugosenari '2022-05-28')	
:star: [@novocaine1926](https://github.com/novocaine1926 '2022-06-13')	
:star: [@DaGrizzly1](https://github.com/DaGrizzly1 '2022-07-14')	
:star: [@jpaslay](https://github.com/jpaslay '2023-03-27')	
:star: [@teroz](https://github.com/teroz '2023-05-03')	
:star: [@mackbdev](https://github.com/mackbdev '2023-09-29')	
:star: [@oguzakd](https://github.com/oguzakd '2024-03-16')	
