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

### 1. Create SSH key

```bash
ssh-keygen -t rsa -b 4096 -C "someone@dresden.pm" -f dresdenpm_id_rsa
```

The passphrase must be left empty!

### 2. Add public key to Github

Go the Github repository settings -> Deploy keys and click "Add deploy key". Choose a meaningful title and paste the content of the file `dresdenpm_id_rsa.pub` into the key text field. Choose "Allow write access" and click "Add key".

### 3. Add private key to Travis

As the environment variable only allows values without line breaks, we encode the SSH private key file twice:

```bash
perl -MSereal::Encoder -MMIME::Base64 -MFile::Slurp -E 'say encode_base64 encode_sereal(scalar read_file "dresdenpm_id_rsa"), ""'
```

We wanted to avoid line breaks (thats why we used `Sereal`) and we wanted only sane characters (that's why we used `MIME::Base64`). There are probably better/easier ways, but this works well, too.

Save the output of this script as environment variable `GITHUBKEY` in the Travis repository settings.

# IMPLEMENTATION DETAILS

## Tell Git which SSH key to use

We want Git to use a special private key for authenticating with Github. Therefor we saved this key as `id_rsa_una`. You can set the `GIT_SSH` environment variable when running `git` which tells which SSH client to use. Setting it to a shell script that adds some options to the `ssh` command allows us to provide the private key's file name.

## Two subsequent builds

As the build process is always triggered after a new commit is pushed to the Github repository, it is also started after the converter has committed the new html files and pushed them. But as the second run does not result in any changes, it does not create a new commit. This way, we have no infinite loop.

If you change the converter to allow more than a static conversion, you have to think about this again.

## Integrated monitoring

As travis is a continuous integration service, it will instantly send an email to you if a build fails. This way you can be nearly sure that problems in the build process will be signaled to you. Every command in the "script" section of the `.travis.yml` file must be executed successfully for the build to be marked as "passed". I added "true" before `git commit` because it also fails if no changes have been made (which is especially the case in the second build that get's triggered by the conversion).

# IMPROVEMENT IDEAS

## Separate repositories

Source and output repositories could be separated, so the markdown, the converter script and the travis.yml would not live in the repository that contains the HTML files.

The safest way would be three repositories:

1. The source repository only containing the markdown files and the HTML template.
2. The converter software.
3. The output repository only containing the generated HTML.

With this setup you could restrict access to the third repository only to the deploy key of the converter software. So the maintainers of the website source are not directly able to edit the converter workflow.

The `.travis.yml` would only clone the converter repository and execute a shell script there that runs everything we currently define in the `.travis.yml` configuration file.
