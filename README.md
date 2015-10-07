ror-dw-2015
===========

Ruby on Rails crash course around the Eastern Cape

This website is available at [http://ict4g.github.io/ror-dw-2015](http://ict4g.github.io/ror-dw-2015/)

## About Previewing and Deploying

This website is written using [octopress](https://github.com/octopress/octopress) and the deployment uses [octopress-deploy](https://github.com/octopress/deploy). 

For this reason, the `master` branch contains all the working files, and the `gh-pages` branch contains only the *production* files. 

### Preview

When you modify the website you **MUST** work in the `master` branch and preview what your are doing by executing `jekyll serve --watch` and by visiting [http://localhost:4000/ror-dw-2015/](http://localhost:4000/ror-dw-2015/).

Once you have finished just `git commit` and `git push`.

### Deployment

When you deploy for the first time, please be sure to [setup correctly](https://github.com/octopress/deploy) your deployment configuration files (basically you must have a properly configured `_deploy.yml` file). 

Before deploying be sure you have a **local** branch `gh-pages` in your repo. 

Finally, **DEPLOY** with `octopress deploy`. This will automatically push the content of `_site/` in the `gh-pages` branch.

**Don't do this manually**.
