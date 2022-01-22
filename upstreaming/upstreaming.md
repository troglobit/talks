---
title: Upstreaming Patches -- an introduction
subtitle: The Why, What, & How ...
author: Joachim Wiberg
date: January 20, 2022
theme:
 - night
colortheme:
 - solarized
aspectratio: 1610
papersize: a4wide
fontsize: 10pt
width: 1920
height: 1280
minScale: 0.1
maxScale: 5.0
transition: none
lang: en-US
section-titles: false
link-citations: true
link_attributes: true
---


## Agenda

 - Why?
 - What?
 - How?

# Why?

---

## Reasons for Upstreaming
 
  - Costly to maintain in-house over time
  - Delays OSS package upgrades:
    - Critical customer releases get delayed
    - CVEs go unfixed for long periods of time
    - Projects start backporting new upstream features
    - Random instability issues -- bad backports
    - Complexity increases further ...
  - Most in-house patches are *not core business*
    - Integration changes, e.g., build system, logging, ...
    - Backported fixes/features
    - In-house fixes and even new features

## Reasons for NOT Upstreaming

  - "Complicated upstreaming process ... a mailing list?"
  - "Takes too long ..."
  - "We'll do it later ..."
  - "Why should we help our competition?"

## Actual Reasons

  - Not in checklist for project's *Definition of Done*
  - Projects have due dates:
    - upstreaming is a line activity
	- no time reserved for devs
  - Unclear if it's allowed -- *everything* classified as
    - intellectual property
    - business critical
  - Weak (or no) line organization
  - Percieved cost
 
## Benefits of Upstreaming

  - Reduced maintenance overhead
  - Easier package upgrades
  - Increased stability
  - Interoperability
  - Cost savings
  - Free audit by experienced developers!
    - Great feedback improves our developers
  - Over time, builds a good reputation for the company
    - Great PR with little goodwill
    - Attracts other great developers ... hard to find otherwise
  - Empowering developer's increases engagement with the company

:::

Interop: end-customer often wants or needs to use multiple vendors.
Not sharing changes with competition can lead to interop issues.

:::

# What?

---

## What Should be Upstreamed?

  - Possibly huge backlog of patched packages
  - Prioritize!
  - Top 5 most important OSS packages
  - Top 5 most important/painful patches in each
  - Lather, rinse, repeat ...

## What Should NOT be Upstreamed?

  - `integration.patch`
    - Odd build fixes for internal build system
	- Other integration into our product
  - Disabling of package syslog messages
  - Changes to package identity:
    - hide exact package/version in port scanning
	- logs which can be sent as clear text over the wire
  - Other Company specific patches

## Big No-Nos

  - HTML email
  - Code dumps:
    - Complete source tree dumped on GitHub
	- HTML email to mailing list pointing to dump URL
	- "Hey, you may want this ... bye"
  - Email footers saying "message contains classified information"
    - Usually added indiscriminately by Company IT dept. to all email
	- Ask IT or local manager to disable
	- Use another email provider
  - Asserting "your right" or "this must be fixed" in forums/mailing lists
	- Company *did not pay* to use the OSS packge
    - Be humble
    - The OSS License clearly defines your rights

# How?

---


## Taking Inventory

  - What do we have?
  - Prioritize, as mentioned previously
  - Which ones are most painful to port when upgrading?
  - Classify:
    - Integration (never upstream)
	- Too specific -- discuss; can it be generalized?
	- Candidate -- add to backlog


## Audting Candidates

  - Internally in team first
  - Be tough on each other, it's just code
  - Clean up coding style to match upstream project's style, or at
    least surrounding code
  - Split patches into logical changes, appreciated by upstream,
      useful when bisecting:
    - Add feature X
    - Use feature X
    - Offloading support for feature X
  - Sign-off/Reviewed-by on each others patches if project uses
    Developer Certificate of Origin

