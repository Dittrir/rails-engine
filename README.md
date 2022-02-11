# Rails-Engine Lite: Turing 2110 BE Mod 3

[![Dittrir commits](https://badgen.net/github/commits/Naereen/StrapDown.js)](https://GitHub.com/Dittrir/rails-engine/commits?author=Dittrir)
![languages](https://img.shields.io/github/languages/top/Dittrir/rails-engine?color=red)
![rspec](https://img.shields.io/gem/v/rspec?color=blue&label=rspec)
![simplecov](https://img.shields.io/gem/v/simplecov?color=blue&label=simplecov) <!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/contributors-1-orange.svg?style=flat)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

![image](https://user-images.githubusercontent.com/89048720/153535281-582015ee-2682-44cc-bae1-84b7d98d418e.png)

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

## How It Works
This project was designed around tests that were created in [Postman](https://www.postman.com/). These tests ensure functionality over all databases and controller actions and can be viewed in depth by clicking on the links below.

[Postman Test Collection 1](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection1.postman_collection.json)

[Postman Test Collection 2](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection2.postman_collection.json)

There are two ways to run the test suite: one endpoint at a time, or the whole suite.

In order to test these collections, please use the following directions.
1. Click on each link to load it in your browser, then hit Cmd-S to save it to your system.
2. In Postman, in the top left corner, click on the “Import” button, and use the file selector to locate the two files on your operating system.
3. Next, you’ll “confirm” the import. The test suite should display as a “Postman Collection v2.1” and import as a “Collection”. Click the “Import” button to continue.
4. Within your collections in Postman, you should see two collections– “Rails Engine Lite, Part 1”, and “Rails Engine Lite, Part 2”.

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
