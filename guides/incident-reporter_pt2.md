# Day 2

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

Notice that it takes a while to get our position. We can disable the two fields to prevent the user from touching them. Just add `readonly: true` to the relevant text fields.

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

Things are getting a bit messy. We can put all this JS in a separate file in which we define a function and then we simply call the function from our view. There are hundreds of articles on best practices to integrate JS in Rails applications that you can read. The earlier you think about organizing your JS code the better.

## Moving the marker

We remain in the JavaScript realm for a while to allow the user to update the incident location by dragging the marker. This requires us to add some lines to `incidents.js` when we create the marker. Here we show the easy solution but beware that it is not particularly elegant. There are a few ways to make your code more maintainable and readable that we are not exploring in this workshop (you should learn [CoffeeScript](http://coffeescript.org/) and take a look at [ES6](https://github.com/lukehoban/es6features) among other things).

```js
var marker = L.marker(new L.latLng(lat, lng), { draggable: true });
marker.on('dragend', function (e) {
  $('#incident_latitude').val(e.target.getLatLng().lat);
  $('#incident_longitude').val(e.target.getLatLng().lng);
});
marker.addTo(map);
```

**Exercise** How do we make this work also in `incidents#edit`?

## Reverse Geocoding

What if we wanted a more human readable location? We can use some API (e.g. Google Maps API) to convert latitude and longitude into a location string. [Geocoder](https://github.com/alexreisner/geocoder) is a very popular gem to do just that.

Let's first add a new field to incidents to store the address.

```bash
rails g migration AddLocationToIncidents location:string
rake db:migrate
```

We add `geocoder` to our Gemfile.

```ruby
gem 'geocoder'
```

Now, we need to tell the to our Incident model to reverse geocode after validation based on the latitude and longitude provided.

```ruby
# incident.rb
reverse_geocoded_by :latitude, :longitude, address: :location
after_validation :reverse_geocode  # auto-fetch location
```

Finally, we display it in the view

```erb
<dt>Approximate location:</dt>
<dd><%= @incident.location %></dd>
```

## Sending emails

## Uploading an image

## Authentication with Devise
