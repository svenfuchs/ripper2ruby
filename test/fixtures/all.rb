# occurences of \n will be replaced with actual newlines

# numbers
1
1.1

# symbols
:a
:"a"
:"a \n b \n c"
:'a'
:'a \n b \n c'


# strings

"a"
'a'
%(a)
%( a \n   b \n   c )
%|a|
%.a.


# arrays

[:a,:b,:c]
[:a,:b, :c]
[:a, :b,:c]
[:a, :b, :c]
[:a, :b, :c ]
[ :a, :b, :c]
[ :a, :b, :c ]

[ \n :a, \n :b, \n :c \n ]

%w(a b c)
%w(a b c )
%w( a b c)
%w( a b c )

# hashes

{:a=>:a}
{:a=>:a }
{ :a=>:a}
{:a => :a}
{ :a=>:a }
{:a=> :a }
{ :a =>:a}
{ :a => :a }

{ \n :a => \n :a \n }

# constants

I18n

# assignments

a=b
a,b=c
a, b=c
a, b=c,d
a, b=c, d
a, b=*c

a = b
a,b = c
a, b = c
a, b = c,d
a, b = c, d
a, b = *c

a, \n b = \n c, \n d

# calls

t
t()
t(:a)
t :a
t  :a

I18n.t
I18n.t()
I18n.t(:a)

t(:a,:b)
t(:a, :b)
t(:a ,:b)
t(:a, :b )
t(:a ,:b )
t( :a, :b)
t( :a ,:b)
t( :a, :b )
t( :a ,:b )

t(:a, :b,&c)
t(:a, :b, &c)

t(:a, :b, :c => :c, &c)
t(:a, :b, { :c => :c }, &c)

t( \n:a, \n :b, \n :c => \n :c, \n &d)

