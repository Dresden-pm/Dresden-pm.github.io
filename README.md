# Dresden.pm website

This website is powered by a Markdown to HTML converter that runs on a travis build right after pushing the changes.

## How to encode the SSH private key 

```bash
perl -MSereal::Encoder -MMIME::Base64 -MFile::Slurp -E 'say encode_base64 encode_sereal(scalar read_file "ìd_rsa_filename"), ""'
```

Save the output of this script as environment variable `GITHUBKEY` in the travis repository settings.