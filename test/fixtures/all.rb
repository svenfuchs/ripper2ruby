# occurences of \n will be replaced with actual newlines

# literals
1
1.1
nil
true
false

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
`ls -a`
%x(ls -a)


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
class A; end
class A; def foo(a, *b, &c); d; end; end
module B; end
module B; def foo(a, *b, &c); d; end; end

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

a, b = c, d
a, \n b = \n c, \n d

# operators
!a
# ...

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

a = lambda { |b| c }
a &lambda { |b| c }

# control structures
if true then :a else :b end
if true; nil else; a end
if true\n nil else\n a end
a if true

unless true then false end
unless true; false end
unless true\n false end
nil unless true

case a; when A, B, C; true; when D; false; else; nil end
case a\n when A, B, C\n true\n when D\n false\nelse\n nil end

begin ; end
while true; foo; end
begin; foo; end while true
foo while true
until true; foo; end
begin; foo; end until true
foo until true

# special
defined?(A)
return
return 1
return(1)
break
next
redo
retry



