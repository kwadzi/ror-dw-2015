ror-ec-2014
===========

Ruby on Rails crash course around the Eastern Cape

This website is available at [http://ict4g.github.io/ror-ec-2014](http://ict4g.github.io/ror-ec-2014/)

## About Previewing and Deploying

This website is written using [octopress](https://github.com/octopress/octopress) and the deployment uses [octopress-deploy](https://github.com/octopress/deploy). 

For this reason, the `master` branch contains all the working files, and the `gh-pages` branch contains only the *production* files. 

### Preview

When you modify the website you **MUST** work in the `master` branch and preview what your are doing by executing `octopress serve --watch` and by visiting [http://localhost:4000/ror-ec-2014/](http://localhost:4000/ror-ec-2014/).

Once you have finished just `git commit` and `git push`.

### Deployment

When you deploy for the first time, please be sure to [setup correctly](https://github.com/octopress/deploy) your deployment configuration files (basically you must have a properly configured `_deploy.yml` file). 

Finally, **DEPLOY** with `octopress deploy`. This will automatically push the content of `_site/` in the `gh-pages` branch.  <br>
**Don't do this manually**.
