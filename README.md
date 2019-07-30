Baking Factory: Project for 67-272 Application Design and Development
---
67-272 is a course in the Carnegie Mellon University Information Systems curriculum that is aimed at teaching students the principles of good software design and construction. Throughout the course, we were taught about unit tests, the MVC framework, design and information principles, APIs, and more. 

This project was created to satisfy a hypothetical scenario as laid out by my professor. We would have to construct an 
e-commerce system to enable customers to order items, and for those items to be baked and shipped accordingly.

To set this up, clone this repository, run the `bundle install` command to ensure you have all the needed gems and then create the database with `rake db:migrate`.  If you want to populate the system with fictitious, but somewhat realistic data, you can run the `rake db:populate` command.  The populate script will create:
- 120 customers
- over 600 orders
- a menu of 5 types of breads, 3 varieties of muffins and 1 type of pastry

keep in mind that the populate script only works if you keep the default `sqlite3` database. If you try to switch to Postgres, the populate script will not work, and you will have to make a seeds file.

I hope you enjoy my project!
