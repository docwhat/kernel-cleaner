# Kernel Cleaner

This script will output all the ubuntu kernel packages that are not:

* The currently running kernel image.
* The latest kernel image installed.
* The latest - 1 kernel image installed.

## Usage

Copy `kernel-cleaner.rb` to your system.

Then run:

```bash
ruby kernel-cleaner.rb -0 | xargs -0 apt-get purge -y
```

You can put the above line a cron job.
