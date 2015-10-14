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


## Nesting resources

**Question** How can we show all the incidents by category?

To do this we need to:

* create a controller for categories
* update our routes to nest incidents into categories
* create an `index` view for categories where we show all incidents grouped under categories
* reuse the incident card we made before as partial

### Creating a controller for categories

That's easy, just create `categories_controller.rb` in `app/controllers`. Since we want only the index action, we create a method that loads all the categories.

```ruby
class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

end
```

#### `routes.rb`

```ruby
resources :incidents

resources :categories, only: [:index] do
  resources :incidents, only: [:show]
end

# we make the new controller action our root path so that we can access it under http://localhost:3000/
root 'categories#index'
```

See how this changes the result of `rake routes`

```
category_incident GET    /categories/:category_id/incidents/:id(.:format) incidents#show
       categories GET    /categories(.:format)                            categories#index
```

#### A new view `categories/index.html.erb`

**Exercise** You can start by copy/pasting `incidents/index.html.erb` and then make a new view that shows all the categories and the incidents reported under those categories. Remember that it must work on a mobile phone.

The code below is just a possible solution.

```erb
<% @categories.each do |category| %>
  <h2><%= category.name %></h2>

  <div class="row">
    <% category.incidents.each do |incident| %>
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
<% end %>
```

Now you see that we basically copy pasted the same code from `incidents/index.html.erb`. We can make a **partial** of it so that our code is more DRY and maintainable.

```erb
<!-- incidents/_incident.html.erb -->
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

<!-- categories/index.html.erb -->
<% @categories.each do |category| %>
  <h2><%= category.name %></h2>

  <div class="row">
    <%= render category.incidents %>
  </div>
<% end %>

<!-- incidents/index.html -->
<div class="row">
  <%= render @incidents %>
</div>
```

This automatically fetches the right partial based on the model name to save you the trouble of writing

```ruby
render partial: 'incidents/incident', incident: incident
```

We can now update the navbar and take a look at linking routes

```erb
<!-- application.html.erb -->
<ul class="nav navbar-nav">
  <li class="active"><%= link_to 'Home', root_path %></li>
  <li><%= link_to 'By date', incidents_path %></li>
  <li><%= link_to 'By category', categories_path %></li>
</ul>
```

#### Exercises for the weekend

These are small exercises that can be completed by **looking at the Rails documentation** in a few minutes.

__Easy question__ How can we sort the incidents by date in the view under `incidents_path`? (Hint: you can change something in the controller)

__Solution__

```ruby
# incidents_controller.rb
def index
  @incidents = Incident.all.order('created_at DESC')
end
```

__More Difficult Question__ How can we wanted to create a separate view for each category (i.e. implement `categories#show`)?  We also want to be able to create incidents under that category directly from that view.

__Solution__

Firstly we add the routes to create an incident under a category

```ruby
# routes.rb
resources :categories, only: [:index, :show] do
  resources :incidents, only: [:show, :new, :create]
end
```

Then we add the action to the `categories_controller`

```ruby
class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = Category.all
  end

  def show
  end

  private

  def set_category
    @category = Category.find params[:id]
  end
end
```

We change the behavior of `new` and `create` to support the case when we have a category from the route (e.g. `/categories/1/incidents/new`). We want to keep supporting the nominal case when we call `/incidents/new`.

```ruby
before_action :set_category, only: [:new, :create]

def new
  if @category
    @incident = @category.incidents.build
  else
    @incident = Incident.new
  end
end

def create
  if @category
    @incident = @category.incidents.build(incident_params)
  else
    @incident = Incident.new(incident_params)
  end

  # more stuff here that we don't change
end  

private

def set_category
  @category = Category.find(params[:category_id]) if params[:category_id]
end
```

We partialize categories for our convenience (optional)

```erb
<!-- categories/_category.html.erb -->
<h2><%= category.name %> <%= link_to '+', new_category_incident_path(category) %></h2>

<div class="row">
  <%= render category.incidents %>
</div>

<!-- categories/show.html.erb -->
<%= render @category %>
```

We change how the form works because we need to deal with the case when we have a category from the route and the case when we don't. We achieve this by taking out the `form_for` method call and putting it into a conditional. This is only one possible way to do it and it's not particularly DRY (you could, for example, write a __helper__).

**Heads up!** This will break your `edit` view and you will need to fix that too.

```erb
<!-- incidents/new.html.erb -->
<% if @category %>
  <%= form_for [@category, @incident], html: { class: "form-horizontal", role: "form" } do |f| %>
    <%= render 'form', f: f %>
  <% end %>
<% else %>
  <%= form_for(@incident, html: { class: "form-horizontal", role: "form" }) do |f| %>
    <%= render 'form', f: f %>
  <% end %>
<% end %>

<!-- incidents/_form.html.erb -->
<% unless @category %>
  <div class="form-group">
    <%= f.label :category, class: "col-sm-2 control-label" %>
    <div class="col-sm-10">
      <%= f.select :category_id, options_from_collection_for_select(@categories, :id, :name), {}, {class: 'form-control'} %>
    </div>
  </div>
<% end %>
```

--------------------------------------

# Day 2

## Migrations

Let's say we want to add a brief description to an incident. This is very easy thanks to migrations. We just run a generator in our command line.

```bash
rails g migration AddDescriptionToIncidents description:text
rake db:migrate
```

