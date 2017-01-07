# Dresden.pm website

This website is powered by a Markdown to HTML converter that runs on a travis build right after pushing the changes.

# WORKFLOW

You only have to do the first part yourself, everything else is done automatically.

## 1. Edit markdown files

Make changes in the markdown files in the `markdown` folder. Commit and push.

## 2. Automatic conversion powered by Travis

After pushing the changes to our Github repository, travis automatically starts a build. See the `.travis.yml` file for details of the implementation.

* Clone this repository
* Execute the `converter.pl` script which translates every `*.md` file in the `markdown` folder into an html file in the root folder. Therefor it uses the `index.tt` and replaces `##content##` with the HTML representation of the markdown file.
* Commit the changes.
* Push changes to Github.

# SETUP

## Github Deploy Key

The build server must be able to push back to the Github repository. As we do not want anyone to be able to do that, we could not provide the Github deploy key in the repository itself. The solution is to save it in an environment variable setup by travis. These are private, so no one can extract the private key.

As the environment variable only allows values without line breaks, we encoded the SSH private key file:

### How to encode the SSH private key

```bash
perl -MSereal::Encoder -MMIME::Base64 -MFile::Slurp -E 'say encode_base64 encode_sereal(scalar read_file "ìd_rsa_filename"), ""'
```

Save the output of this script as environment variable `GITHUBKEY` in the Travis repository settings.

# IMPLEMENTATION DETAILS

We want Git to use a special private key for authenticating with Github. Therefor we saved this key as `id_rsa_una`. You can set the `GIT_SSH` environment variable when running `git` which tells which SSH client to use. Setting it to a shell script that adds some options to the `ssh` command allows us to provide the private key's file name.