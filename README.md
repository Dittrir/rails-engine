# Rails-Engine Lite: Turing 2110 BE Mod 3
[![GitHub commits](https://badgen.net/github/commits/Dittrir/rails-engine)](https://GitHub.com/Naereen/StrapDown.js/commit/)
![languages](https://img.shields.io/github/languages/top/Dittrir/rails-engine?color=red)
![rspec](https://img.shields.io/gem/v/rspec?color=blue&label=rspec)
![simplecov](https://img.shields.io/gem/v/simplecov?color=blue&label=simplecov) <!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/contributors-1-orange.svg?style=flat)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

## Description
Rails-engine is an application developed to mimic an E-Commerce Application. The plan was to structure this in a service-oriented architecture, meaning the front and back ends of this application are separate and communicate via APIs. My job was to expose the data that powers the site through an API that the front end will consume.

## Learning Goals 
- Expose an API
- Use serializers to format JSON responses
- Test API exposure
- Use SQL and AR to gather data

## Local Setup
1. Fork and Clone the repo 
```shell
$ it clone git@github.com:Dittrir/rails-engine.git
```
2.  Navigate to directory 
```shell
$ cd viewing_party_lite
```
3. Install gem packages:
```shell
$ bundle install
```
4. Update gem packages: 
```shell
$ bundle update
```
5. Set up the schema: 
```shell
$ rails db:schema:dump
```
6. SRun the migrations: 
```shell
$ rake db:{drop,create,migrate,seed}
```

## Versions
- Ruby 2.7.2
- Rails 5.2.6

# Gems
- `gem 'pry'`
- `gem 'jsonapi-serializer'`
- `gem 'rspec-rails'`
- `gem 'factory_bot_rails'`
- `gem 'faker', github: 'stympy/faker'`
- `gem 'simplecov', require: false, group: :test`

## Contributor

<a href="https://github.com/Dittrir/rails-engine/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Dittrir/rails-engine" />
</a>

Robin Dittrich
