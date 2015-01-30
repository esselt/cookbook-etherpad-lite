etherpad-lite Cookbook
======================

#### etherpad-lite::default
installs etherpad-lite

Requirements
------------
#### cookbooks
- `nodejs` - etherpad-lite runs on javascript
- `apache` - apache is used for proxy
- `database` - needed to create database with user
- `mysql` - set up mysql service

Attributes
----------

The following attributes should be set based on your specific deployment, see the
`attributes/default.rb` file for default values. All values should be strings unless otherwise specified.



Usage
-----
#### etherpad-lite::default

Override any defaults and then include the recipe in your run list or cookbook.

e.g.
Just include `etherpad-lite` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[etherpad-lite]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

License: Apache 2.0

Authors: 

* Boye Holden
* OpenWatch FPC
* @computerlyrik original version (https://github.com/computerlyrik/chef-etherpad)
* @reidab