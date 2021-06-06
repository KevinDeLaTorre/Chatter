# Chatter App

## Getting Started
To get started clone the project then install gems:

```
$ gem install bundler
$ bundle config set --local without 'production'
$ bundle install
```

Then migrate the database:

```
$ rails db:migrate
```

Then run the test suite:
```
$ rails test
```

Then if the tests pass run the app on a local server:
```
$ rails server
```
