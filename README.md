# Rails-Engine Lite: Turing 2110 BE Mod 3
[![Dittrir's GitHub stats](https://github-readme-stats.vercel.app/api?username=Dittrir)](https://github.com/Dittrir/github-readme-stats)
https://img.shields.io/appveyor/tests/Dittrir/rails-engine

## Description
Rails-engine is an application developed to mimic an E-Commerce Application. The plan was to structure this in a service-oriented architecture, meaning the front and back ends of this application are separate and communicate via APIs. My job was to expose the data that powers the site through an API that the front end will consume.

## Learning Goals 
- Expose an API
- Use serializers to format JSON responses
- Test API exposure
- Use SQL and AR to gather data

## Local Setup
1. Fork and Clone the repo ```git clone git@github.com:Dittrir/rails-engine.git```
2.  Navigate to directory ```cd viewing_party_lite```
3. Install gem packages: ```bundle install```
4. Update gem packages: ```bundle update```
5. Set up the schema: ```rails db:schema:dump```
6. SRun the migrations: ```rake db:{drop,create,migrate,seed}```

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
