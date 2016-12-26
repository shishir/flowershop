# Assumptions/Constraints

- Built/tested against ruby 1.9.3.

- Assumes rake and test-unit gems are available to the ruby. test-unit is included in ruby 1.9.3. It was one of the reasons why I picked up ruby 1.9.3. If you wish to test against higher versions of ruby, you would have to install test-unit. You can edit the Gemfile and do bundle install.

- The structure of code loosely represents that of a Rubygem. But since I see it as a script than a library. I did not bundle it as a ruby gem.

- Input of Standard I/O is terminated when <ENTER> key is pressed *twice*.

- *ShopTest::test_shop_to_sell_multiple_items* is the functional test. The input mentioned in the problem statement.

- No Validation added.

- Assumes the input is always one of Roses(R12), Lilies(L09) or Tulips(T58). This can be changed in the load_catalog method. Currently, there is not way to take catalog input from the command line.


# Run Code

$ cd <PROJECT_ROOT>
$ bundle install

$ ./bin/flower_shop

The *bin_file* is the entry point if one wants to input code via console. It follows the same input pattern as specified in the problem statement. Hitting *<enter>-key* twice, exists the input, runs the code and prints output.

*Note*: you might have to mark the bin/flower_shop executable. You may use chmod u+x bin/flowershop

# Run Test

$ cd <PROJECT_ROOT>
$ bundle install

$ rake test

