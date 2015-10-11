---
layout: post
title: Preparatory exercise
date: 2015-10-10T11:48:22+02:00
---

The workshops are fast approaching. In order to be able to follow, please ready your environment as described [here](prereq).

Once you are done, complete the **compulsory exercise** here and fill the short questionnaire you find at the end of this post. This is to make sure that your system is working. Remember that we cannot assist you in setting up your system.

## Follow the instructions below

If you set up your system properly you should be able to run the commands below. Obviously you need to run them in a terminal. If you end up running commands with `sudo` something is wrong.

~~~
rails new pineapple_farm
cd pineapple_farm
rails g scaffold Pineapple category weight:double
rake db:migrate
rails c
~~~

At this point you will be in a Ruby console. The next commands will be in Ruby.

~~~ ruby
p = Pineapple.new category: "Queen", weight: 1.37
p.save
~~~

Do it 3 times with different names and weights and close the console with CTRL+D or by typing exit.

Type `rake routes` in your shell to see all the routes generated by the scaffold we run before.

Now type `rails s` in your shell and visit `http://localhost:3000/pineapples` with your browser. Play a bit with your new webapp and answer the questionnaire below.

<iframe src="https://docs.google.com/forms/d/1UhsBr1jeB3_-lXeoPf8y7Q4oyQ_Sv9s3vm56p50Ch54/viewform?embedded=true" width="760" height="1100" frameborder="0" marginheight="0" marginwidth="0">Loading...</iframe>