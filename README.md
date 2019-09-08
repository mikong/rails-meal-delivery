# Meal Delivery

Meal Delivery is a programming exercise:

> Your company decided to build their internal team-lunch system to provide its
> employees with the ability to schedule lunches with each other at restaurants
> around the office that accommodate their dietary needs. The system
> administrator populates the system with restaurants around the office. For
> each restaurant, there exists multiple menu items. Each menu item has a name,
> a price (in SGD), and a tag (Any of the following values: Vegetarian, Vegan,
> Meat, Fish or Chicken).

## System Use Cases

### 1. Restaurant and Menu Item Management

The use case to add/remove/edit a restaurant is a straightforward implementation
in Rails that uses RESTful design.

To add/remove/edit menu items, there are a few associations to deal with. In the
routing configuration, `menu items` is a nested resource within `restaurants` as
all menu items belong to a restaurant. The list of menu items can be found in
the restaurant page where you can find the links to add/remove/edit them.

Each menu item also has a tag and a `Tag` model was created for this. Each menu
item record has a `tag_id` reference field. We can see the schema diagram below
and how `menu_items` is linked to `restaurants` and `tags`.

![Schema Diagram][diagram-schema]

It is also possible to avoid database coupling by implementing Tag as a Plain
Old Ruby Object with the preset tags as constants, but I moved on to focus on
the more complicated use cases.

> **Note:** Even though there's a Tag model, the add/remove/edit of tags is not
> implemented in the UI. The `tags` table is populated with the preset tags
> (Vegetarian, Vegan, Meat, Fish, Chicken) through the `db/seeds.rb` script.

### 2. Employee Management

The use case to add/remove/edit employee information is also just a basic
RESTful implementation. We can see in the schema diagram above that it is not
linked to any models in the system.

### 3. Random Lunch

Requirements:

> When the administrator wants to schedule a “Random Lunch” for multiple
> employees, they will select the group of employees, and for each employee they
> will specify their preference (Vegetarian, Vegan, Meat, Fish or Chicken). The
> system will return, as a result, a list of restaurants that can accommodate
> the criteria of the whole group of employees.

For this use case, I noticed that it isn't necessary to select the group of
employees in order to get the same list of restaurants. The summary of the
preferences is enough. Even the number of employees who specified a preference
is not particularly important, only that at least one of them specified it.

**Simpler UX**

My initial implementation I call "Random Lunch (Simple)" has a simple form with
a checkbox for each of the preference, and employees are not included. The form
simply submits a list of tag IDs. In the application, I created a Query Object
named `RandomLunchQuery` to perform a single database query and its API simply
accepts this list of tag IDs and returns the list of restaurants.

**Tagging**

Whether or not a restaurant can accommodate the criteria depends on the tags of
its menu items. However, if every search will go through the menu items of each
restaurant, a lot of work is unnecessarily repeated.

I created a many-to-many relationship between tags and restaurants through a
`Tagging` model. In the schema diagram above, we can see that `restaurants` is
linked to `tags` through the `taggings` table. Whenever a menu item is
created/deleted or if its tag changes, this table is updated. The table has a
`taggings_count` field that tracks the number of menu items for that tag in each
restaurant. If the `taggings_count` drops to 0, i.e. there are no more menu
items in the restaurant with that tag, the tagging record is deleted.

**RandomLunchQuery**

This Query Object accepts a list of tag IDs in its initialization. With the
tagging records, there's no need to go through menu items on every search. For
each tag ID, we collect a list of restaurant IDs with a tagging record for
that tag. If `RandomLunchQuery` received three tag IDs, we'll have three lists
of restaurant IDs. We then intersect the three lists to get the final list of
restaurants that accommodate the search criteria. Collecting the restaurant IDs
and the final result list of restaurants is obtained in just one SQL query to
achieve better performance.

**Random Lunch with Employees**

As required by the exercise, I also implemented a Random Lunch page where you
select the group of employees by setting their preferences. All employees in the
system are listed, and there's a dropdown beside each employee. The dropdown is
set to "Not eating" by default and you change it to select their preference.

The form submits the selected tag IDs without association to the employee. These
tag IDs are simply passed to the `RandomLunchQuery` where it will remove
duplicate values and proceed to run the query.

### 4. Paid Lunch

Requirements:

> When the administrator wants to order a “Paid Lunch” for multiple employees,
> they will provide the total budget value in SGDs, and as in use-case (3), will
> select the list of employees and their preferences. The system will return, as
> a result, a list of restaurants with the selected menu items that will
> accommodate the group’s preference AND stay within the selected budget.

Similar to Random Lunch, we can also get the same list of restaurants without
selecting employees. However, the number of employees who specified each
preference is important in order to check if selected menu items can stay within
the budget.

**Simpler UX**

My initial implementation I call "Paid Lunch (Simple)" has a simple form with
the budget input and a count input for each preference. There are no employees
in this form.

**Tagging**

To check if a restaurant can accommodate the budget, we need to find the
cheapest menu item for each relevant tag. If we sort menu items by price to look
for this menu item on every search, it can become potentially slow.

We reuse the `Tagging` model to store the price and the ID of the cheapest menu
item for each tag for each restaurant. In the schema diagram above, you can see
`lowest_price_cents` and `lowest_item_id` in the `taggings` table. Whenever a
menu item is created/deleted/updated, this information is updated.

**PaidLunchQuery**

I created a Query Object named `PaidLunchQuery` and its API accepts a budget and
the count for each tag. First, it reuses `RandomLunchQuery` to get the list of
restaurants that satisfy the preferences. Then it goes through each restaurant,
getting the cheapest menu item for each relevant tag. With the data stored in
the `tagging` table, it simply fetches the menu item by ID. With the cheapest
menu items' prices, count for each tag, and budget, the restaurants are
filtered and the final list of restaurants is obtained.

**Paid Lunch with Employees**

I also implemented a Paid Lunch page where you select the group of employees by
setting their preferences. The form submits the budget and an array of tag IDs.
If several employees specified the same preference, the tag ID is repeated in
the array.

In the application, the tag IDs are consolidated to get the count for each tag.
Then the `PaidLunchQuery` object is initialized with the budget and the count
for each tag.

### 5. Others

TODO

## Scaling to Over 100k Employees

TODO

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
$ rails db:create

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
[diagram-schema]: /doc/diagrams/diagram-schema.png
