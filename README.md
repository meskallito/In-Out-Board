In/Out Board
==================================================

How to run it
----------------------------

Install gems

```bash
bundle install
```


Create DB

```bash
rake db:create
rake db:schema:load
```


Run Private_pub server

```bash
rackup private_pub.ru -s thin -E production
```


Run application

```bash
rails s
```
