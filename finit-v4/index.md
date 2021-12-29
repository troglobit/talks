% Finit v4
% Joachim Wiberg
% April 26, 2021

# Removed
## features

- Built-in inetd support, instead use:
  - openbsd-inetd
  - BusyBox inetd
  - and iptables

- Fallback shell  
  → use new `tty` option flags instead

- Emergency shell  
  → replaced with rescue mode (next slide)

- `HOOK_SVC_START` and `HOOK_SVC_LOST` -- too fragile


# New
## features

- Major updates to initctl tool, commands + output changes
- Environment files for `services`, with dependency tracking
- tty’s are now services (finally!)  
  → conditions, enable/disable, start/stop, status, ...
- SysV init script support
- pre-/post-script support for init and cleanup tasks
- Proper rescue mode with `sulogin` for basic protection
- Automatic network bringup if `/etc/network/interfaces` exists

## cgroups v2

- Default groups:
  - init (100)
  - system (9800)
  - user (100)
- Support for configuring groups and membership
- No real-time process support yet (kernel limitation)
- Standard cgroup v2 syntax in:
  - `finit.conf` for defining/modifying groups
  - `finit.d/*.conf` for per-service group assignment
- New tooling to inspect resource use:

        initctl ps
        initctl top
        initctl cgroup

## initctl changes

- service identity same as in .conf file  
  job:id → name:id

        name:foo
        :id

- greatly improved output from

        initctl status
        initctl status foo

## initctl commands

```
initctl status foo                 # Show status of service foo
initctl show foo                   # show foo.conf
initctl edit [-c] foo              # edit (optionally create) foo.conf
initctl touch foo                  # mark foo.conf as modified for reload
initctl cond [set,clear] usr/bar   # user defined (static & oneshot) conditions
initctl ps                         # tree view of known services with arguments
initctl top                        # top like view of services (cgroups)
initctl cgroup                     # cgroup view of services (limits)
```

# In-Depth

## pre/post scripts

- Available for service stanzas

        service pre:/path/to/script.sh  foo -args -- Foo service
        service post:/path/to/script.sh bar -args -- Bar service

- Runs before services transition to READY state, conditions do the rest
- Runs after services have transitioned to STOPPING state, for cleanup task
- Default timeout for scripts: 3 sec, customize with general kill delay

        service post:/path/to/script.sh kill:10 baz -args -- Baz service

## environment files

- Available for service stanzas

        service env:/etc/default/foo foo -n $FOO_ARGS -- Foo service

- Changes to `/etc/default/foo` are tracked as dependency to `foo` service
- Changes to environment files take effect after `initctl reload`
- Example:

        $ cat /etc/default/foo
        FOO_ARGS=”-args”

## cgroups v2

- Global configuration of groups, std.kernel syntax in
  `/etc/finit.conf` or `/etc/finit.d/*.conf` files.  For an overview,
  use `initctl cgroup`:

        cgroup init   cpu.weight 100
        cgroup user   cpu.weight 100
        cgroup hej    cpu.weight 100
        cgroup system cpu.weight 9700

- All run/task/services are by default placed in the system group
- Local getty are placed in the user group
  - Need PAM plugin to move PID of SSH and telnet users after login

- Per service selection of group, or for a set of tasks:

        cgroup.hej:mem.max:12345
        system [23] <pid/foo> bar -- Bar service
        system [23] <pid/foo> baz -- Baz service

- Per service tweaking of limits also possible:

        system [23] <pid/foo> cgroup.hej:mem.max:12345 frob -- Frob service

- Changes to cgroup configuration changes take effect after `initctl reload`


# Demo

<script id="asciicast-410316" src="https://asciinema.org/a/410316.js" async></script>

# Fin

Join the [discussion on GitHub][1] or  
#troglobit on Liberachat if IRC is more your thing.

[1]: https://github.com/troglobit/finit/discussions/169
