---
title: sysklogd intro
author: Joachim Wiberg
date: November 25, 2019
theme: metropolis
aspectratio: 1610
fontsize: 9pt
aspectratio: 1610
lang: en-US
section-titles: false
link-citations: true
link_attributes: true
---

## Agenda

- Standards & Formats
- syslogd
- API

---

# Standards & Formats

---

## 4.3BSD, June 1986

- First release of syslogd
- Many operating systems adopted this, BSD impl. was reference
- Local disk format

        Aug 24 05:14:15 192.0.2.1 Kilroy was here.

- Remote port UDP/514
- Remote syslog format (wire)

        <23>Kilroy was here.

---

## RFC3164, August 2001

- Standardization of the 4.3BSD syslogd format and behavior

        <PRI>Month Day-of-month Time-of-day <MSG>
        
        PRI := (facility << 3) | severity
        MSG := [Hostname] [Process[pid]:] text

- Priority field standardized/documented
  - Facility/subsystem codes
  - Severity/level codes
  
- ... many systems use facility codes differently

- Local disk format

        Aug 24 05:14:15 192.0.2.1 myproc[8710]: Kilroy was here.

- Remote syslog format (wire)

        <23>Aug 24 05:14:15 192.0.2.1 myproc[8710]: Kilroy was here.

---

## RFC5424, March 2009

- Changes everything!

         <PRI>1 Timestamp Hostname App-name ProcID MsgID SD MSG

- Timestamp in RFC3339 format
- Standardizes de-facto fields: _Hostname_, _App-Name_, _ProcID_
- Adds new fields: _Version_, _MsgID_, _Structured-Data_
- *Technically* obsoletes RFC3164, in practice both coexist
- Local disk format

        2019-11-04T00:50:15.001234+01:00 troglobit myproc 8710 - - Kilroy was here.

- Remote syslog format (wire)

        <23>1 2019-11-04T00:50:15.001234+01:00 troglobit myproc 8710 - - Kilroy was here.

- MsgID can be any string without a space character
- Structured Data:

        [exampleSDID@32473 iut="3" eventSource="Application" eventID="1011"]

# syslogd

---

## sysklogd vs syslog-ng vs rsyslogd

- sysklogd is pure UNIX
- rsyslogd is derived from an older version of sysklogd  
  written by Rainer Gerhards, who wrote RFC5424
- syslog-ng and rsyslogd support SQL/NoSQL front/back-ends

---

## sysklogd strengths

- Based on FreeBSD syslogd
- Fully supports RFC3164 and RFC5424
- NetBSD syslogp() API for native RFC5424 support
- Small ~60 kiB

---

## sysklogd future work

- RFC6587: Reliable syslog, TCP (maybe)
- RFC5425: TLS support (likely)
- RFC5848: Signed syslog messages (yes!)

# API

---

## Existing API

- POSIX syslog() as implemented in GLIBC, musl-libc, uClibc
- Only supports RFC3164

---

## NetBSD API

- sysklogd comes with a syslog() replacement API (optional)
- applications must use syslogp() for RFC5424 features
- example:

        openlog("example", LOG_PID, LOG_USER);
        syslogp(LOG_NOTICE, "MSGID", NULL, "Kilroy was here.");
        closelog();

---

# Fin

Join the [discussion on GitHub][1] or  
#troglobit on Liberachat if IRC is more your thing.

[1]: https://github.com/troglobit/sysklogd/discussions/
