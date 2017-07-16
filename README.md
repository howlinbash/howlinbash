# HowlinBash.com

## Dependencies
- [Blogposts](https://www.github.com/howlinbash/blogposts)
- [Theme](https://www.github.com/howlinbash/heidi)

## Developing

I use the scripts in ```/build-scripts``` to develop the site

### Theme

The theme is developed as a seperate ruby gem.

```bash
# Move posts, pages & config from site repo and start local dev server
dev

# Make changes, commit them and when ready, post to rubygems.org
bump

# Check changes with local image
sdev

# Deploy changes 
deploy
```

### Blogposts

Blogposts are developed from the blogpost repo.

You can also deploy changes with the ```deploy``` command.

### Site

Any other changes are made from this repo.

All changes from other repos (and this) are pushed with ```deploy```.
