# Ruby Basics

## The console

Just type `irb` in your command shell and you should see something like

~~~ruby
irb(main):001:0>
~~~

`irb` is the *Interactive Ruby Shell*.

Type `irb --prompt simple` for a shorter prompt

~~~ruby
>>
~~~

## The classic `Hello World`

When you learn a new language you always write the same Hello World program

~~~ruby
>> puts "Hello World!" # done!
~~~

# Numbers

Ruby recognizes numbers and mathematic symbols.

~~~ruby
>> 4+3
=> 7
>> 4-5
=> -1
>> 42/6
=> 7
>> 6*7
=> 42
>> 2**10
=> 1024
~~~

# Strings

To make a `String` just enclose the text in quotes

~~~ruby
>> "Grahamstown"
=> "Grahamstown"
~~~

## Play with strings

let's try to reverse it

~~~ruby
>> "Grahamstown".reverse
=> "nwotsmaharG"
~~~

how long is Grahamstown?

~~~ruby
>> "Grahamstown".length
=> 11
~~~

let's repeat it

~~~ruby
>> "Grahamstown" * 5
=> "GrahamstownGrahamstownGrahamstownGrahamstownGrahamstown"
~~~

or SHOUT it out loud

~~~ruby
>> "Grahamstown".upcase
=> "GRAHAMSTOWN"
~~~

# Methods

`reverse` and `*` are methods!

The correct term is actually *messages*

~~~ruby
>> 4.send(:+, 3)
=> 7
~~~

here we send the message `:+` with parameter 3 to the object 4

## Wrong methods

~~~ruby
>> 42.reverse
NoMethodError: undefined method 'reverse' for 42:Fixnum
~~~

Ruby is telling us there is no method reverse for numbers.
but we can do something like this

~~~ruby
>> 42.to_s.reverse
=> "24"
~~~

or this

~~~ruby
>> 42.to_s.reverse.to_i
=> 24
~~~

# Arrays

What are arrays?! They are **lists**.
Type in a pair of brackets: `[]`

~~~ruby
>> [12, 78, 27]
=> [12, 78, 27]
~~~

Lists store elements in the order they are inserted.

## Have fun with arrays

~~~ruby
>> [12, 78, 27].max
=> 78
>> [12, 78, 27].last
=> 27
>> [12, 78, 27].reverse
=> [27, 78, 12]
>> [12, 78, 27].sort
=> [12, 27, 78]
~~~

# Arrays and strings
a `String` can be seen as an array of `chars`

~~~ruby
>> "Grahamstown".chars.to_a
=> ["G", "r", "a", "h", "a", "m", "s", "t", "o", "w", "n"]
>> "Grahamstown".chars.to_a.reverse
=> ["n", "w", "o", "t", "s", "m", "a", "h", "a", "r", "G"]
>> "Grahamstown".chars.to_a.reverse.join
=> "nwotsmaharG"
>> "Grahamstown".reverse
=> "nwotsmaharG"
~~~

# Variables
Variables save a thing and give it a name.

We use the equals sign to do this.

~~~ruby
>> poker_cards = [20, 5, 1, 100, 8, 13, 0.5, 40, 2, 3, 0]
=> [20, 5, 1, 100, 8, 13, 0.5, 40, 2, 3, 0]
~~~

We can call methods on variables (i.e. send them *messages*)

~~~ruby
>> poker_cards.sort!
=> [0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100]
~~~

# What's that `!`?
The exclamation at the end means that the method `sort!` changes what the variable contains for good.

So, after `poker_cards.sort!`:

~~~ruby
>> poker_cards
=> [0, 0.5, 1, 2, 3, 5, 8, 13, 20, 40, 100]
~~~

Note that this is only a convention!

## There is also the `?`

~~~ruby
>> poker_cards.include? 42
=> false
>> poker_cards.include? 13
=> true
>> poker_cards.include? "∞"
=> false
>> poker_cards.empty?
=> false
~~~

This is a convention too!

# The `:symbols`

When you place a colon in front of a simple word, you get a symbol.

Symbols are cheaper than strings (in terms of computer memory.) If you use a word over and over in your program, use a symbol. Rather than having thousands of copies of that word in memory, the computer will store the symbol only once.

Symbols are useful for indexing *hashes*.

# Hash

Namely a list of `key-value` pairs.

