# HowlinBash.com

This is the static Howlin Bash website located at https://www.howlinbash.com

## Dependencies
- [Blogposts](https://www.github.com/howlinbash/blogposts)
- [Theme](https://www.github.com/howlinbash/heidi)

## Developing

I use the scripts in ```/build-scripts``` to develop the site.  
I alias the `main.sh` script to `hb` in my personal `~/bin` directory.

### Theme Development

The theme, [Heidi](https://www.github.com/howlinbash/heidi), is developed as a seperate ruby gem.

Move posts, pages & config from site repo to theme repo for development:
```
hb load
```

Serve and watch theme:
```
hb serve
```

Test theme by pushing, pulling and building from local gem server:
```
hb test
```

Update theme version number commit changes and post gem to rubygems.org:
```
hb bump
```

Deploy changes:
```
hb deploy
```

### Blogposts

Blogposts are developed from the blogpost repo.

You can also deploy changes with the ```hb deploy``` command.

### Site

Any other changes are made from this repo.

All changes from other repos (and this) are pushed with ```hb deploy```.
