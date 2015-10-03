![Build Status](https://travis-ci.org/Jtfinlay/BrewClub.svg?branch=master)
![Coverage](https://codecov.io/github/Jtfinlay/BrewClub/coverage.svg?precision=0)

# Brew Club

It is hard to remember the beers you've drank. Real hard. And what is even more difficult is trying to figure out which beers none of your friends have had either. Because life is about trying new things. Life's about chasing down that rare White IPA. Life is about sharing a drink made from [roasting whale testicles over sheep dung][2]. Life is about chasing after just one more Untappd achievement.

This application aims to not only determine which beers you and your friends have shared - but to dig through the catalogue of a nearby beer store so that you can determine which beers to get next. Because life is too short to pick and choose - let the software do that for you.

## I don't get it

Alright, this application has three parts.

#### Part 1

Use the Untappd API to pull the distinct check ins of you and your friends. Then merge them. Easy peasy. *FYI, you will have to beg Untappd for an API key & secret first.*

#### Part 2

Have a web crawler go through the beer store's website and pull all the beer metadata. If your local beer store is [TotalWine][1], then you're in luck! If not, you need to make your own crawler. Or ask me to make it, which you can do by first ordering me a nice set of beers from [TotalWine][1].

#### Part 3

Apply a bunch of filters, compare the store catalogue to your check ins, and voila! Beer to your doorstep*.


*Assuming the beer store does delivery

## Get Started

You can run it yourself! All you need is an Untappd Client/Key, and a touch of ruby

```shell
$ git clone git://github.com/Jtfinlay/BeerClub.git
$ bundle
$ rake run
```

Deploy away. Uses SQLite, so no DB setup required.

[1]: http://www.totalwine.com
[2]: http://www.bbc.com/news/blogs-news-from-elsewhere-30777516


