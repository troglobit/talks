% Style
% Joachim Wiberg
% April 18, 2019

# Style

- We read code and commit messages every day:
  - "Why does it do this?" → `git blame`
  - "Gah, why doesn't the commit message say *why*?"
  
- Style & Design is not just for end-users
  - Readability
  - Saves time
  - Patterns reveal bugs & design flaws
  
- Be friendly to others, and if not, at least to yourself in two weeks ...

# Coding Style

## Internal Code

- Pick a style for your team/company and be consistent
  - Linux coding style is sth most ppl can agree on
  - Use Emacs cc-mode, or vim, with hinting
  - Use GNU indent or clang-format

- Changing existing code
  - Use same style as in the same file
  - Pay attention to surrounding code
  - If surrounding code is a mess  
    → do a separate commit of coding style cleanup
	
- Check with `git diff` before commit
  - e.g., tabs vs spaces
  - Emacs Magit has preview when comitting -- very usefule
  
## Open Source

- Open Source packages have their own style
- Again, pay attention to surrounding code, use that style!
- Eases upstreaming if patches follow upstream style
- Ask for help:
  - How to use quilt for patch managment
  - How to use GitHub for forks/patches

> **Remember:** do *not* use internal references or customer names in
>  Open Source patches or GitHub!  E.g., commit messages, comments ...

## Recommended C APIs

| **Dangeours**          | **Recommended**         | **Comment**                                 |
|------------------------|-------------------------|---------------------------------------------|
| `sprintf()`            | `snprintf()`            | POSIX.1-2001, POSIX.1-2008, C99             |
| `strcpy()`/`strncpy()` | `strlcpy()`             | Available in -lite, *notice length differs* |
| `strcat()`             | `strlcat()`             | -- " --                                     |
| `gets()`, `fread()`    | `fgets()`               | POSIX.1-2001, C89                           |
| `memcpy()`             | `memmove()`             | POSIX.1-2001, C89, SVr4, 4.3BSD             |
| `time()`               | `sysinfo()` → si.uptime | For relative time                           |
|                        | `clock_gettime()`       | CLOCK_MONOTONIC or CLOCK_BOOTTIME           |
| `gettimeofday()`       |                         | Same as above, unless wall time is intended |
|                        |                         |                                             |

## Comment Style

- Why comment code?
  - Unreadable code segments, "but I've deciphered it!"
  - Code works, but we don't understand why
  - Hidden registers
  
- Avoid commenting on everything

- Less focus on what the code does; *we can also read code ...*

- More **focus on why;** *"Speed change does not bite without PHY reset, see errata N.YY"*

> Can you refactor the code to make it more readable?


## Commit Style

> "Add file"  
> "Weekly commit"

- Use logical commits, not big-bang changes:
  - Add new API
  - Extend feature X with new API
  - Whitespace cleanup of feature X

- Less focus on what -- we can see the what from the diff:
  - *"error fix"*
  - *"update submodule"*

- More **focus on why:**
  - *"Fix issue #1234: speed duplex does not bite"*
  - *"Update after code audit and feedback from team"*
  - *"Update kernel submodule: add sync for mdb host entries"*


## Commit Example

<br /><br /><br />
```text
First-line summary is short, typically <60 chars

Add your findings and reasoning/why to the body, after an empty newline.
This helps tools like "git format-patch" and is generally considererd to
be good form.  Here you can also add references to other issues.

Remember: for open source or external systems, avoid internal references!

Take pride in your work, sign-off on it.

Signed-off-by: User Nameson <user.nameson@example.com>
```
<br /><br /><br />

For details, see the kernel [Developer's Certificate of Origin][1]

[1]: https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
