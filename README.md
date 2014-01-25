According to the discussion on the [CHEF-3694] ticket, resource cloning, a technique many official community cookbooks rely on, is being deprecated. As such, you get a lot of warnings like this when using off-the-shelf cookbooks:

```
[2014-01-24T16:15:55+00:00] WARN: Cloning resource attributes for package[perl] from prior resource (CHEF-3694)
[2014-01-24T16:15:55+00:00] WARN: Previous package[perl]: /tmp/vagrant-chef-1/chef-solo-1/cookbooks/perl/recipes/default.rb:26:in `block in from_file'
[2014-01-24T16:15:55+00:00] WARN: Current  package[perl]: /tmp/vagrant-chef-1/chef-solo-1/cookbooks/iptables/recipes/default.rb:21:in `from_file'
```

This cookbook monkey-patches Chef to try a new idea...instead of cloning resources, it tries to _reuse_ them and _merge_ their actions together. This circumvents the warning and _seems_ to make all the cookbooks that I am using function properly.

This is not well-tested at this time. See my larger discussion of the issue and the solution discovery on my blog post about this.
