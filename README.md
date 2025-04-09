# Berry

Berry is a multipurpose cli tools for creating files and directory (and more soon...). Not only that, berry can also create to-do task (which is not yet implemented). It is a toy project not intended for anyone to use. It is simply made for fun.

Berry supposedly stands for "Better Directory" but really, it isn't. Should be named worry instead, you know what I meant.

## Installing

I haven't published this as a gem yet so you'll have to do it manually.

```bash
# Install all of the required gems 
bundle install

# Build and install berry as a gem
Rake install

# Run berry
berry
```

## Example

#### Creating a directory with a description

```bash
# Usage: berry make <filepath> [options]
berry make my_directory -d "Hello, World!"

# Usage: berry ls <filepath>
berry ls

# Output
some_other_directory
my_directory
  ↳ Hello, World!
other_directory
```

# License

Released under the MIT License.  See the [LICENSE][] file for further details.

[license]: LICENSE