a.k.a. `Dictionary`, `HashTable`, `HashMap`, ...

## Java `HashTable`

~~~java
// create the HT
Hashtable<String, Integer> numbers = new Hashtable<String, Integer>();

// fill the HT
numbers.put("one", 1);
numbers.put("two", 2);
numbers.put("three", 3);

// access the HT
Integer n = numbers.get("two");
if (n != null) {
 System.out.println("two = " + n);
}
~~~

## Ruby `Hash`

~~~ruby
# create the hash
>> numbers = {}

# fill the hash
>> numbers["one"] = 1
>> numbers["two"] = 2

# access the hash
>> numbers["two"]
=> 2
>> numbers["fortytwo"]
=> nil
~~~

## Play with hashes

Let's create a new hash of our favourite South African and Italian food

~~~ruby
>> food = {}
=> {}
~~~

a hash is a set of `key => value` pairs, unordered

~~~ruby
>> food["Italian Pizza"] = :very_good
=> :very_good
>> food
=> {"Italian Pizza"=>:very_good}
~~~

let's add a few

~~~ruby
>> food["South African Pizza"] = :not_so_good
=> :not_so_good
>> food["Boerewors"] = :very_good
=> :very_good
>> food["Bobotie"] = :dont_know
=> :dont_know
>> food["Biltong"] = :good
=> :good
>> food["Kudu"] = :excellent
=> :excellent
~~~

and see how many

~~~ruby
>> food
=> {"Italian Pizza"=>:very_good, "South African Pizza"=>:not_so_good, "Boerewors"=>:very_good, "Bobotie"=>:dont_know, "Biltong"=>:good, "Kudu"=>:excellent}
>> food.length
=> 6
~~~

Let's have a look to our ratings: create a hash for storing the rates

~~~ruby
>> ratings = Hash.new(0)
=> {}
~~~

and fill it with our ratings of food

~~~ruby
>> food.values.each { |rate| ratings[rate] += 1 }
~~~

here it is

~~~ruby
>> ratings
=> {:very_good=>2, :not_so_good=>1, :dont_know=>1, :good=>1, :excellent=>1}
~~~

**what's that `{|| ...}`?**

# Ruby *blocks*

That piece of code is called a *block* and that's how it works

~~~ruby
>> food.values.each { |rate| ratings[rate] += 1 }
~~~

`|rate|` is the *block variable*

`ratings[rate] += 1` is the *block code*

each value of `food` is put into the *block variable* and the *block code* is executed.

## Multi-line block
When you have a huge block you can write it using multiple lines

~~~ruby
>> food.values.each do |rate|
?> 	ratings[rate] += 1
>> end
>> ratings
=> {:very_good=>2, :not_so_good=>1, :dont_know=>1, :good=>1, :excellent=>1}
~~~

`do` and `end` work for `{...}`

# Control flow

namely `if`, `else` stuff

~~~ruby
>> s = "a string"
>> if s.empty?
>>   "The string is empty"
>> else
?>   "The string is nonempty"
>> end
=> "The string is nonempty"
~~~

we can also use `unless`

~~~ruby
>> x = "a variable"
>> puts "x is not empty" if !x.empty?
x is not empty
=> nil
>> puts "x is not empty" unless x.empty?
x is not empty
=> nil
~~~

Note that the condition can also be put *after* the code to execute.

# The `nil` object

`nil` is a special object, similar to the Java `null`

it is the only Ruby object that is `false` in a boolean context, apart from `false` itself

~~~ruby
>> if nil
>> 	true
>> else
?> 	false
>> end
=> false
~~~

all other Ruby objects are true, even 0

~~~ruby
>> if 0
>> 	true
>> else
?> 	false
>> end
=> true
~~~

# Loops

Things like `for` and `while`. They exist in Ruby but we like the others!

## The `each` method

Executes the *block code* on all the elements of `self`

~~~ruby
>> (1..5).each do |element|
?> 	print element * 10, " "
>> end
10 20 30 40 50                  
~~~

## The `map` method

Invokes the given *block code* once for each element of `self` and creates a new array containing the values returned by the block

~~~ruby
>> (1..5).map do |element|
?>   element * 2
>> end
=> [2, 4, 6, 8, 10]
~~~

## The `select` method

It is like `map` but returns only the elements that match the condition

