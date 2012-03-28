# Contribution Guide

## Get Data

Run `rake prepare`.

## Write Tests

We don't really do unit tests for the parser, there are only
total/integration/whatever tests. Put your proposed output for an
article into `test/data/:lang/:sr/:id`, without the 'a' present in the
html path.

## Run Tests

`rake test`

## Everything else

You know the drill - fork, pull request.
