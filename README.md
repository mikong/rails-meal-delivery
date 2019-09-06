# README

## Local Setup

### Ruby version

This application requires [Ruby][ruby] (MRI) 2.5.6.

For Ruby gem installation, make sure you have [bundler][bundler] installed.
Rails 5.2.3 requires Bundler >= 1.3.0.

```bash
$ gem install bundler
```

### Database

MySQL versions 5.1.10 and up are supported.

### Other requirements

* [Git][git]

### Getting Started

Checkout the project with git:

```bash
$ git clone git@github.com:mikong/rails-meal-delivery.git
```

Install gems:

```bash
$ cd /path/to/project/rails-meal-delivery
$ bundle install
```

Make sure your MySQL server is running. Update `config/database.yml` with your
credentials. Then, create the database, load the schema and the seed data:

```bash
# create the database
$ rails db create

# load the schema
$ rails db:schema:load

# load the seed data (tags and admin user)
$ rails db:seed
```

Alternatively, you can run the following command to perform all 3 actions:

```bash
$ rails db:setup
```

Start the Rails server:

```bash
$ rails s
```

Access the site on your browser at http://localhost:3000. Login using the
admin user with the following default credentials (defined in `db/seeds.rb`):

```
login: admin
password: audiences5-quislings
```

[ruby]: https://www.ruby-lang.org/en/documentation/installation/
[bundler]: http://bundler.io
[git]: https://git-scm.com/