~~~ruby
>> (1..5).select do |element|
?>   element.even?
>> end
=> [2, 4]
~~~

# Method definition

Open the definition with `def` and close it with `end`

~~~ruby
>> def palindrome?(string)
>>  string == string.reverse
>> end
~~~

and call it by name

~~~ruby
>> palindrome? "level"
=> true
~~~

in Ruby functions have an implicit *return*, meaning they *return* the last statement evaluated, but dont'worry, the `return` statement exists too.

# Classes

We define a new class like this

~~~ruby
>> class Word
>> 	def palindrome?(string)
>> 		string == string.reverse
>> 	end
>> end
~~~

and we use it like this

~~~ruby
>> w = Word.new
=> #<Word:0x007fb8759a97e8>
>> w.palindrome? "level"
=> true
~~~

But... it’s odd to create a new class just to create a method that takes a string as an argument, so let's *extend* the Ruby class `String`.

## Extending a Class

We can define `Word` as a subclass of `String`

~~~ruby
>> class Word < String
>> 	def palindrome?
>> 		self == self.reverse
>> 	end
>> end
~~~

`self` is similar to `this` in Java

and now we use it like this

~~~ruby
>> w = Word.new("level")
=> "level"
>> w.palindrome?
=> true
~~~

we obviously inherited all the methods of String

~~~ruby
>> w.length
=> 5
~~~

and we can see the inheritance of our new class

~~~ruby
>> w.class.superclass
=> String
>> w.class.superclass.superclass
=> Object
>> w.class.superclass.superclass.superclass
=> BasicObject
~~~

## Opening a Class

This is something cool of Ruby!

We don't need to extend String to add new methods to it
~~~ruby
>> class String
>>   def palindrome?
>>     self == self.reverse
>>   end
>> end

~~~

and now ladies and gentlemen...

~~~ruby
>> "level".class
=> String
>> "level".palindrome?
=> true
~~~

this is called *opening a built-in class* and you should do it only if you have a **REALLY** good reason.

## Local vs. Instance vs. Class Variables

`x = 3` is a local variable for a method or block (gone when the method is done)

`@x = 3` is a instance variable owned by each object (it sticks around)

`@@x = 3` is a class variable shared by all objects (it sticks around, too).

## Instance vs. Class Methods

Instance methods are defined like this

~~~ruby
>> class Word < String
>> 	def palindrome?
>> 		self == self.reverse
>> 	end
>> end
~~~

and Class methods are defined like this

~~~ruby
>> class Word < String
>> 	def self.palindrome?(s)
>> 		s == s.reverse
>> 	end
>> end
~~~

and you will use it like this

~~~ruby
>> Word.palindrome? "aibohphobia"
=> true
~~~

# Other useful things of Ruby

Ruby has a number of other features that can be really useful, especially when working in Rails

## String interpolation

String interpolation in ruby allows you to embed (the string representation of) a variable in a string

~~~ruby
>> a = 15;
?> "I have #{a} cats"
=> "I have 15 cats"
>> array = [15, 7, 4, 'braai'];
?>   "this is an array: #{array}"
=> "this is an array: [15, 7, 4, \"braai\"]"
>> "The time now is #{Time.now}"
~~~

## Ruby Gems

Gems are software packages that include software or libraries that can be used in your Ruby code to add functionalities and behaviors

Rails itself is a Ruby Gem, and you should have it installed already

~~~bash
gem list | grep rails
rails -v
~~~

## Ruby Assignments

Ruby has the `||` operator which is a bit funky. When put in a chain

~~~ruby
x = a || b || c || "default"
~~~

it means “test each value and return the first that’s not false.” So if `a` is false, it tries `b`. If `b` is false, it tries `c`. Otherwise, it returns the string `"default"`.

If you write

~~~ruby
x = x || "default"
~~~

it means “set `x` to itself (if it has a value), otherwise use the `"default"`.” An easier way to write this is

~~~ruby
x ||= "default"
~~~

which means the same: set x to the default value unless it has some other value. You’ll see this a lot in Ruby code.

## Syntax: parenthesis and semicolons

* Parenthesis on method calls are optional; use `print "hi"`.
* Semicolons aren't needed after each line.
* Use “if do else end” rather than braces.
* Parens aren't needed around the conditions in if-then statements.
