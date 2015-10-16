# Day 1

## Create the app

`rails new incident_reporter`

Let's see if it works: `rails s`

Visit `http://localhost:3000`

Let's take a look at the file structure...

## Ensuring responsiveness from the start

There are plenty of HTML5 frameworks to simplify your life. Almost all of them are **responsive**, meaning that they adapt to the screen size and we don't need to think too much about how our views will look like on a small smartphone screen.

### Introducing Twitter Bootstrap

[http://getbootstrap.com/](http://getbootstrap.com/)

### Add Twitter Bootstrap to the Gemfile

Install Twitter Bootstrap. We use SASS because it's cool, but you can also use LESS or plain CSS. The first thing to do is __ALWAYS__ to look at the gem documentation on Github!! If you follow the steps you should be fine. If you don't, you screw up your application.

We are going to use the `bootstrap-sass` gem from [https://github.com/twbs/bootstrap-sass](https://github.com/twbs/bootstrap-sass)

```ruby
# Gemfile

# Twitter Bootstrap
gem "bootstrap-sass", "~> 3.3.5"
# ~> means anything greater or equal to 3.3.5 but less than 4
```

In a command line run

```
bundle install
```

__What is the Gemfile?__ It's a file that contains all the gems that our project depends on.

__What is a gem?__ Kind of a small Rails application that we can embed in our project to add functionalities

__What does `bundle install` do?__ It downloads new gems into our project. You must always do it when you change the `Gemfile`.

### Add Twitter Bootstrap to our _assets_

__What are assets?__ In short, everything our app needs: CSS, Javascript, images, etc. Rails manages them through the asset pipeline as long as you put them in the right place! Assets are either written by you or included with gems. When your app goes into incidention they are minified to reduce bandwidth usage automatically.

This will compile Twitter Bootstrap into the CSS of our app.

#### `application.css`

**Rename** it to `application.scss` first thing because we will use SASS. Then, remove all the `*= require_self` and `*= require_tree .` statements from the sass file. Instead, use `@import` to import Sass files.

```scss
// "bootstrap-sprockets" must be imported before "bootstrap" and "bootstrap/variables"
@import "bootstrap-sprockets";
@import "bootstrap";
```

This will include jQuery and Bootstrap into our JS.

#### `application.js`

```javascript
//= require jquery //this is probably there already
//= require bootstrap-sprockets
```

Rails lets us generate views automatically, so we install another gem to use Bootstrap directly when generating them.

```ruby
gem 'bootstrap-generators', '~> 3.3.4'
```

Now we can change `application.scss` as follows

```scss
// @import "bootstrap-sprockets";
// @import "bootstrap";
@import "bootstrap-generators";
```

(you can take a look at the `app/assets/stylesheets` directory to understand why)

```bash
bundle install
rails generate bootstrap:install --stylesheet-engine=scss --force
spring stop #might not be necessary
```

Great stuff. Now we are ready to make our app do something.

## Scaffold: Our first models

We want to create an **Incident** with a **Category**, location and flags to say whether I am near or at the incident site. Something like this:

```json
category: {
  "name": "string",
  "description": "text"
}

incident: {
  "category": "belongs_to",
  "latitude": "float",
  "longitude": "float",
  "at_location": "boolean"
}
```

Rails offer a very quick way to start building a web app:

```bash
rails generate model category name description:text
```

This creates a **Category** model and a **migration**. Let's take a look at `app/models/category.rb` and at the new migration in `db/migrations/XYZ_create_categories.rb` (the name will be different).

Then, we need to create our **Incident** model that __belongs to__ a **Category**. This time we want the whole web interface made for us

```bash
rails g scaffold incident latitude:decimal longitude:decimal at_location:boolean category:belongs_to
```

This creates a __model__, a __controller__, a set of __views__ and a __migration__. Let's take a look at generated files.

Before starting the server, you need to migrate the DB with the new table. This is called a Rake task.

```bash
rake db:migrate
```

Start the server and take a look around. Everything works like magic. You can CRUD incidents with 0 lines of code.

```bash
rails s
```

Take a look at:

* Model: `incident.rb`
* Controller: `incidents_controller.rb`
* View: `app/views/incidents/...`
* `routes.rb` how does it work? Take a look also at `rake routes`

## Focus on the views

### `application.html.erb`

Explain the purpose of layouts and how views work. What does `yield` do? Tease that we will need this concept also later when we will generate emails automatically.

### `incidents/show.html.erb`

We look at `app/views/incidents/show.html.erb` (later we can look at the `.json.jbuilder`) and we change it a bit.

Important things to mention:

* where does `@incident` come from? Show in controller the `before_action :set_incident`
* what happens if I call `@pippo` in my view? Take a look at the error messages. What happens if I add it to the controller in the `show` method?

We can change a few things just as an example

```html
<h1>
  Incident #<%= @incident.id %>
</h1>
```

__Exercise!__ Try doing something interesting with `index.html.erb`. Notice the use of `@incidents.each` and try to make it responsive (see the documentation of Twitter Bootstrap)! A possible solution below..

### `index.html.erb`

```erb
<div class="row">
  <% @incidents.each do |incident| %>
    <div class="col-sm-6 col-md-4">
      <div class="thumbnail">
        <%= image_tag 'http://placehold.it/345x200' %>
        <div class="caption">
          <h3>Incident #<%= incident.id %></h3>
          <p>
            Latitude: <%= incident.latitude %><br>
            Longitude: <%= incident.longitude %>
          </p>
          <p>
            <%= link_to 'Show', incident, class: 'btn btn-info' %>
            <%= link_to 'Edit', edit_incident_path(incident), class: 'btn btn-primary' %>
            <%= link_to 'Destroy', incident, method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger' %>
          </p>
        </div>
      </div>
    </div>
  <% end %>
</div>
```

### `_form.html.erb`

This is a partial (more on these later maybe) that uses several **helpers** to simplify the creation of forms (if you use the `simple_form` gem you get even simpler helpers!). If you played with the application a bit you may have noticed that we can't really choose a category for our incidents. That's because we haven't created any!

## Relations! What about our Categories?

Remember that when we created **Incidents** we specified `category:belongs_to`. That creates a one-to-many relationship between categories and incidents. Let's find out something more about relations in Rails...

```ruby
# incident.rb
class Incident < ActiveRecord::Base
  belongs_to :category
end
```

That is enough to allow us to call `@incident.category` (see what happens in SQL when you call the `category` method). We can create some categories using a seed that we create as follows.

```ruby
# db/seeds.rb
Category.create [
  {
    name: 'Medical Emergency',
    description: 'Someone is in need for medical assistance!'
  },
  {
    name: 'Fire',
    description: 'Something is on fire!'
  },
  {
    name: 'Flooding',
    description: 'Water is rising quickly!'
  },
  {
    name: 'Crime',
    description: 'Someone is misbehaving'
  },
  {
    name: 'Water outage',
    description: 'No water! No water!'
  },
  {
    name: 'Electricity outage',
    description: 'No electricity where there should be!'
  },
  {
    name: 'Road accident',
    description: 'Something happened on the road'
  }
]
```

And then run

```bash
rake db:seed
```

If you enter the console now you should see that the categories are in the db but we have yet to give the user an easy way to select one when he creates an incident.

```erb
# app/views/incidents/_form.html.erb
<%= f.select :category_id, options_from_collection_for_select(@categories, :id, :name), {}, {class: 'form-control'} %>
```

Check the generateted HTML to understand the line above.

But we get an error! Why? (solution below)

```ruby
# app/controllers/incidents_controller.rb
before_action :set_categories, only: [:new, :edit]

#...
def set_categories
  @categories = Category.all
end
```

Finally, to display the category of each incident we need to add where needed `<%= @incident.category.name %>`.

**Question** What if we wanted to see all the incidents of a certain category? Notice that we can't at the moment because we are missing something in the Category model.

```ruby
has_many :incidents
```

It's worth now to take a look at the migrations that created the two models.