That's it! Remember to add a form field

```erb
<div class="form-group">
  <%= f.label :description, class: "col-sm-2 control-label" %>
  <div class="col-sm-10">
    <%= f.text_area :description, class: "form-control" %>
  </div>
</div>
```

...and to add `:description` to the allowed parameters in the controller

```ruby
def incident_params
  params.require(:incident).permit(:latitude, :longitude, :at_location, :category_id, :description)
end
```

And of course add it somewhere in the view (exercise).

## Validations

Rails models can declare validations that are automatically run every time we try to write to the db. For example, we want every incident to have coordinates.

```ruby
validate_presence_of :latitude, :longitude
#which is the same as
validates :latitude, presence: true
validates :longitude, presence: true
```

As you know, latitude and longitude have to be within specific ranges. So we can add the following validations to our `Incident` model.

```ruby
validates :latitude , numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
```

## Displaying Maps

Those placeholders look quite empty. Let's replace them with static maps of the location of the incident. To do that we can use Google Maps API. To display a static map we don't need any gem because [Google Static Maps API](https://developers.google.com/maps/documentation/static-maps/intro) is enough.

We just change our image tag as follows

```ruby
# incidents/_incident.html.erb
image_tag "https://maps.googleapis.com/maps/api/staticmap?size=345x200&maptype=hybrid&markers=#{incident.latitude},#{incident.longitude}"
```

That's easy! What if we want to add a navigable map in `incidents#show`?

This time around we will need some JavaScript and some CSS, but first let's install `leaflet-rails` to include [Leaflet.js](http://leafletjs.com/) in our app assets. This gem makes it a bit easier to include basic maps but we will still need JavaScript later on.

```ruby
# Gemfile
gem 'leaflet-rails'

# config/initializers/leaflet.rb (this will be run when the application starts)
Leaflet.tile_layer = 'http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
Leaflet.attribution = 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
Leaflet.max_zoom = 16
```

**Restart the server now.**

We chose a free satellite map but you can replace the title layer with the one you prefer from [https://leaflet-extras.github.io/leaflet-providers/preview/](https://leaflet-extras.github.io/leaflet-providers/preview/).

We then need to add the required dependencies to `application.js`

```js
//= require leaflet
```
and to `application.scss`.

```scss
// the following two lines go to the top
//= depend_on_asset "layers.png"
//= depend_on_asset "layers-2x.png"

@import "leaflet";
```

Now we can add our map to `incidents/show.html.erb` (see the documentation for [leaflet-rails](https://github.com/axyjo/leaflet-rails)).

```erb
<%=
  map center: {
      latlng: [@incident.latitude, @incident.longitude],
      zoom: 15
    },
    markers: [
      { latlng: [@incident.latitude, @incident.longitude] }
    ],
    container_id: 'incident-map'
%>
```

`map` is a **helper** that adds some HTML and JavaScript to our page. This is quite convenient for simple stuff but it can't be customized too much.

You'll notice that the map is nowhere to be seen. Use the inspector of your browser you can see that it is on the page but it has `height: 0px`. Let's add some CSS to fix this.

```scss
// incidents.scss
.leaflet-container#incident-map {
  height: 300px;
}

// application.scss
@import "incidents";
```

Voilà!

## Geocoding

So far we asked the user to input the latitude and longitude manually. As you know, all our devices know their location from GSM, WiFi or GPS. Let's use that to automatically fill the latitude and longitude fields when we create a new incident.

We will add a few lines of JavaScript to `incidents/new.html.erb` to perform HTML5 Geocoding. You can find it [here](http://www.w3schools.com/html/html5_geolocation.asp)

```html
<script type="text/javascript">
if (navigator.geolocation) {
  navigator.geolocation.getCurrentPosition(function (position) {
    $('#incident_latitude').val(position.coords.latitude);
    $('#incident_longitude').val(position.coords.longitude);
  });
} else {
  alert("Geolocation is not supported by this browser! Upgrade!");
}
</script>
```

Notice that it takes a while to get our position. We can disable the two fields to prevent the user from touching them. Just add `disabled: 'disabled'` to the relevant text fields.

Time to add a map. This time we will need JavaScript to link the fields to the marker on display.

```html
<!-- incidents/_form.html.erb -->
<div id="map" style="height: 300px; margin-bottom: 1em"></div>

<script type="text/javascript">
var map = L.map('map').setView([-30.5630928,24.901925], 6);

// we copy this from the initializer
L.tileLayer('http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
  attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
}).addTo(map);
</script>
```

This adds a map that does nothing. Time to move some of the code we wrote earlier inside the partial.

```js
// if this is a new incident
if (($('#incident_latitude').val() === "") || ($('#incident_longitude').val() === "")) {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function (position) {
      var lat = position.coords.latitude,
          lng = position.coords.longitude;

      // automatically fill the text fields
      $('#incident_latitude').val(lat);
      $('#incident_longitude').val(lng);

      // move the map to lat,lng and add a marker in the same position
      map.setZoom(16).panTo([lat, lng]);
      L.marker([lat, lng]).addTo(map);
    });
  } else {
    //...
  }
}
```

Things are getting a bit messy. We can put all this JS in a separate file in which we define a function and then we simply call the function from our view. There are hundreds of articles on the best practices 

## Moving the marker

## Sending emails

## Uploading an image

## Authentication with Devise
