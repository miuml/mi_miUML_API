mi_miUML_API
============

miUML database schema and editor API as postgresql stored procedures

miUML API / Model Editor 2.0 / April 2, 2012
Downloadable at: miuml.org

OPEN SOURCE LICENSE
---
Copyright 2012, Model Integration, LLC
Developer: Leon Starr / leon_starr@modelint.com

This file is part of the miUML metamodel library.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.  The license text should be viewable at
http://www.gnu.org/licenses/
---

GOAL - Created and edit miUML models (Class / State only at this point)
---
Before launching into the setup instructions, let's consider our end goal.  If all
goes well, you should be able to work either from the PostgreSQL command line
interactively, or through the submission of files or via your favorite programming
language.  Let's consider some API commands defined on the google spreadsheets
available under the API heading on the miuml.org site.

1) UI_new_modeled_domain( 'Air Traffic Control', 'ATC' )
2) UI_new_class( 'Duty Station', 'DS', 'Main', 'Air Traffic Control' )
3) UI_new_class( 'Aircraft', 'AIR', 'Main', 'Air Traffic Control', NULL, 'Tail Number', 'short name' )
4) UI_getall_classes( 'Air Traffic Control ' )

With these commands we will 1) create the 'Air Traffic Control' Domain with a default Subsystem 2)
create a Class titled 'Duty Station' with a default Identifier and then 3) another Class titled 'Aircraft' with a 
specified Identifier 'Tail Number' of type 'short name' and then 4) verify the existence of our newly created
classes by issuing a standard query.

Here are some ways we could issue these four commands.
INTERACTIVELY in a psql session using the format: select * from UI_<command>( <args> );
	user=# select * from UI_new_modeled_domain('Air Traffic Control', 'ATC' );
You just type command 1 through 4, one at a time
In BATCH MODE by importing a file of commands into an active psql session:
File: atctest.sql
	select * from UI_new_modeled_domain( 'Air Traffic Control', 'ATC' );
	select * from UI_new_class( 'Duty Station', 'DS', 'Main', 'Air Traffic Control' );
	select * from UI_new_class( 'Aircraft', 'AIR', 'Main', 'Air Traffic Control', NULL, 'Tail Number', 'short name' );
	select * from UI_getall_classes( 'Air Traffic Control ' );
Actually, you can just say 'select' instead of 'select * from' if you don't expect more than one return value.  Since
UI_getall_classes is a query, you will definitely want to use 'select * from' because it returns a whole table of data.
When in doubt, use 'select * from <command>;'

To load the file, do this:

	user=# \i atctest.sql

And all four commands will execute in sequence.

You can browse through the $miumlhome/Tests directory to see many examples of such files that I have been
using for testing using this exact technique.  (In fact, you will see a commented out section near the bottom
of the $miumlhome/reset.sql file where these tests may be driven).

You can also interact PROGRAMMATICALLY with your favorite programming language.  You just need to find
yourself a data base driver library for your language that works with PostgreSQL 9.x.  I am currently doing this
with Python 3.2.2 using the psycopg2 db driver.  In Python I can now do this:

import psycopg2
conn = psycopg2.connect("dbname=miUML user=starr")
cur = conn.cursor()
cur.execute( "UI_new_modeled_domain( %s, %s )", ("Air Traffic Control", "ATC") )
cur.commit()
// lots of execute / commit pairs, or just set auto commit 
...
cur.close()
conn.close()

We can't do it yet, but soon we will be able to write a human readable script without any SQL goo in it
and just read it in.  We'll keep you posted on the miuml.org site.  For now though, these are the three
methods available, and there's certainly nothing stopping you (other than interest and free time!) from
creating your own wrapper in your favorite programming language.

With your goal firmly in mind, let's see what needs to be done to realize it!
---

INSTRUCTIONS

I'm not sure how things work on your platform, but here's what I do on
Mac OS X.  Feel free to e-mail me (address at top) if you would like help or,
better yet, post your question in the discussion group at miUML.org so others
can learn/help.

STEP 1> Set and export %miumlhome environment variable
---
I put this in my .bashrc file:

export $miumlhome='/Users/starr/Sdev/PostgreSQL/miUML2_tr'

be sure to verify success.   Here's what I do:

% echo $miumlhome
/Users/starr/Sdev/PostgreSQL/miUML2_tr

STEP 2> Verify that the PostgeSQL server is installed and running

You need to have PostgreSQL 9.1.x up and running on your platform.
When I execute the command psql, an interactive db session starts:

(Actually, before you do this, cd into your $miumlhome directory)

% psql
psql (9.1.3, server 9.1.2)
Type "help" for help.

<user>=# 

Okay, now type \q to exit your psql session.  We just wanted to verify that psql
would connect to the PostgreSQL server and start up.

Now, if you don't have PostgreSQL running, be prepared to spend a little time
googling around for the goodies relevant to your platform.  Sure, it's a pain in
the ass, but when you get it fired up, you'll have an awesome open source
relational database running on your computer that you can use for many things.
I wish you the best of luck and, as I said, I'm happy to help out if you hit any
snags.

STEP 3> Create a database user and a database and restart your psql session

Yay!  You're through the worst of it now.  It's all downhill from here.

Issue these commands from your OS command line (again, Mac OS X in
my examples):

% createdb miUML
% createuser yourname
% cd $miumlhome
% psql miUML

Note that createdb and createuser commands are supplied by PostgreSQL.  On my
system (where I've used macports to install PostgreSQL) I get this:

% which createdb
/opt/local/lib/postgresql91/bin/createdb

STEP 4> Put fmigen into your bin directory

If you look inside the $miumlhome directory you will see an executable file
(it's a bash script) named 'fmigen'.  You need to copy or move this into some
directory on your command path.  I put it in my local bin directory at
/Users/starr/bin
Be sure that the file has execute permission set, like any shell script.

You might want to test, just to be sure.  The script won't do anything useful at this point
and it should create an f.sql file in the current directory.  If it works, delete the
f.sql file and move on to step 5.  It HAS to work before moving on, though since
the reset.sql script triggered in step 5 will call it repeatedly.

STEP 5> Load the metamodel and API functions into your new miUML database

Now for the fun stuff.

You are still in your psql session and let's verify that we are in the correct
directory (very important!)

yourname=# \! pwd
<your path here>/miUML2_tr

(The above path should match the value of $miumlhome)
If it is not, try this:

yourname=# \cd `echo $miumlhome`

Note the use of backticks.

Okay, we're in the correct directory, so just import the goodies:

yourname=# \i reset.sql

At this point, a lot of stuff should fly by on the screen!  Metamodel tables and API
functions are being loaded into your miUML database.

In case you ever want to start over with a fresh database, simply repeat
the \i reset.sql command.  It always starts by wiping the miUML db clean and
reloading everything.

Please understand that we are in the early stages of this beast so things may break.
Don't enter lots of critical data you don't want to lose since we don't yet have any
way of migrating data from one version to the next and the metamodel will certainly
undergo a lot of change in the coming year or two.

The metamodel API is simply a preview of what will come so that you can start dreaming up
compatible draw/text editors, model compilers, import/export schemas and utilities, and
so many other potential facilities.  Have fun!

- Leon Starr, San Francisco, April 2, 2013
leon_starr@modelint.com




